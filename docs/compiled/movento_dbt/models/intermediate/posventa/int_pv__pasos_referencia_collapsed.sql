

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
        aud_dte_snapshot,
        aud_tst_ingestion
    from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
    where id_orden_reparacion is not null
),

agregados_or as (
    select
        id_orden_reparacion,
        max(fec_cierre_or) as max_fecha_cierre,
        sum(coalesce(imp_total_mano_obra, 0)) as sum_total_mo,
        sum(coalesce(imp_total_materiales, 0)) as sum_total_recambios
    from base
    group by
        id_orden_reparacion
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
    r.aud_dte_snapshot,
    r.aud_tst_ingestion,
    cast(coalesce(r.aud_tst_ingestion, cast(r.aud_dte_snapshot as datetime2(0)), cast('2026-09-24 08:05:02' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from ranked r
left join agregados_or a
    on a.id_orden_reparacion = r.id_orden_reparacion
where r.rn = 1