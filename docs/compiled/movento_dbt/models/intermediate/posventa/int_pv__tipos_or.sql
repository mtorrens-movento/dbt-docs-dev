

-- Tipos de OR con su subseccion, seccion y canal de taller (se relaciona por tpo_or). Junta
-- en una sola fila por tipo de OR la subseccion y la seccion (tipo de OR -> subseccion
-- -> seccion) y el canal de taller, para que el hecho llegue a todo sin encadenar
-- tablas. De cada diccionario se toma la version vigente.

WITH subseccion AS (
    SELECT
        tipo_or,
        id_subseccion_taller,
        ROW_NUMBER() OVER (PARTITION BY tipo_or ORDER BY fec_ini DESC) AS rn
    FROM [wh_silver].[stg_shp_mdm].[dic_tall_tipo_or_subseccion]
    WHERE fec_fin IS NULL OR fec_fin >= CAST(GETDATE() AS DATE)
),

canal AS (
    SELECT
        tipo_or,
        id_canal_venta,
        ROW_NUMBER() OVER (PARTITION BY tipo_or ORDER BY fec_ini DESC) AS rn
    FROM [wh_silver].[stg_shp_mdm].[dic_tall_tipo_or_canal_venta]
    WHERE fec_fin IS NULL OR fec_fin >= CAST(GETDATE() AS DATE)
),

tipos AS (
    SELECT tipo_or FROM subseccion WHERE rn = 1
    UNION
    SELECT tipo_or FROM canal WHERE rn = 1
)

SELECT
    t.tipo_or AS tpo_or,
    s.id_subseccion_taller AS id_subseccion,
    sec.des_subseccion AS nom_subseccion,
    sec.id_seccion,
    sec.des_seccion AS nom_seccion,
    c.id_canal_venta AS id_canal,
    m.des_canal_venta AS nom_canal,
    m.orden_canal AS num_orden_canal
FROM tipos t
LEFT JOIN subseccion s
    ON s.tipo_or = t.tipo_or
   AND s.rn = 1
LEFT JOIN [wh_silver].[stg_shp_mdm].[tall_secciones] sec
    ON sec.id_subseccion = s.id_subseccion_taller
LEFT JOIN canal c
    ON c.tipo_or = t.tipo_or
   AND c.rn = 1
LEFT JOIN [wh_silver].[stg_shp_mdm].[tall_canales_venta] m
    ON m.id_canal_venta = c.id_canal_venta