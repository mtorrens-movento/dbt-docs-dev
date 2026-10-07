

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