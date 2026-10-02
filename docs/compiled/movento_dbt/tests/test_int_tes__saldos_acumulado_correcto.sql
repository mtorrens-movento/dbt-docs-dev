-- Test de calidad:
-- El saldo acumulado por empresa, banco y flujo debe ser igual al saldo del día anterior más el saldo inicial del día más los movimientos del día.
--
-- Fórmula esperada:
-- imp_saldo_actual =
--     imp_saldo_anterior
--   + imp_saldo_inicial
--   + imp_movimiento

WITH saldos_con_anterior AS (

    SELECT
        id_empresa,
        id_banco,
        id_flujo,
        fec_saldo,
        imp_saldo_inicial,
        imp_movimiento,
        imp_saldo,

        -- Recuperamos el saldo del día anterior para la misma
        -- combinación de empresa, banco y flujo.
        -- Utilizamos la misma partición que el modelo productivo
        -- para validar exactamente la lógica de cálculo.
        LAG(imp_saldo) OVER (
            PARTITION BY
                id_empresa,
                id_banco,
                id_flujo
            ORDER BY fec_saldo
        ) AS imp_saldo_anterior

    FROM [wh_silver].[int_tesoreria].[saldos]

),

validacion AS (

    SELECT
        id_empresa,
        id_banco,
        id_flujo,
        fec_saldo,
        imp_saldo_anterior,
        imp_saldo_inicial,
        imp_movimiento,
        imp_saldo,

        -- Cálculo del saldo esperado según la regla de negocio:
        -- saldo anterior + saldo inicial del día + movimientos del día
        imp_saldo_anterior
            + imp_saldo_inicial
            + imp_movimiento AS imp_saldo_esperado

    FROM saldos_con_anterior

    -- La primera fecha de cada empresa/banco/flujo
    -- no tiene saldo anterior, por lo que no puede validarse.
    WHERE imp_saldo_anterior IS NOT NULL

)

SELECT *

FROM validacion

-- Se devuelven únicamente los registros erróneos.
-- Si el test devuelve 0 filas, el test se considera correcto.
WHERE ABS(
    imp_saldo - imp_saldo_esperado
) > 0.01

-- Se utiliza una tolerancia de 0.01 para evitar
-- diferencias debidas a redondeos decimales.