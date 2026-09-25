

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
    imp_saldo,
    CAST(
        '2026-09-25 14:49:51'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_tesoreria].[saldos]