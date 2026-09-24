




select
    id_orden_reparacion,
    id_cargo,
    fec_apertura_or,
    fec_cierre_or,
    num_factura,
    id_cuenta_cargo,
    tpo_or,
    tpo_facturacion,
    sum_total_mo,
    sum_total_recambios,
    cod_marca,
    des_marca,
    id_vehiculo,
    id_taller,
    ud_km_or,
    cat_estado_or,
    des_estado_or,
    aud_dte_snapshot,
    aud_tst_ingestion
from [wh_silver].[int_posventa].[pasos_cargo_collapsed]
