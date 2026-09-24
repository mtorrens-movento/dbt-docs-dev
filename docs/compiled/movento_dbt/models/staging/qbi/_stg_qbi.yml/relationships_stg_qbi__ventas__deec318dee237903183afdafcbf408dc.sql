
    
    

with child as (
    select id_almacen as from_field
    from [wh_silver].[stg_qbi].[ventas_almacen]
    where id_almacen is not null
),

parent as (
    select id_almacen as to_field
    from [wh_silver].[stg_qbi].[almacenes]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


