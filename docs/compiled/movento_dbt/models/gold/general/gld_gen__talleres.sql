

-- Centro de la jerarquia de negocio para los hechos de taller. La empresa, la
-- explotacion y la zona no se copian aqui: salen de dim_empresas a traves de
-- id_empresa, y el almacen de dim_almacenes a traves de id_almacen.

SELECT
    id_taller,
    nom_taller,
    nom_comercial,
    id_marca_iv,
    nom_localidad,
    des_direccion,
    num_latitud_gps,
    num_longitud_gps,
    des_talleres_mismo_recepcion,
    id_empresa,
    id_almacen
FROM [wh_silver].[stg_qbi].[talleres]