

-- Tabla de hechos de taller para los KPIs de postventa. Una fila por OR y cargo:
-- una OR con varios cargos tiene varias filas, asi que las entradas se cuentan
-- con count(distinct id_orden_reparacion) y no con count(*).

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

    sum_total_mo AS imp_mano_obra,
    sum_total_recambios AS imp_materiales,
    sum_tiempo_or AS ud_horas_facturadas,

    CAST(
        '2026-09-29 17:52:45'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_posventa].[pasos_cargo_collapsed]