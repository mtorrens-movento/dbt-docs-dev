

-- Tabla de hechos de taller a nivel de OR (7 digitos), para el ciclo de reparacion. La
-- logica vive en int_pv__ordenes_reparacion.

SELECT
    id_orden_reparacion,

    CAST(CONVERT(CHAR(8), fec_apertura_or, 112) AS INT) AS id_fecha_apertura,
    CAST(CONVERT(CHAR(8), fec_entrega_vehiculo, 112) AS INT) AS id_fecha_entrega,
    CAST(CONVERT(CHAR(8), fec_cierre_or, 112) AS INT) AS id_fecha_cierre,

    id_taller,
    id_vehiculo,
    cod_marca,
    num_cargos,
    cat_seccion_or,

    tst_apertura,
    tst_primer_fichaje,
    tst_ultimo_fichaje,
    tst_entrega,
    tst_cierre,

    ud_dias_preparacion,
    ud_dias_reparacion,
    ud_dias_entrega,
    ud_dias_facturacion,

    CAST(
        '2026-10-07 12:54:30'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_posventa].[ordenes_reparacion]