

-- Tabla de hechos de taller a nivel de OR y cargo, para las entradas de taller. Las
-- horas y los importes no van aqui sino en facts_or_mo, que tiene el grano de linea
-- con el que se calculan.
--
-- Entradas, con la misma regla que se usaba en Board: dentro de cada OR, subseccion
-- del tipo de OR y mes de cierre, solo cuenta el primer cargo, y vale +1 si sus horas
-- son positivas, -1 si son negativas (abonos) y 0 si no tiene horas. Una OR con
-- cargos de mecanica y de chapa son dos entradas.
--
-- imp_recambios es la cifra de negocio de recambios a taller: las lineas de la sabi
-- cuya referencia es la de la OR y el cargo, valoradas a PVP por la cantidad real.

WITH recambios AS (
    SELECT
        
    -- Obtener referencia a 7 digitos o limpiar migradas de otros sistemas (con guión)
    -- El identificador NO es numerico: 116.664 referencias del ultimo snapshot
    -- empiezan por letras (GG5257301...), de ordenes migradas. Castearlo a int las
    -- anula, y como la deduplicacion reparte por esta columna, colapsan entre si:
    -- se perdian 116.208 lineas de OR sin que saltara ningun error. El id_cargo si
    -- es numerico (cero no convertibles en 2.094.570) y ese cast se mantiene.
    CASE
        WHEN id_orden_venta IS NULL THEN NULL
        WHEN CHARINDEX('-', id_orden_venta) > 0
            THEN LEFT(id_orden_venta, CHARINDEX('-', id_orden_venta) - 1)
        WHEN LEN(id_orden_venta) > 0
            THEN LEFT(id_orden_venta, LEN(id_orden_venta) - 1)
        ELSE id_orden_venta
    END
 AS id_orden_reparacion,
        
    CASE
        WHEN id_orden_venta IS NULL THEN NULL
        WHEN CHARINDEX('-', id_orden_venta) > 0
            -- Obtener valores ala derecha del guion
            THEN try_cast(SUBSTRING(id_orden_venta, CHARINDEX('-', id_orden_venta) + 1, LEN(id_orden_venta)) as int)
        -- Obtener último carácter de referencia original
        ELSE try_cast(RIGHT(id_orden_venta, 1) as int)
    END
 AS id_cargo,
        SUM(ud_unidades_salida_real * imp_pvp_unitario) AS imp_recambios
    FROM [wh_silver].[stg_qbi].[ventas_almacen]
    GROUP BY
        
    -- Obtener referencia a 7 digitos o limpiar migradas de otros sistemas (con guión)
    -- El identificador NO es numerico: 116.664 referencias del ultimo snapshot
    -- empiezan por letras (GG5257301...), de ordenes migradas. Castearlo a int las
    -- anula, y como la deduplicacion reparte por esta columna, colapsan entre si:
    -- se perdian 116.208 lineas de OR sin que saltara ningun error. El id_cargo si
    -- es numerico (cero no convertibles en 2.094.570) y ese cast se mantiene.
    CASE
        WHEN id_orden_venta IS NULL THEN NULL
        WHEN CHARINDEX('-', id_orden_venta) > 0
            THEN LEFT(id_orden_venta, CHARINDEX('-', id_orden_venta) - 1)
        WHEN LEN(id_orden_venta) > 0
            THEN LEFT(id_orden_venta, LEN(id_orden_venta) - 1)
        ELSE id_orden_venta
    END
,
        
    CASE
        WHEN id_orden_venta IS NULL THEN NULL
        WHEN CHARINDEX('-', id_orden_venta) > 0
            -- Obtener valores ala derecha del guion
            THEN try_cast(SUBSTRING(id_orden_venta, CHARINDEX('-', id_orden_venta) + 1, LEN(id_orden_venta)) as int)
        -- Obtener último carácter de referencia original
        ELSE try_cast(RIGHT(id_orden_venta, 1) as int)
    END

),

cargos AS (
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
    c.id_orden_reparacion,
    c.id_cargo,

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

    COALESCE(r.imp_recambios, 0) AS imp_recambios,

    CAST(
        '2026-10-05 17:49:03'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM cargos c
LEFT JOIN recambios r
    ON r.id_orden_reparacion = c.id_orden_reparacion
    AND r.id_cargo = c.id_cargo