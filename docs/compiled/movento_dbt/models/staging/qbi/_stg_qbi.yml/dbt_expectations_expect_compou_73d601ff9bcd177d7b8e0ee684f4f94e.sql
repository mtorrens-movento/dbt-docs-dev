



with validation_errors as (

    select
        id_orden_reparacion,id_cargo,seq_linea_or,
        count(*) as [n_records]
    from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
    where
        1=1
        and 
    not (
        id_orden_reparacion is null and 
        id_cargo is null and 
        seq_linea_or is null
        
    )


    
    group by
        id_orden_reparacion,id_cargo,seq_linea_or
    having count(*) > 1

)
select * from validation_errors
