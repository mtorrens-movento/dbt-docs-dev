

SELECT
    id_fila_tecnica,
    id_usuario,
    cat_atributo,
    des_atributo,
    des_valor_atributo,
    cat_tipo_objeto,
    cat_fichero_objeto,
    aud_dte_snapshot,
    aud_tst_ingestion,
    aud_tst_ultima_actualizacion
FROM [wh_silver].[stg_qbi].[atributos_usuarios]