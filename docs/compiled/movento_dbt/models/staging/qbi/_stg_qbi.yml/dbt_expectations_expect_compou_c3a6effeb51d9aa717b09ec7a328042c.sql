



with validation_errors as (

    select
        id_orden_venta,seq_linea_venta,
        count(*) as [n_records]
    from [wh_silver].[stg_qbi].[ventas_almacen]
    where
        1=1
        and 
    not (
        id_orden_venta is null and 
        seq_linea_venta is null
        
    )


    
    group by
        id_orden_venta,seq_linea_venta
    having count(*) > 1

)
select * from validation_errors
