

-- Marcas de centro: las concesiones del maestro de SharePoint. Es la marca con la que se
-- reparten los KPIs en el informe, la del centro (taller, almacen o concesionario) y no
-- la del vehiculo o el articulo. Los centros la llevan en id_reg_concesion, asi que la
-- dimension se relaciona con los hechos a traves de dim_talleres, dim_almacenes y
-- dim_concesionarios.

SELECT
    id_reg_concesion,
    nom_concesion,
    CAST(COALESCE(no_informado, 0) AS INT) AS ind_no_informado,
    CAST(COALESCE(no_contabiliza, 0) AS INT) AS ind_no_contabiliza
FROM [wh_silver].[stg_shp_mdm].[gen_concesion]
WHERE id_reg_concesion IS NOT NULL