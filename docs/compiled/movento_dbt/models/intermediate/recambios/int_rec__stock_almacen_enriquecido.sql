

SELECT
    DATEADD(DAY, -1, sa.aud_dte_snapshot) AS fec_stock,
    sa.id_almacen,
    COALESCE(NULLIF(sa.nom_almacen, ''), sa.id_almacen) AS nom_almacen,
    sa.cat_antiguedad,
    CASE
        WHEN sa.cat_antiguedad = '1-< 6' THEN 'vivo'
        WHEN sa.cat_antiguedad = '2-6 a 12' THEN 'dormido'
        WHEN sa.cat_antiguedad IN ('3-12 a 18', '4-18 a 24') THEN 'muerto_1_ano'
        WHEN sa.cat_antiguedad IN ('5-24 a 36', '6-> 36') THEN 'muerto_2_anos'
        ELSE 'desconocido'
    END AS cat_estado_stock,
    sa.cat_articulo,
    sa.des_articulo,
    COALESCE(sa.ud_existencias, 0) AS ud_existencias,
    sa.imp_costo_medio_unitario,
    COALESCE(sa.ud_existencias, 0) * COALESCE(sa.imp_costo_medio_unitario, 0) AS imp_stock,
    sa.cod_marca_contable,
    sa.des_marca_contable,
    sa.aud_dte_snapshot,
    sa.aud_tst_ingestion,
    sa.aud_tst_ultima_actualizacion
FROM [wh_silver].[stg_qbi].[stock_almacen] AS sa
WHERE sa.id_almacen <> 'U86'