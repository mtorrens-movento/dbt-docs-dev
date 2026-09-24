






    with grouped_expression as (
    select
        
        case when 
( 1=1 and ud_unidades_venta >= 0 and ud_unidades_venta <= 1000
)
 then cast(1 as int) else cast(0 as int) end as expression
    from [wh_silver].[stg_qbi].[ventas_almacen]
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        
        
        expression <> 1
        

)

select *
from validation_errors







