

with base as (
    select
        id_vehiculo,
        num_bastidor,
        fec_matriculacion,
        aud_dte_snapshot,
        aud_tst_ingestion
    from [wh_silver].[stg_qbi].[vehiculos]
    where id_vehiculo is not null
),

ultima_or as (
    select
        id_vehiculo,
        max_fecha_cierre as fec_referencia_km,
        ud_km_or as ud_km_actual,
        aud_dte_snapshot,
        aud_tst_ingestion,
        row_number() over (
            partition by id_vehiculo
            order by
                max_fecha_cierre desc
        ) as rn
    from [wh_silver].[int_posventa].[pasos_referencia_collapsed]
    where id_vehiculo is not null
),

base_con_or as (
    select
        b.id_vehiculo,
        b.num_bastidor,
        b.fec_matriculacion,
        uo.fec_referencia_km,
        uo.ud_km_actual,
        greatest(b.aud_dte_snapshot, uo.aud_dte_snapshot) as aud_dte_snapshot,
        greatest(b.aud_tst_ingestion, uo.aud_tst_ingestion) as aud_tst_ingestion
    from base b
    left join ultima_or uo
        on uo.id_vehiculo = b.id_vehiculo
       and uo.rn = 1
),

edad_vehiculo as (
    select
        id_vehiculo,
        num_bastidor,
        fec_matriculacion,
        fec_referencia_km,
        ud_km_actual,
        aud_dte_snapshot,
        aud_tst_ingestion,
        case
            when fec_matriculacion is null then null
            when fec_referencia_km is null then null
            when fec_matriculacion > fec_referencia_km then null
            else datediff(day, fec_matriculacion, fec_referencia_km)
        end as ud_dias_desde_matriculacion
    from base_con_or
)

select
    id_vehiculo,
    num_bastidor,
    fec_matriculacion,
    fec_referencia_km,
    ud_km_actual,
    ud_dias_desde_matriculacion,
    round(
        case
            when ud_km_actual is null or ud_dias_desde_matriculacion is null then null
            else ud_km_actual / cast(
                case
                    when ud_dias_desde_matriculacion < 1 then 1
                    else ud_dias_desde_matriculacion
                end as decimal(18, 6)
            )
        end,
        2
    ) as ud_km_medio_diario,
    round(
        case
            when ud_km_actual is null or ud_dias_desde_matriculacion is null then null
            else (
                ud_km_actual / cast(
                    case
                        when ud_dias_desde_matriculacion < 1 then 1
                        else ud_dias_desde_matriculacion
                    end as decimal(18, 6)
                )
            ) * 30.4375
        end,
        2
    ) as ud_km_medio_mensual,
    aud_dte_snapshot,
    aud_tst_ingestion,
    cast(coalesce(aud_tst_ingestion, cast(aud_dte_snapshot as datetime2(0)), cast('2026-09-25 11:30:52' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from edad_vehiculo