

SELECT
    id_fila_tecnica,
    id_empresa,
    nom_empresa,
    id_cuenta_personal,
    id_dni,
    cat_estado,
    des_estado,
    cat_actividad,
    des_actividad
FROM [wh_silver].[stg_qbi].[empresas]