
    
    

with all_values as (

    select
        id_sentido as value_field,
        count(*) as n_records

    from [wh_silver].[stg_shp_tes].[movimientos]
    group by id_sentido

)

select *
from all_values
where value_field not in (
    '+','-'
)


