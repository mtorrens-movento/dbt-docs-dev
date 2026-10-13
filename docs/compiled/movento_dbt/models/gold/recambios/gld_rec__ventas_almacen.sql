

-- Tabla de hechos de ventas de almacen a nivel de linea. El canal (taller, exterior...)
-- sale de dim_tipos_venta por tpo_venta. La logica vive en int_rec__ventas_almacen.

SELECT
    id_orden_venta,
    seq_linea_venta,

    CAST(CONVERT(CHAR(8), fec_movimiento, 112) AS INT) AS id_fecha_movimiento,
    fec_movimiento,

    id_almacen,
    cod_marca_contable AS cod_marca,
    cod_marca_almacen,
    tpo_venta,
    id_canal_venta,
    nom_canal_venta,
    id_zona,
    des_zona,
    id_tipo_zona,
    des_tipo_zona,

    ud_unidades_venta,
    imp_venta,
    imp_venta_pvp,
    imp_venta_coste,
    des_motivo_contabiliza_venta,
    ind_contabiliza_venta,
    ind_venta_exterior,

    CAST(
        '2026-10-13 16:31:57'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_recambios].[ventas_almacen]