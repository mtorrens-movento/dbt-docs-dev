

-- Dimension de marcas de centro (concesiones). Se relaciona por id_reg_concesion con
-- dim_talleres, dim_almacenes y dim_concesionarios. La logica vive en int_gen__marcas_centro.

SELECT
    id_reg_concesion,
    nom_concesion,
    ind_no_informado,
    ind_no_contabiliza
FROM [wh_silver].[int_general].[marcas_centro]