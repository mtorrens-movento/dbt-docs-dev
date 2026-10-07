

-- Dimension de marcas al grano de marca contable, la que llevan las OR y las ventas de
-- almacen. La logica vive en int_gen__marcas.

SELECT
    cod_marca,
    nom_marca,
    num_marcas_comerciales
FROM [wh_silver].[int_general].[marcas]