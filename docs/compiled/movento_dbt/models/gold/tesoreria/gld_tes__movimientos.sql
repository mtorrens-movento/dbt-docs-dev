

SELECT
    id_banco AS bank_code,
    id_empresa AS company_code,
    id_flujo AS flow_code,

    CAST(CONVERT(CHAR(8), fec_operacion, 112) AS INT) AS movement_date_key,
    CAST(CONVERT(CHAR(8), fec_valor, 112) AS INT) AS book_date_key,
    fec_operacion AS movement_date,
    fec_valor AS book_date,

    imp_movimiento_firmado AS signed_amount,
    imp_signo_div_cuenta AS importe_signo_div_cuenta,
    id_divisa AS currency_code,
    est_movimiento AS movement_status,

    des_movimiento AS movement_description,
    id_referencia AS referencia,
    id_centro_presupuestario AS budget_center_code,
        CAST(
        '2026-09-24 10:05:02'
        AS DATETIME2(0)
    ) AS _gold_load_ts
    FROM [wh_silver].[int_tesoreria].[int_tes__movimientos]