

-- Centro de la jerarquia de negocio para los hechos de ventas de almacen. La empresa,
-- la explotacion y la zona salen de dim_empresas a traves de id_empresa. Los almacenes
-- de utillaje (U60, U61...) no tienen empresa en origen.

SELECT
    id_almacen,
    nom_almacen,
    nom_localidad,
    des_direccion,
    id_almacen_consumos,
    id_empresa
FROM [wh_silver].[stg_qbi].[almacenes]