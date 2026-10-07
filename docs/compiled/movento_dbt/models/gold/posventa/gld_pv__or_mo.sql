

-- Tabla de hechos de taller a nivel de linea de mano de obra. La logica vive en
-- int_pv__lineas_mo.

SELECT
    id_orden_reparacion,
    id_cargo,
    seq_linea_or,

    CAST(CONVERT(CHAR(8), fec_cierre_or, 112) AS INT) AS id_fecha_cierre,
    fec_cierre_or,

    id_taller,
    id_vehiculo,
    cod_marca,
    tpo_or,
    tpo_mano_obra,

    ud_horas_facturadas,
    imp_mano_obra,
    imp_cn_mano_obra,

    CAST(
        '2026-10-07 10:39:30'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_posventa].[lineas_mo]