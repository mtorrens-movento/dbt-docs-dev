




select
    id_vehiculo,
    num_matricula,
    num_bastidor,
    id_marca,
    des_marca,
    cat_modelo,
    des_modelo,
    cat_familia,
    des_familia,
    ud_km,
    fec_matriculacion,
    tpo_motor,
    des_tipo_motor,
    id_combustible,
    des_tipo_combustible,
    aud_dte_snapshot,
    aud_tst_ingestion
from [wh_silver].[stg_qbi].[vehiculos]
