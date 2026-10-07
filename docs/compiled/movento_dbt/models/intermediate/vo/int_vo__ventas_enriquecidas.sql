

WITH ventas_vo AS (
    SELECT
        *
    FROM [wh_silver].[stg_qbi].[ventas_vo]
    WHERE fec_venta IS NOT NULL
)

SELECT
    vo.id_fila_tecnica,
    vo.id_referencia,
    vo.fec_venta,
    vo.id_concesionario,
    vo.nom_concesionario,
    vo.id_concesionario_venta,
    vo.nom_concesionario_venta,
    vo.id_vendedor AS id_vendedor_quiter,
    vo.nom_vendedor AS nom_vendedor_quiter,
    ven.id_vendedor,
    ven.nom_vendedor,
    ven.id_tipo_vendedor,
    ven.des_tipo_vendedor,
    vo.id_vehiculo,
    vo.tpo_venta,
    vo.des_tipo_venta,
    vo.id_cuenta_cliente,
    can.id_canal_venta,
    can.des_canal_venta,
    CASE
        WHEN COALESCE(ven.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN 'vendedor_no_contabilizable'
        WHEN COALESCE(subcan.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN 'subcanal_no_contabilizable'
        WHEN COALESCE(can.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN 'canal_no_contabilizable'
        ELSE NULL
    END AS des_motivo_contabiliza_venta,
    CASE
        WHEN COALESCE(ven.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN CAST(0 AS INT)
        WHEN COALESCE(subcan.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN CAST(0 AS INT)
        WHEN COALESCE(can.no_contabiliza, CAST(0 AS BIT)) = CAST(1 AS BIT) THEN CAST(0 AS INT)
        ELSE CAST(1 AS INT)
    END AS ind_contabiliza_venta,
    vo.imp_venta_vo,
    vo.imp_beneficio,
    vo.aud_dte_snapshot,
    vo.aud_tst_ingestion,
    vo.aud_tst_ultima_actualizacion
FROM ventas_vo AS vo
OUTER APPLY (
    SELECT TOP 1
        d.id_ven_org
    FROM [wh_silver].[stg_shp_mdm].[dic_com_vendedores_quiter_org] AS d
    WHERE d.id_ven_quiter = vo.id_vendedor
      AND (d.fec_ini IS NULL OR d.fec_ini <= CAST(vo.fec_venta AS DATE))
      AND (d.fec_fin IS NULL OR d.fec_fin >= CAST(vo.fec_venta AS DATE))
    ORDER BY
        COALESCE(d.fec_ini, CAST('1900-01-01' AS DATE)) DESC,
        COALESCE(d.fec_fin, CAST('9999-12-31' AS DATE)) DESC
) AS ven_dic
OUTER APPLY (
    SELECT TOP 1
        v.id_vendedor,
        v.nom_vendedor,
        v.id_tipo_vendedor,
        v.des_tipo_vendedor,
        v.no_contabiliza
    FROM [wh_silver].[stg_shp_mdm].[com_vendedores] AS v
    WHERE v.id_vendedor = ven_dic.id_ven_org
      AND (v.fec_ini IS NULL OR v.fec_ini <= CAST(vo.fec_venta AS DATE))
      AND (v.fec_fin IS NULL OR v.fec_fin >= CAST(vo.fec_venta AS DATE))
    ORDER BY
        COALESCE(v.fec_ini, CAST('1900-01-01' AS DATE)) DESC,
        COALESCE(v.fec_fin, CAST('9999-12-31' AS DATE)) DESC
) AS ven
OUTER APPLY (
    SELECT TOP 1
        d.id_subcanal_venta
    FROM [wh_silver].[stg_shp_mdm].[dic_com_tipo_venta_subcanal_venta] AS d
    WHERE d.id_tipo_venta = vo.tpo_venta
      AND (d.fec_ini IS NULL OR d.fec_ini <= CAST(vo.fec_venta AS DATE))
      AND (d.fec_fin IS NULL OR d.fec_fin >= CAST(vo.fec_venta AS DATE))
    ORDER BY
        COALESCE(d.fec_ini, CAST('1900-01-01' AS DATE)) DESC,
        COALESCE(d.fec_fin, CAST('9999-12-31' AS DATE)) DESC
) AS dic
LEFT JOIN [wh_silver].[stg_shp_mdm].[com_subcanales_venta] AS subcan
    ON subcan.id_subcanal_venta = dic.id_subcanal_venta
LEFT JOIN [wh_silver].[stg_shp_mdm].[com_canales_venta] AS can
    ON can.id_canal_venta = subcan.id_canal_venta