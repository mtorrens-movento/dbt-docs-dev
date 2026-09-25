

WITH movimientos AS (

    SELECT
        CAST(SUBSTRING(id_cuenta, 4, 4) AS INT) AS id_banco,
        
    

    
        try_cast((
    case
        when SUBSTRING(id_cuenta, 2, 2) is null then null
        when upper(left(SUBSTRING(id_cuenta, 2, 2), 1)) = upper('Q')
            then nullif(substring(SUBSTRING(id_cuenta, 2, 2), 2, len(SUBSTRING(id_cuenta, 2, 2))), '')
        else SUBSTRING(id_cuenta, 2, 2)
    end
    ) as int)
    
 AS id_empresa,
        id_flujo,
        fec_operacion,
        fec_valor,
        imp_contravalor_firmado AS imp_movimiento_firmado,
        imp_contravalor AS imp_signo_div_cuenta,
        id_divisa,
        est_movimiento,
        des_movimiento,
        id_referencia,
        id_centro_presupuestario
    FROM [wh_silver].[stg_shp_tes].[movimientos]

)

SELECT
    id_banco,
    id_empresa,
    id_flujo,

    CAST(CONVERT(CHAR(8), fec_operacion, 112) AS INT) AS id_fecha_operacion,
    CAST(CONVERT(CHAR(8), fec_valor, 112) AS INT) AS id_fecha_valor,
    fec_operacion,
    fec_valor,

    imp_movimiento_firmado,
    imp_signo_div_cuenta AS importe_signo_div_cuenta,
    id_divisa,
    est_movimiento,

    des_movimiento,
    id_referencia,
    id_centro_presupuestario,
        CAST(
        '2026-09-25 14:49:51'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM movimientos