

-- Tabla de hechos de taller a nivel de OR y cargo, para las entradas de taller. Las
-- horas y los importes no van aqui sino en facts_or_mo, que tiene el grano de linea
-- con el que se calculan.
--
-- Entradas, con la misma regla que se usaba en Board: dentro de cada OR, subseccion
-- del tipo de OR y mes de cierre, solo cuenta el primer cargo, y vale +1 si sus horas
-- son positivas, -1 si son negativas (abonos) y 0 si no tiene horas. Una OR con
-- cargos de mecanica y de chapa son dos entradas.

WITH cargos AS (
    SELECT
        c.*,
        t.id_subseccion,
        ROW_NUMBER() OVER (
            PARTITION BY
                c.id_orden_reparacion,
                COALESCE(t.id_subseccion, -1),
                YEAR(c.fec_cierre_or),
                MONTH(c.fec_cierre_or)
            ORDER BY c.id_cargo
        ) AS rn_categoria
    FROM [wh_silver].[int_posventa].[pasos_cargo_collapsed] c
    LEFT JOIN [wh_gold].[posventa].[dim_tipos_or] t
        ON t.tpo_or = c.tpo_or
)

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

    CASE
        WHEN rn_categoria = 1 AND sum_tiempo_or > 0 THEN 1
        WHEN rn_categoria = 1 AND sum_tiempo_or < 0 THEN -1
        ELSE 0
    END AS ud_entradas,

    CAST(
        '2026-10-02 14:54:33'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM cargos