

-- Marca contable por almacen y marca de la linea. La logica vive en int_gen__almacen_concesion_marca.

SELECT
    id_almacen,
    id_reg_concesion,
    nom_concesion,
    fec_ini,
    fec_fin,
    cod_marca_contable,
    id_marca_concesion_marca,
    nom_marca_concesion_marca,
    ind_marca_propia
FROM [wh_silver].[int_general].[almacen_concesion_marca]