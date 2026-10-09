

-- Marca contable por concesionario y marca de la linea. La logica vive en int_gen__concesionario_concesion_marca.

SELECT
    id_concesionario,
    id_reg_concesion,
    nom_concesion,
    fec_ini,
    fec_fin,
    cod_marca_contable,
    id_marca_concesion_marca,
    nom_marca_concesion_marca,
    ind_marca_propia
FROM [wh_silver].[int_general].[concesionario_concesion_marca]