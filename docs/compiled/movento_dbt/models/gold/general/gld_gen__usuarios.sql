

SELECT
    id_fila_tecnica,
    id_persona,
    nom_persona,
    eml_persona,
    alias,
    fec_alta,
    fec_baja,
    id_empresa,
    id_asesor,
    id_operario,
    id_vendedor_comercial,
    id_vendedor_almacen,
    id_cajero,
    id_usuario,
    cat_departamento,
    des_departamento,
    tel_telefono,
    cat_grupo,
    des_grupo,
    aud_dte_snapshot,
    aud_tst_ingestion,
    aud_tst_ultima_actualizacion
FROM [wh_silver].[stg_qbi].[personasbi]