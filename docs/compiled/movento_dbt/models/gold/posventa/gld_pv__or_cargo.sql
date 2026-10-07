

-- Tabla de hechos de taller a nivel de OR y cargo, para las entradas de taller y los
-- recambios a taller. La logica vive en int_pv__or_cargo.

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

    ud_entradas,
    imp_recambios,

    CAST(
        '2026-10-07 12:54:30'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_posventa].[or_cargo]