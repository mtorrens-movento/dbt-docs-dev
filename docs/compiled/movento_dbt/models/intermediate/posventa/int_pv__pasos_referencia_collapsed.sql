

with base as (
    select
        id_orden_reparacion,
        fec_apertura_or,
        fec_cierre_or,
        num_factura,
        id_vehiculo,
        ud_km_or,
        id_taller,
        imp_total_mano_obra,
        imp_total_materiales,
        cod_marca,
        des_marca,
        seq_linea_or,
        id_cargo,
        cat_estado_or,
        
    case
        when fec_apertura_or is null or hora_apertura_or is null then null
        else dateadd(
            second,
            datediff(second, cast('00:00:00' as time(0)), try_cast(left(cast(hora_apertura_or as varchar(20)), 8) as time(0))),
            cast(cast(fec_apertura_or as date) as datetime2(0))
        )
    end
 as tst_apertura,
        
    case
        when fec_primer_fichaje is null or hora_primer_fichaje is null then null
        else dateadd(
            second,
            datediff(second, cast('00:00:00' as time(0)), try_cast(left(cast(hora_primer_fichaje as varchar(20)), 8) as time(0))),
            cast(cast(fec_primer_fichaje as date) as datetime2(0))
        )
    end
 as tst_primer_fichaje,
        
    case
        when fec_ultimo_fichaje is null or hora_ultimo_fichaje is null then null
        else dateadd(
            second,
            datediff(second, cast('00:00:00' as time(0)), try_cast(left(cast(hora_ultimo_fichaje as varchar(20)), 8) as time(0))),
            cast(cast(fec_ultimo_fichaje as date) as datetime2(0))
        )
    end
 as tst_ultimo_fichaje,
        fec_entrega_vehiculo,
        
    case
        when fec_entrega_vehiculo is null or hora_entrega_vehiculo is null then null
        else dateadd(
            second,
            datediff(second, cast('00:00:00' as time(0)), try_cast(left(cast(hora_entrega_vehiculo as varchar(20)), 8) as time(0))),
            cast(cast(fec_entrega_vehiculo as date) as datetime2(0))
        )
    end
 as tst_entrega,
        
    case
        when fec_cierre_or is null or hora_cierre_or is null then null
        else dateadd(
            second,
            datediff(second, cast('00:00:00' as time(0)), try_cast(left(cast(hora_cierre_or as varchar(20)), 8) as time(0))),
            cast(cast(fec_cierre_or as date) as datetime2(0))
        )
    end
 as tst_cierre,
        aud_dte_snapshot,
        aud_tst_ingestion
    from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
    where id_orden_reparacion is not null
),

-- Instantes del ciclo de reparacion a nivel de OR. La apertura y el primer fichaje
-- son los mas tempranos de sus cargos, y el ultimo fichaje, la entrega y el cierre,
-- los mas tardios. Si la fecha extrema no tiene hora, el instante queda nulo en vez
-- de tomar la hora de otro cargo de otro dia.
instantes_or as (
    select
        id_orden_reparacion,
        case when min(cast(tst_apertura as date)) = min(fec_apertura_or)
            then min(tst_apertura) end as tst_apertura,
        min(tst_primer_fichaje) as tst_primer_fichaje,
        max(tst_ultimo_fichaje) as tst_ultimo_fichaje,
        max(fec_entrega_vehiculo) as fec_entrega_vehiculo,
        case when max(cast(tst_entrega as date)) = max(fec_entrega_vehiculo)
            then max(tst_entrega) end as tst_entrega,
        case when max(cast(tst_cierre as date)) = max(fec_cierre_or)
            then max(tst_cierre) end as tst_cierre,
        count(distinct id_cargo) as num_cargos,
        case when min(case when cat_estado_or = 'C' then 1 else 0 end) = 1
            then 1 else 0 end as ind_or_cerrada
    from base
    group by
        id_orden_reparacion
),

-- Los importes son del cargo y vienen repetidos en cada una de sus lineas: se
-- toma uno por cargo y despues se suman los cargos de la OR. Sumar las lineas
-- directamente multiplicaria el importe por el numero de lineas de cada cargo.
importes_cargo as (
    select
        id_orden_reparacion,
        id_cargo,
        max(coalesce(imp_total_mano_obra, 0)) as imp_mano_obra,
        max(coalesce(imp_total_materiales, 0)) as imp_materiales
    from base
    group by
        id_orden_reparacion,
        id_cargo
),

fecha_cierre_or as (
    select
        id_orden_reparacion,
        max(fec_cierre_or) as max_fecha_cierre
    from base
    group by
        id_orden_reparacion
),

importes_or as (
    select
        id_orden_reparacion,
        sum(imp_mano_obra) as sum_total_mo,
        sum(imp_materiales) as sum_total_recambios
    from importes_cargo
    group by
        id_orden_reparacion
),

agregados_or as (
    select
        f.id_orden_reparacion,
        f.max_fecha_cierre,
        i.sum_total_mo,
        i.sum_total_recambios
    from fecha_cierre_or f
    left join importes_or i
        on i.id_orden_reparacion = f.id_orden_reparacion
),

ranked as (
    select
        b.id_orden_reparacion,
        b.fec_apertura_or,
        b.num_factura,
        b.id_vehiculo,
        b.ud_km_or,
        b.id_taller,
        b.cod_marca,
        b.des_marca,
        b.aud_dte_snapshot,
        b.aud_tst_ingestion,
        row_number() over (
            partition by b.id_orden_reparacion
            order by
                b.aud_tst_ingestion desc,
                b.aud_dte_snapshot desc,
                b.seq_linea_or desc,
                b.id_cargo desc
        ) as rn
    from base b
)

select
    r.id_orden_reparacion,
    r.fec_apertura_or,
    a.max_fecha_cierre,
    r.num_factura,
    a.sum_total_mo,
    a.sum_total_recambios,
    r.id_vehiculo,
    r.ud_km_or,
    r.id_taller,
    r.cod_marca,
    r.des_marca,
    i.tst_apertura,
    i.tst_primer_fichaje,
    i.tst_ultimo_fichaje,
    i.fec_entrega_vehiculo,
    i.tst_entrega,
    i.tst_cierre,
    i.num_cargos,
    i.ind_or_cerrada,
    r.aud_dte_snapshot,
    r.aud_tst_ingestion,
    cast(coalesce(r.aud_tst_ingestion, cast(r.aud_dte_snapshot as datetime2(0)), cast('2026-10-06 06:55:43' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from ranked r
left join agregados_or a
    on a.id_orden_reparacion = r.id_orden_reparacion
left join instantes_or i
    on i.id_orden_reparacion = r.id_orden_reparacion
where r.rn = 1