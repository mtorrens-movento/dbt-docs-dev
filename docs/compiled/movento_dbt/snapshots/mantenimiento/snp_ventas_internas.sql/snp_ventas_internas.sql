




select
    id_orden_reparacion,
    id_cargo,
    seq_linea_venta,
    id_orden_venta,
    cat_articulo,
    des_articulo,
    cat_familia_articulo_venta,
    des_familia_articulo_venta,
    cat_familia_aprovisionamiento,
    des_familia_aprovisionamiento,
    cat_grupo_neumaticos,
    des_grupo_neumaticos,
    ud_unidades_venta,
    ud_unidades_salida_real,
    imp_pvp_unitario,
    imp_total_linea,
    imp_costo_linea,
    fec_apertura_or,
    fec_salida_pieza,
    aud_dte_snapshot,
    aud_tst_ingestion
from [wh_silver].[int_recambios].[ventas_internas]
