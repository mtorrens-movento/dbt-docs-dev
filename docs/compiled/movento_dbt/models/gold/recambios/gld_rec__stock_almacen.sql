

WITH
agregado AS (
    SELECT
        CAST(CONVERT(CHAR(8), fec_stock, 112) AS INT) AS id_fecha_stock,
        fec_stock,
        id_almacen,
        nom_almacen,
        ROUND(SUM(CASE WHEN cat_estado_stock = 'vivo' THEN imp_stock ELSE 0 END), 2) AS imp_stock_vivo,
        ROUND(SUM(CASE WHEN cat_estado_stock = 'dormido' THEN imp_stock ELSE 0 END), 2) AS imp_stock_dormido,
        ROUND(SUM(CASE WHEN cat_estado_stock = 'muerto_1_ano' THEN imp_stock ELSE 0 END), 2) AS imp_stock_muerto_1_ano,
        ROUND(SUM(CASE WHEN cat_estado_stock = 'muerto_2_anos' THEN imp_stock ELSE 0 END), 2) AS imp_stock_muerto_2_anos,
        ROUND(SUM(imp_stock), 2) AS imp_stock_total
    FROM [wh_silver].[int_recambios].[stock_almacen_enriquecido]
    GROUP BY
        fec_stock,
        id_almacen,
        nom_almacen
)

SELECT
    id_fecha_stock,
    fec_stock,
    id_almacen,
    nom_almacen,
    imp_stock_vivo,
    imp_stock_dormido,
    imp_stock_muerto_1_ano,
    imp_stock_muerto_2_anos,
    ROUND(imp_stock_muerto_1_ano + imp_stock_muerto_2_anos, 2) AS imp_stock_muerto,
    imp_stock_total,
    CAST(
        '2026-10-07 15:46:54'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM agregado