

with source_rows as (

    select
        id_vehiculo,
        num_bastidor,
        id_tipo_intervencion,
        id_orden_reparacion_ultima_intervencion,
        fec_ultima_intervencion,
        fec_prox_intervencion,
        aud_tst_ultima_actualizacion
    from [wh_silver].[int_vehiculos].[proximas_intervenciones]

),

changed_vehiculos as (

    select distinct
        sr.id_vehiculo
    from source_rows as sr
    
    where sr.aud_tst_ultima_actualizacion > (
        select max(t.aud_tst_ultima_actualizacion)
        from [wh_gold].[salesforce].[veh_prox_inter] as t
    )
    

),

base as (

    select
        sr.id_vehiculo,
        sr.num_bastidor,
        sr.id_tipo_intervencion,
        sr.id_orden_reparacion_ultima_intervencion,
        sr.fec_ultima_intervencion,
        sr.fec_prox_intervencion,
        sr.aud_tst_ultima_actualizacion
    from source_rows as sr
    
    inner join changed_vehiculos as cv
        on cv.id_vehiculo = sr.id_vehiculo
    

),

final as (

    select
        b.id_vehiculo,
        b.num_bastidor,
        max(case when b.id_tipo_intervencion = 1 then b.fec_ultima_intervencion end) as fec_ultima_intervencion_mant,
        max(case when b.id_tipo_intervencion = 1 then b.id_orden_reparacion_ultima_intervencion end) as id_or_ultima_intervencion_mant,
        max(case when b.id_tipo_intervencion = 1 then b.fec_prox_intervencion end) as fec_prox_intervencion_mant,
        max(case when b.id_tipo_intervencion = 2 then b.fec_ultima_intervencion end) as fec_ultima_intervencion_cambio_pastillas,
        max(case when b.id_tipo_intervencion = 2 then b.id_orden_reparacion_ultima_intervencion end) as id_or_ultima_intervencion_cambio_pastillas,
        max(case when b.id_tipo_intervencion = 2 then b.fec_prox_intervencion end) as fec_prox_intervencion_cambio_pastillas,
        max(case when b.id_tipo_intervencion = 3 then b.fec_ultima_intervencion end) as fec_ultima_intervencion_discos_freno,
        max(case when b.id_tipo_intervencion = 3 then b.id_orden_reparacion_ultima_intervencion end) as id_or_ultima_intervencion_discos_freno,
        max(case when b.id_tipo_intervencion = 3 then b.fec_prox_intervencion end) as fec_prox_intervencion_discos_freno,
        max(case when b.id_tipo_intervencion = 4 then b.fec_ultima_intervencion end) as fec_ultima_intervencion_cambio_neu,
        max(case when b.id_tipo_intervencion = 4 then b.id_orden_reparacion_ultima_intervencion end) as id_or_ultima_intervencion_cambio_neu,
        max(case when b.id_tipo_intervencion = 4 then b.fec_prox_intervencion end) as fec_prox_intervencion_cambio_neu,
        max(b.aud_tst_ultima_actualizacion) as aud_tst_ultima_actualizacion
    from base as b
    group by
        b.id_vehiculo,
        b.num_bastidor

)

select * from final as f