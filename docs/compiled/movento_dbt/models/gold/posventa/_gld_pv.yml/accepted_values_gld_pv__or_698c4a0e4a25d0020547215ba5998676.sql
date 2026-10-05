
    
    

with all_values as (

    select
        cat_seccion_or as value_field,
        count(*) as n_records

    from [wh_gold].[posventa].[facts_or]
    group by cat_seccion_or

)

select *
from all_values
where value_field not in (
    'MECANICA','CARROCERIA','MIXTA'
)


