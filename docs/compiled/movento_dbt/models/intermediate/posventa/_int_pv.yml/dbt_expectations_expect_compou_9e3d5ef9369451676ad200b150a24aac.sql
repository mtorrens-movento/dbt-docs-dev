



with validation_errors as (

    select
        id_orden_reparacion,id_cargo,id_tipo_intervencion,
        count(*) as [n_records]
    from [wh_silver].[int_posventa].[cargos_tipo_intervencion]
    where
        1=1
        and 
    not (
        id_orden_reparacion is null and 
        id_cargo is null and 
        id_tipo_intervencion is null
        
    )


    
    group by
        id_orden_reparacion,id_cargo,id_tipo_intervencion
    having count(*) > 1

)
select * from validation_errors
