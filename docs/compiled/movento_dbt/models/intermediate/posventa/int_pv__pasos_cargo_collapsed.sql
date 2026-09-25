

with base as (
    select
        id_orden_reparacion,
        id_cargo,
        fec_apertura_or,
        fec_cierre_or,
        num_factura,
        id_cuenta_cargo,
        tpo_or,
        tpo_facturacion,
        cod_marca,
        des_marca,
        id_vehiculo,
        id_taller,
        ud_km_or,
        imp_total_mano_obra,
        imp_total_materiales,
        cat_estado_or,
        des_estado_or,
        seq_linea_or,
        aud_dte_snapshot,
        aud_tst_ingestion
    from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
    where id_orden_reparacion is not null
      and id_cargo is not null
),

agregados_or_cargo as (
    select
        id_orden_reparacion,
        id_cargo,
        sum(coalesce(imp_total_mano_obra, 0)) as sum_total_mo,
        sum(coalesce(imp_total_materiales, 0)) as sum_total_recambios
    from base
    group by
        id_orden_reparacion,
        id_cargo
),

ranked as (
    select
        b.id_orden_reparacion,
        b.id_cargo,
        b.fec_apertura_or,
        b.fec_cierre_or,
        b.num_factura,
        b.id_cuenta_cargo,
        b.tpo_or,
        b.tpo_facturacion,
        b.cod_marca,
        b.des_marca,
        b.id_vehiculo,
        b.id_taller,
        b.ud_km_or,
        b.cat_estado_or,
        b.des_estado_or,
        b.aud_dte_snapshot,
        b.aud_tst_ingestion,
        row_number() over (
            partition by b.id_orden_reparacion, b.id_cargo
            order by
                b.aud_tst_ingestion desc,
                b.aud_dte_snapshot desc,
                b.seq_linea_or desc
        ) as rn
    from base b
)

select
    r.id_orden_reparacion,
    r.id_cargo,
    r.fec_apertura_or,
    r.fec_cierre_or,
    r.num_factura,
    r.id_cuenta_cargo,
    r.tpo_or,
    r.tpo_facturacion,
    a.sum_total_mo,
    a.sum_total_recambios,
    r.cod_marca,
    r.des_marca,
    r.id_vehiculo,
    r.id_taller,
    r.ud_km_or,
    r.cat_estado_or,
    r.des_estado_or,
    r.aud_dte_snapshot,
    r.aud_tst_ingestion,
    cast(coalesce(r.aud_tst_ingestion, cast(r.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 12:49:51' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from ranked r
left join agregados_or_cargo a
    on a.id_orden_reparacion = r.id_orden_reparacion
   and a.id_cargo = r.id_cargo
where r.rn = 1