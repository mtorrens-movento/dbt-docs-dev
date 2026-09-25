
    
    

with child as (
    select id_fecha_operacion as from_field
    from [wh_gold].[tesoreria].[facts_movimientos]
    where id_fecha_operacion is not null
),

parent as (
    select id_fecha as to_field
    from [wh_gold].[general].[dim_fecha]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


