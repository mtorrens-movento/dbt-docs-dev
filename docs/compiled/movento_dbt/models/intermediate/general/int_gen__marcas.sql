

-- Marcas al grano de marca contable (cod_auxiliar del maestro de QBI), que es la marca
-- que llevan las OR y las ventas de almacen. Varias marcas comerciales comparten marca
-- contable (por ejemplo, todas las de 99 OTRAS MARCAS), asi que se agrupa por codigo.
-- Las marcas comerciales sin marca contable quedan fuera.

SELECT
    TRY_CAST(cod_marca AS INT) AS cod_marca,
    MAX(des_cod_auxiliar) AS nom_marca,
    COUNT(*) AS num_marcas_comerciales
FROM [wh_silver].[stg_qbi].[marcas]
WHERE TRY_CAST(cod_marca AS INT) IS NOT NULL
GROUP BY
    TRY_CAST(cod_marca AS INT)