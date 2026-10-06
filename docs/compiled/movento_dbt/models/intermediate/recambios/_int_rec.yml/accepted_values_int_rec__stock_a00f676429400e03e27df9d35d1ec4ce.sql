
    
    

with all_values as (

    select
        cat_estado_stock as value_field,
        count(*) as n_records

    from [wh_silver].[int_recambios].[stock_almacen_enriquecido]
    group by cat_estado_stock

)

select *
from all_values
where value_field not in (
    'vivo','dormido','muerto_1_ano','muerto_2_anos','desconocido'
)


