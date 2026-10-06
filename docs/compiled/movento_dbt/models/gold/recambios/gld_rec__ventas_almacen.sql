

-- Tabla de hechos de ventas de almacen a nivel de linea, el grano de origen de la sabi.
-- Lee del staging directamente porque no hay grano que colapsar. El canal (taller,
-- exterior...) sale de dim_tipos_venta por tpo_venta.
--
-- imp_venta es imp_total_linea, lo facturado. imp_total_base_imponible no se incluye: es
-- el total de la venta repetido en cada linea, y sumarlo aqui lo multiplicaria por el
-- numero de lineas.
--
-- La cifra de negocio de recambios a exterior se valora a PVP con el descuento de
-- deferencia (imp_venta_pvp) y cuenta solo las lineas con ind_venta_exterior: las que no
-- salen a taller, sin los traspasos internos ni la venta interna de mostrador. Los
-- recambios a taller no salen de aqui sino de facts_or_cargo, por la OR.



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
    ROUND(ud_unidades_venta * imp_pvp_unitario * (1 - rat_descuento_deferencia / 100), 2)
        AS imp_venta_pvp,

    CASE
        WHEN COALESCE(ref_ind_salida_taller, 'N') = 'N'
            AND tpo_venta NOT IN ('G1', 'G3', 'M1')
            THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END AS ind_venta_exterior,

    CAST(
        '2026-10-06 16:23:33'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[stg_qbi].[ventas_almacen]