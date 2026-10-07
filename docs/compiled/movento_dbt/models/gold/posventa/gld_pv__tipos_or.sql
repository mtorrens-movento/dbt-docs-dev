

-- Dimension de tipos de OR para los hechos de taller (se relaciona por tpo_or). La logica
-- vive en int_pv__tipos_or.

SELECT
    tpo_or,
    id_subseccion,
    nom_subseccion,
    id_seccion,
    nom_seccion,
    id_canal,
    nom_canal,
    num_orden_canal
FROM [wh_silver].[int_posventa].[tipos_or]
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