

with vehiculos as (
    select
        id_vehiculo,
        num_bastidor,
        id_marca,
        id_combustible,
        fec_matriculacion,
        aud_dte_snapshot,
        aud_tst_ingestion
    from [wh_silver].[stg_qbi].[vehiculos]
    where id_vehiculo is not null
),

kms_medios as (
    select
        id_vehiculo,
        ud_km_medio_diario,
        aud_dte_snapshot,
        aud_tst_ingestion
    from [wh_silver].[int_vehiculos].[kms_medios]
),

combustibles as (
    select
        id_combustible,
        id_grupo_combustible
    from [wh_silver].[stg_shp_mdm].[veh_combustibles]
),

reglas_proximo_mantenimiento as (
    select
        id_marca,
        id_grupo_combustible,
        id_tipo_intervencion,
        meses as meses_regla,
        kms as kms_regla
    from [wh_silver].[stg_shp_mdm].[pv_marcas_prox_inter]
),

vehiculo_reglas as (
    select
        v.id_vehiculo,
        v.num_bastidor,
        v.id_marca,
        v.id_combustible,
        v.fec_matriculacion,
        v.aud_dte_snapshot,
        v.aud_tst_ingestion,
        r.id_tipo_intervencion,
        r.meses_regla,
        r.kms_regla
    from vehiculos v
    left join combustibles c
        on c.id_combustible = v.id_combustible
    inner join reglas_proximo_mantenimiento r
        on r.id_marca = v.id_marca
       and (r.id_grupo_combustible = c.id_grupo_combustible or v.id_combustible is null)
),

ultima_intervencion as (
    select
        pc.id_orden_reparacion,
        pc.id_cargo,
        pc.id_vehiculo,
        pc.fec_cierre_or,
        pc.ud_km_or,
        pc.id_taller,
        cti.id_tipo_intervencion,
        cti.des_intervencion,
        greatest(pc.aud_dte_snapshot, cti.aud_dte_snapshot) as aud_dte_snapshot,
        greatest(pc.aud_tst_ingestion, cti.aud_tst_ingestion) as aud_tst_ingestion,
        -- Los dos ultimos criterios son un desempate determinista, no una
        -- preferencia de negocio. Hay 3.645 combinaciones (vehiculo, tipo) con
        -- dos o mas ordenes que comparten fec_cierre_or, aud_tst_ingestion y
        -- aud_dte_snapshot: sin nada mas que las distinga, la ganadora la
        -- elegia el plan de ejecucion y podia cambiar entre builds. Eso movia
        -- el last_update de unos cientos de filas de info_vehi en cada carga
        -- sin que hubiera cambiado ningun dato, y habria ido dejando versiones
        -- falsas en snp_proximas_intervenciones (2026-09-14).
        row_number() over (
            partition by pc.id_vehiculo, cti.id_tipo_intervencion
            order by
                pc.fec_cierre_or desc,
                cti.aud_tst_ingestion desc,
                cti.aud_dte_snapshot desc,
                pc.id_orden_reparacion desc,
                pc.id_cargo desc
        ) as rn
    from [wh_silver].[int_posventa].[cargos_tipo_intervencion] cti
    inner join [wh_silver].[int_posventa].[pasos_cargo_collapsed] pc
        on pc.id_orden_reparacion = cti.id_orden_reparacion
       and pc.id_cargo = cti.id_cargo
),

ultima_intervencion_unica as (
    select
        ui.id_orden_reparacion as id_orden_reparacion_ultima_intervencion,
        ui.id_cargo as id_cargo_ultima_intervencion,
        ui.fec_cierre_or as fec_ultima_intervencion,
        ui.ud_km_or as ud_km_ultima_intervencion,
        ui.id_taller as id_taller_ultima_intervencion,
        ui.id_tipo_intervencion,
        ui.des_intervencion,
        ui.id_vehiculo,
        ui.aud_dte_snapshot,
        ui.aud_tst_ingestion
    from ultima_intervencion ui
    where ui.rn = 1
),

