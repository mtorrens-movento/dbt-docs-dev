






    with grouped_expression as (
    select
        
        case when 
( 1=1 and fec_apertura_or >= cast('1950-01-01' as date) and fec_apertura_or <= cast('2026-09-24' as date)
)
 then cast(1 as int) else cast(0 as int) end as expression
    from [wh_silver].[stg_qbi].[ventas_almacen]
    where
        fec_apertura_or is not null
    
    

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







