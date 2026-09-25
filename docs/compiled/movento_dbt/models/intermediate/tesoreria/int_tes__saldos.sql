

WITH saldo_inicial_diario AS (

    SELECT
        id_empresa,
        id_banco,
        id_flujo,
        fec_operacion AS fec_saldo,
        SUM(imp_movimiento_firmado) AS imp_saldo_inicial
    FROM [wh_silver].[stg_shp_tes].[saldo_inicial]
    GROUP BY
        id_empresa,
        id_banco,
        id_flujo,
        fec_operacion

),

movimiento_diario AS (

    SELECT
        id_empresa,
        id_banco,
        id_flujo,
        fec_operacion AS fec_saldo,
        SUM(imp_movimiento_firmado) AS imp_movimiento
    FROM [wh_silver].[int_tesoreria].[movimientos]
    GROUP BY
        id_empresa,
        id_banco,
        id_flujo,
        fec_operacion

),

combinaciones_empresa_banco_flujo AS (

    SELECT DISTINCT
        id_empresa,
        id_banco,
        id_flujo
    FROM saldo_inicial_diario

    UNION

    SELECT DISTINCT
        id_empresa,
        id_banco,
        id_flujo
    FROM movimiento_diario

),

rango_fechas_global AS (

    SELECT
        MIN(fec_operacion) AS min_fec_saldo,
        MAX(fec_operacion) AS max_fec_saldo
    FROM (
        SELECT
            fec_operacion
        FROM [wh_silver].[stg_shp_tes].[movimientos_pre_07_2026]

        UNION ALL

        SELECT
            fec_operacion
        FROM [wh_silver].[stg_shp_tes].[movimientos_post_07_2026]
    ) AS movimientos_stg

),

calendario_empresa_banco_flujo AS (

    SELECT
        c.id_empresa,
        c.id_banco,
        c.id_flujo,
        f.fecha AS fec_saldo,
        f.id_fecha
    FROM combinaciones_empresa_banco_flujo AS c
    CROSS JOIN rango_fechas_global AS d
    INNER JOIN [wh_gold].[general].[dim_fecha] AS f
        ON f.fecha BETWEEN d.min_fec_saldo AND d.max_fec_saldo

),

saldo_inicial_arrastre AS (

    SELECT
        s.id_empresa,
        s.id_banco,
        s.id_flujo,
        SUM(s.imp_saldo_inicial) AS imp_saldo_inicial_arrastre
    FROM saldo_inicial_diario AS s
    CROSS JOIN rango_fechas_global AS r
    WHERE s.fec_saldo < r.min_fec_saldo
    GROUP BY
        s.id_empresa,
        s.id_banco,
        s.id_flujo

),

importes_diarios AS (

    SELECT
        c.id_empresa,
        c.id_banco,
        c.id_flujo,
        c.fec_saldo,
        c.id_fecha,
        COALESCE(i.imp_saldo_inicial, 0)
            + CASE
                WHEN c.fec_saldo = r.min_fec_saldo THEN COALESCE(a.imp_saldo_inicial_arrastre, 0)
                ELSE 0
            END AS imp_saldo_inicial,
        COALESCE(m.imp_movimiento, 0) AS imp_movimiento,
        COALESCE(i.imp_saldo_inicial, 0)
            + CASE
                WHEN c.fec_saldo = r.min_fec_saldo THEN COALESCE(a.imp_saldo_inicial_arrastre, 0)
                ELSE 0
            END
            + COALESCE(m.imp_movimiento, 0) AS imp_neto_dia
    FROM calendario_empresa_banco_flujo AS c
    CROSS JOIN rango_fechas_global AS r
    LEFT JOIN saldo_inicial_diario AS i
        ON (
            c.id_empresa = i.id_empresa
            OR (c.id_empresa IS NULL AND i.id_empresa IS NULL)
        )
       AND c.id_banco = i.id_banco
       AND (
            c.id_flujo = i.id_flujo
            OR (c.id_flujo IS NULL AND i.id_flujo IS NULL)
       )
       AND c.fec_saldo = i.fec_saldo
    LEFT JOIN saldo_inicial_arrastre AS a
        ON (
            c.id_empresa = a.id_empresa
            OR (c.id_empresa IS NULL AND a.id_empresa IS NULL)
        )
       AND c.id_banco = a.id_banco
       AND (
            c.id_flujo = a.id_flujo
            OR (c.id_flujo IS NULL AND a.id_flujo IS NULL)
       )
    LEFT JOIN movimiento_diario AS m
        ON (
            c.id_empresa = m.id_empresa
            OR (c.id_empresa IS NULL AND m.id_empresa IS NULL)
        )
       AND c.id_banco = m.id_banco
       AND (
            c.id_flujo = m.id_flujo
            OR (c.id_flujo IS NULL AND m.id_flujo IS NULL)
       )
       AND c.fec_saldo = m.fec_saldo

),

saldos_diarios AS (

    SELECT
        d.id_empresa,
        d.id_banco,
        d.id_flujo,
        b.des_banco,
        b.des_grupo_banco,
        f.des_flujo,
        d.id_fecha,
        d.fec_saldo,
        d.imp_saldo_inicial,
        d.imp_movimiento,
        SUM(d.imp_neto_dia) OVER (
            PARTITION BY d.id_empresa, d.id_banco, d.id_flujo
            ORDER BY d.fec_saldo
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS imp_saldo
    FROM importes_diarios AS d
    LEFT JOIN [wh_silver].[stg_shp_mdm].[tes_bancos] AS b
        ON d.id_banco = b.id_banco
    LEFT JOIN [wh_silver].[stg_shp_mdm].[tes_flujos] AS f
        ON d.id_flujo = f.id_flujo

)

SELECT
    id_empresa,
    id_banco,
    id_flujo,
    des_banco,
    des_grupo_banco,
    des_flujo,
    id_fecha,
    fec_saldo,
    imp_saldo_inicial,
    imp_movimiento,
    imp_saldo
FROM saldos_diarios