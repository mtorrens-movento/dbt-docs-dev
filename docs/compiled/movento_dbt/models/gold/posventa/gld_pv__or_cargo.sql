

-- Tabla de hechos de taller a nivel de OR y cargo, para las entradas de taller. Las
-- horas y los importes no van aqui sino en facts_or_mo, que tiene el grano de linea
-- con el que se calculan.

SELECT
    id_orden_reparacion,
    id_cargo,

    CAST(CONVERT(CHAR(8), fec_apertura_or, 112) AS INT) AS id_fecha_apertura,
    CAST(CONVERT(CHAR(8), fec_cierre_or, 112) AS INT) AS id_fecha_cierre,
    fec_apertura_or,
    fec_cierre_or,

    id_taller,
    id_vehiculo,
    cod_marca,
    id_cuenta_cargo,
    tpo_or,
    tpo_facturacion,
    num_factura,
    ud_km_or,

    CAST(
        '2026-09-30 17:49:59'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_posventa].[pasos_cargo_collapsed]