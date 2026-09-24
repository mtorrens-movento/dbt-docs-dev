

SELECT
    id_banco AS bank_code,
    des_banco AS bank_desc,
    id_empresa AS company_code,
    des_empresa AS company_desc,
    id_flujo AS flow_code,

    CAST(CONVERT(CHAR(8), fec_operacion, 112) AS INT) AS movement_date_key,
    CAST(CONVERT(CHAR(8), fec_valor, 112) AS INT) AS book_date_key,
    fec_operacion AS movement_date,
    fec_valor AS book_date,

    imp_movimiento_firmado AS signed_amount,
    imp_signo_div_cuenta AS importe_signo_div_cuenta,
    des_movimiento AS movement_description,
    id_referencia AS referencia,
    des_info_adicional_1,
    des_info_adicional_2,
    des_info_adicional_3,
    des_info_adicional_4,
        CAST(
        '2026-09-24 10:05:02'
        AS DATETIME2(0)
    ) AS _gold_load_ts

FROM [wh_silver].[stg_shp_tes].[saldo_inicial]