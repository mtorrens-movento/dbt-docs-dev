

SELECT
    id_banco,
    des_banco,
    id_empresa,
    des_empresa,
    id_flujo,

    CAST(CONVERT(CHAR(8), fec_operacion, 112) AS INT) AS id_fecha_operacion,
    CAST(CONVERT(CHAR(8), fec_valor, 112) AS INT) AS id_fecha_valor,
    fec_operacion,
    fec_valor,

    imp_movimiento_firmado,
    imp_signo_div_cuenta AS importe_signo_div_cuenta,
    des_movimiento,
    id_referencia,
    des_info_adicional_1,
    des_info_adicional_2,
    des_info_adicional_3,
    des_info_adicional_4,
        CAST(
        '2026-09-25 13:30:52'
        AS DATETIME2(0)
    ) AS _gold_load_ts

FROM [wh_silver].[stg_shp_tes].[saldo_inicial]