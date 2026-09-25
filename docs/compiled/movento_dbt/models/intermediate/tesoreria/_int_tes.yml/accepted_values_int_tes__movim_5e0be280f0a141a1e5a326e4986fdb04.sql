
    
    

with all_values as (

    select
        origen_movimiento as value_field,
        count(*) as n_records

    from [wh_silver].[int_tesoreria].[movimientos]
    group by origen_movimiento

)

select *
from all_values
where value_field not in (
    'movimientos_pre_07_2026','movimientos_post_07_2026'
)


