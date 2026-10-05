

-- Tabla de hechos de ventas de almacen a nivel de linea, el grano de origen de la sabi.
-- Lee del staging directamente porque no hay grano que colapsar. El canal (taller,
-- exterior...) sale de dim_tipos_venta por tpo_venta.
--
-- La cifra de negocio es imp_total_linea. imp_total_base_imponible no se incluye: es el
-- total de la venta repetido en cada linea, y sumarlo aqui lo multiplicaria por el
-- numero de lineas.

SELECT
    id_orden_venta,
    seq_linea_venta,

    CAST(CONVERT(CHAR(8), fec_movimiento, 112) AS INT) AS id_fecha_movimiento,
    fec_movimiento,

    id_almacen,
    cod_marca_contable AS cod_marca,
    TRY_CAST(cod_marca_almacen AS INT) AS cod_marca_almacen,
    tpo_venta,

    ud_unidades_venta,
    imp_total_linea AS imp_venta,

    CAST(
        '2026-10-05 12:20:16'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[stg_qbi].[ventas_almacen]