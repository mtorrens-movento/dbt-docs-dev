




select
    id_vehiculo,
    id_tipo_intervencion,
    des_intervencion,
    num_bastidor,
    id_orden_reparacion_ultima_intervencion,
    id_cargo_ultima_intervencion,
    fec_ultima_intervencion,
    ud_km_ultima_intervencion,
    id_taller_ultima_intervencion,
    meses_regla,
    kms_regla,
    ud_km_medio_diario,
    fec_prox_por_meses,
    fec_prox_por_km,
    fec_prox_intervencion,
    aud_dte_snapshot,
    aud_tst_ingestion
from [wh_silver].[int_vehiculos].[proximas_intervenciones]
