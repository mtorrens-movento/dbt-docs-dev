



with validation_errors as (

    select
        id_vehiculo,id_tipo_intervencion,
        count(*) as [n_records]
    from [wh_silver].[int_vehiculos].[proximas_intervenciones]
    where
        1=1
        and 
    not (
        id_vehiculo is null and 
        id_tipo_intervencion is null
        
    )


    
    group by
        id_vehiculo,id_tipo_intervencion
    having count(*) > 1

)
select * from validation_errors
