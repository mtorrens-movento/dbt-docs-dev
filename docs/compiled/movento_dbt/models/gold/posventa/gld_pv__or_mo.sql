

-- Tabla de hechos de taller a nivel de linea de mano de obra, el grano de origen de
-- la sobi. Lee del staging directamente porque no hay grano que colapsar. Solo lleva
-- las medidas que son de la linea: los importes del cargo (imp_total_mo,
-- imp_total_rec) se repiten en cada linea y aqui se inflarian al sumar.

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

    ud_tiempo_or AS ud_horas_facturadas,
    imp_total_linea AS imp_mano_obra,

    CAST(
        '2026-10-01 15:55:16'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[stg_qbi].[pasos_taller_cerrados]
WHERE id_orden_reparacion IS NOT NULL
  AND id_cargo IS NOT NULL