base_calculo as (
    select
        rv.id_vehiculo,
        rv.num_bastidor,
        rv.id_tipo_intervencion,
        ui.des_intervencion,
        rv.meses_regla,
        rv.kms_regla,
        km.ud_km_medio_diario,
        ui.id_orden_reparacion_ultima_intervencion,
        ui.id_cargo_ultima_intervencion,
        ui.fec_ultima_intervencion,
        ui.ud_km_ultima_intervencion,
        ui.id_taller_ultima_intervencion,
        greatest(
            coalesce(rv.aud_dte_snapshot, cast('1900-01-01' as date)),
            coalesce(km.aud_dte_snapshot, cast('1900-01-01' as date)),
            coalesce(ui.aud_dte_snapshot, cast('1900-01-01' as date))
        ) as aud_dte_snapshot,
        greatest(
            coalesce(rv.aud_tst_ingestion, cast('1900-01-01 00:00:00' as datetime2(0))),
            coalesce(km.aud_tst_ingestion, cast('1900-01-01 00:00:00' as datetime2(0))),
            coalesce(ui.aud_tst_ingestion, cast('1900-01-01 00:00:00' as datetime2(0)))
        ) as aud_tst_ingestion
    from vehiculo_reglas rv
    left join kms_medios km
        on km.id_vehiculo = rv.id_vehiculo
    left join ultima_intervencion_unica ui
        on ui.id_vehiculo = rv.id_vehiculo
       and ui.id_tipo_intervencion = rv.id_tipo_intervencion
),

proyeccion as (
    select
        b.id_vehiculo,
        b.num_bastidor,
        b.id_tipo_intervencion,
        b.des_intervencion,
        b.id_orden_reparacion_ultima_intervencion,
        b.id_cargo_ultima_intervencion,
        b.fec_ultima_intervencion,
        b.ud_km_ultima_intervencion,
        b.id_taller_ultima_intervencion,
        b.meses_regla,
        b.kms_regla,
        b.ud_km_medio_diario,
        case
            when b.meses_regla is null or b.fec_ultima_intervencion is null then null
            else dateadd(month, b.meses_regla, b.fec_ultima_intervencion)
        end as fec_prox_por_meses,
        case
            when b.kms_regla is null then null
            when b.ud_km_medio_diario is null or b.ud_km_medio_diario <= 0 then null
            when b.fec_ultima_intervencion is null then null
            -- El tope de 4 años se aplica sobre los dias, no sobre la fecha ya
            -- calculada. Con un km medio diario muy bajo el cociente se dispara a
            -- millones de dias y el dateadd desborda el datetime2 antes de que
            -- nadie pueda compararlo con nada. Acotando primero, el dateadd recibe
            -- siempre un valor razonable.
            --
            -- El nullif es necesario aunque la rama anterior ya descarte el cero:
            -- el motor no garantiza la evaluacion en cortocircuito del case y puede
            -- calcular la division para todas las filas.
            else dateadd(
                day,
                case
                    when ceiling(b.kms_regla / nullif(b.ud_km_medio_diario, 0)) > 1461 then 1461
                    else ceiling(b.kms_regla / nullif(b.ud_km_medio_diario, 0))
                end,
                b.fec_ultima_intervencion
            )
        end as fec_prox_por_km,
        b.aud_dte_snapshot,
        b.aud_tst_ingestion
    from base_calculo b
),

final as (
    select
        p.id_vehiculo,
        p.num_bastidor,
        p.id_tipo_intervencion,
        p.des_intervencion,
        p.id_orden_reparacion_ultima_intervencion,
        p.id_cargo_ultima_intervencion,
        cast(p.fec_ultima_intervencion as datetime2(0)) as fec_ultima_intervencion,
        p.ud_km_ultima_intervencion,
        p.id_taller_ultima_intervencion,
        p.meses_regla,
        p.kms_regla,
        p.ud_km_medio_diario,
        cast(p.fec_prox_por_meses as datetime2(0)) as fec_prox_por_meses,
        cast(p.fec_prox_por_km as datetime2(0)) as fec_prox_por_km,
        cast(coalesce(
            case
                when p.fec_prox_por_meses <= p.fec_prox_por_km then p.fec_prox_por_meses
            end,
            p.fec_prox_por_km,
            p.fec_prox_por_meses
        ) as datetime2(0)) as fec_prox_intervencion,
        p.aud_dte_snapshot,
        p.aud_tst_ingestion
    from proyeccion p
)

select
    f.*, 
    cast(coalesce(f.aud_tst_ingestion, cast(f.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 11:30:52' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final f