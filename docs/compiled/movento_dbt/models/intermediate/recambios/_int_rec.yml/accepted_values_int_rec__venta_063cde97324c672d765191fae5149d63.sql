
    
    

with all_values as (

    select
        ref_ind_salida_taller as value_field,
        count(*) as n_records

    from [wh_silver].[int_recambios].[ventas_internas]
    group by ref_ind_salida_taller

)

select *
from all_values
where value_field not in (
    'S'
)


