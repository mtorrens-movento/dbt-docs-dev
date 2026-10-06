

SELECT
    sv.id_fila_tecnica,
    sv.fec_corte_stock AS fec_stock,
    sv.id_vehiculo,
    sv.id_concesionario,
    sv.nom_concesionario,
    veh.des_marca AS desc_abr_marca,
    veh.num_matricula AS num_matricula,
    veh.num_bastidor AS num_bastidor,
    veh.cat_familia AS id_familia_quiter,
    dic.id_familia,
    fam.cod_familia,
    veh.cat_modelo AS cod_modelo,
    CASE
        WHEN sv.fec_factura IS NULL OR sv.fec_corte_stock IS NULL THEN NULL
        ELSE ABS(DATEDIFF(DAY, sv.fec_factura, sv.fec_corte_stock))
    END AS ud_dias_stock,
    sv.fec_factura,
    sv.fec_recepcion,
    CASE
        WHEN sv.imp_costo IS NULL OR sv.imp_costo = 0 THEN sv.imp_compra
        ELSE sv.imp_costo
    END AS imp_precio_venta_distribuidor,
    sv.imp_iva_compra AS imp_iva,
    sv.imp_precio_compra_total AS imp_total,
    CAST(1 AS INT) AS ud_unidades,
    sv.id_vendedor_reserva,
    sv.id_cliente_reserva,
    sv.nom_cliente_reserva,
    sv.cat_estado,
    sv.fec_reserva,
    veh.cod_marca_contable,
    CASE
        WHEN COALESCE(sv.cat_estado, '') IN ('DEM', 'SUS') THEN 'estado_no_contabilizable'
        WHEN COALESCE(fam.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN 'familia_no_contabilizable'
        ELSE NULL
    END AS des_motivo_contabiliza_stock,
    CASE
        WHEN COALESCE(sv.cat_estado, '') IN ('DEM', 'SUS') THEN CAST(0 AS INT)
        WHEN COALESCE(fam.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN CAST(0 AS INT)
        ELSE CAST(1 AS INT)
    END AS ind_contabiliza_stock,
    sv.aud_dte_snapshot,
    sv.aud_tst_ingestion,
    sv.aud_tst_ultima_actualizacion
FROM [wh_silver].[stg_qbi].[stock_vn] AS sv
LEFT JOIN [wh_silver].[stg_qbi].[vehiculos] AS veh
    ON veh.id_vehiculo = sv.id_vehiculo
OUTER APPLY (
    SELECT TOP 1
        d.id_familia
    FROM [wh_silver].[stg_shp_mdm].[dic_com_familias] AS d
    WHERE d.id_familia_quiter = veh.cat_familia
      AND (d.fec_ini IS NULL OR d.fec_ini <= CAST(sv.fec_corte_stock AS DATE))
      AND (d.fec_fin IS NULL OR d.fec_fin >= CAST(sv.fec_corte_stock AS DATE))
    ORDER BY
        COALESCE(d.fec_ini, CAST('1900-01-01' AS DATE)) DESC,
        COALESCE(d.fec_fin, CAST('9999-12-31' AS DATE)) DESC
) AS dic
LEFT JOIN [wh_silver].[stg_shp_mdm].[com_familias] AS fam
    ON fam.id_familia = dic.id_familia