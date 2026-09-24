



with validation_errors as (

    select
        id_orden_reparacion,id_cargo,
        count(*) as [n_records]
    from [wh_silver].[int_posventa].[pasos_cargo_collapsed]
    where
        1=1
        and 
    not (
        id_orden_reparacion is null and 
        id_cargo is null
        
    )


    
    group by
        id_orden_reparacion,id_cargo
    having count(*) > 1

)
select * from validation_errors
