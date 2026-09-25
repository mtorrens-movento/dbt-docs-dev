

WITH movimientos_pre AS (

    SELECT
        id_banco,
        id_empresa,
        id_flujo,
        fec_operacion,
        fec_valor,
        imp_movimiento_firmado,
        imp_signo_div_cuenta,
        'EUR' AS id_divisa,
        'Real' AS est_movimiento,
        des_movimiento,
        id_referencia,
        des_info_adicional_1,
        des_info_adicional_2,
        des_info_adicional_3,
        des_info_adicional_4,
        NULL AS id_centro_presupuestario,
        'movimientos_pre_07_2026' AS origen_movimiento
    FROM [wh_silver].[stg_shp_tes].[movimientos_pre_07_2026]

),

movimientos_post AS (

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
        des_info_adicional_1,
        des_info_adicional_2,
        NULL AS des_info_adicional_3,
        NULL AS des_info_adicional_4,
        id_centro_presupuestario,
        'movimientos_post_07_2026' AS origen_movimiento
    FROM [wh_silver].[stg_shp_tes].[movimientos_post_07_2026]

)

SELECT *
FROM movimientos_pre

UNION ALL

SELECT *
FROM movimientos_post