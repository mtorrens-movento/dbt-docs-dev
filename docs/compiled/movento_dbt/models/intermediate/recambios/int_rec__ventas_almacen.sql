

-- Ventas de almacen a nivel de linea, el grano de origen de la sabi.
--
-- imp_venta es imp_total_linea, lo facturado. imp_total_base_imponible no se incluye: es
-- el total de la venta repetido en cada linea, y sumarlo aqui lo multiplicaria por el
-- numero de lineas.
--
-- La cifra de negocio de recambios a exterior se valora a PVP con el descuento de
-- deferencia (imp_venta_pvp) y cuenta solo las lineas con ind_venta_exterior: las que no
-- salen a taller y cuyo tipo de venta va, segun el diccionario, a un canal de las
-- agrupaciones EXTERIOR o AGENTES (RAS). Los canales NO CONTABILIZA (presupuestos, ventas
-- provisionales, traspasos internos...) no tienen agrupacion y quedan fuera. Los recambios
-- a taller no salen de aqui sino de int_pv__or_cargo, por la OR.
--
-- imp_venta_coste es el coste de la linea. Es la venta que se compara con el stock, que
-- tambien esta valorado a coste, para la rotacion de stock.



SELECT
    v.id_orden_venta,
    v.seq_linea_venta,
    v.fec_movimiento,

    v.id_almacen,
    v.cod_marca_contable,
    v.cod_marca_almacen,
    v.tpo_venta,

    v.ud_unidades_venta,
    v.imp_total_linea AS imp_venta,
    ROUND(v.ud_unidades_venta * v.imp_pvp_unitario * (1 - v.rat_descuento_deferencia / 100), 2)
        AS imp_venta_pvp,
    v.imp_costo_linea AS imp_venta_coste,

    canal.id_canal_venta,
    canal.nom_canal_venta,
    zona.id_zona,
    zona.des_zona,
    zona.id_tipo_zona,
    zona.des_tipo_zona,
    CASE
        WHEN COALESCE(canal.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT)
            THEN 'canal_venta_no_contabilizable'
        WHEN COALESCE(zona.no_contabiliza_zona, CAST(0 AS BIT)) = CAST(1 AS BIT)
            THEN 'zona_no_contabilizable'
        WHEN COALESCE(zona.no_contabiliza_tipo_zona, CAST(0 AS BIT)) = CAST(1 AS BIT)
            THEN 'tipo_zona_no_contabilizable'
        ELSE NULL
    END AS des_motivo_contabiliza_venta,
    CASE
        WHEN COALESCE(canal.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT)
            THEN CAST(0 AS INT)
        WHEN COALESCE(zona.no_contabiliza_zona, CAST(0 AS BIT)) = CAST(1 AS BIT)
            THEN CAST(0 AS INT)
        WHEN COALESCE(zona.no_contabiliza_tipo_zona, CAST(0 AS BIT)) = CAST(1 AS BIT)
            THEN CAST(0 AS INT)
        ELSE CAST(1 AS INT)
    END AS ind_contabiliza_venta,

    CASE
        WHEN COALESCE(v.ref_ind_salida_taller, 'N') = 'N'
            AND t.nom_agrupacion_canal IN ('EXTERIOR', 'AGENTES (RAS)')
            THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END AS ind_venta_exterior
FROM [wh_silver].[stg_qbi].[ventas_almacen] v
LEFT JOIN [wh_silver].[int_recambios].[tipos_venta] t
    ON t.tpo_venta = v.tpo_venta
OUTER APPLY (
    SELECT TOP 1
        m.no_contabiliza,
        m.id_canal_venta,
        m.canal_venta AS nom_canal_venta
    FROM [wh_silver].[stg_shp_mdm].[dic_rec_tipo_venta_canal_venta] d
    LEFT JOIN [wh_silver].[stg_shp_mdm].[rec_canales_venta] m
        ON m.id_canal_venta = d.id_canal_venta
    WHERE d.tipo_venta = v.tpo_venta
      AND (d.fec_ini IS NULL OR d.fec_ini <= CAST(v.fec_movimiento AS DATE))
      AND (d.fec_fin IS NULL OR d.fec_fin >= CAST(v.fec_movimiento AS DATE))
    ORDER BY
        COALESCE(d.fec_ini, CAST('1900-01-01' AS DATE)) DESC,
        COALESCE(d.fec_fin, CAST('9999-12-31' AS DATE)) DESC
) canal
OUTER APPLY (
    SELECT TOP 1
        z.id_zona,
        z.des_zona,
        z.id_tipo_zona,
        tz.des_tipo_zona,
        z.no_contabiliza AS no_contabiliza_zona,
        tz.no_contabiliza AS no_contabiliza_tipo_zona
    FROM [wh_silver].[stg_shp_mdm].[dic_rec_ruta_zona] d
    LEFT JOIN [wh_silver].[stg_shp_mdm].[rec_zonas] z
        ON z.id_zona = d.id_zona
    LEFT JOIN [wh_silver].[stg_shp_mdm].[rec_tipos_zonas] tz
        ON tz.id_tipo_zona = z.id_tipo_zona
    WHERE d.id_ruta = v.cat_ruta
      AND (d.fec_ini IS NULL OR d.fec_ini <= CAST(v.fec_movimiento AS DATE))
      AND (d.fec_fin IS NULL OR d.fec_fin >= CAST(v.fec_movimiento AS DATE))
    ORDER BY
        COALESCE(d.fec_ini, CAST('1900-01-01' AS DATE)) DESC,
        COALESCE(d.fec_fin, CAST('9999-12-31' AS DATE)) DESC
) zona