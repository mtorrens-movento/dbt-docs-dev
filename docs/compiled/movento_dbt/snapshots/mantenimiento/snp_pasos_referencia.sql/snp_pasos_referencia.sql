




select
    id_orden_reparacion,
    fec_apertura_or,
    max_fecha_cierre,
    num_factura,
    sum_total_mo,
    sum_total_recambios,
    id_vehiculo,
    ud_km_or,
    id_taller,
    cod_marca,
    des_marca,
    aud_dte_snapshot,
    aud_tst_ingestion
from [wh_silver].[int_posventa].[pasos_referencia_collapsed]
