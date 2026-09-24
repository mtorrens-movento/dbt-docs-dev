




    with grouped_expression as (
    select
        
        case when 

    len( num_bastidor ) = 17 then cast(1 as int) else cast(0 as int) end as expression
    from [wh_silver].[stg_qbi].[vehiculos]
    

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




