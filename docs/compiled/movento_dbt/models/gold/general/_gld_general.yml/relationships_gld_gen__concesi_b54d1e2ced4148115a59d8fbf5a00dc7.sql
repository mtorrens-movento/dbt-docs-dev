
    
    

with child as (
    select cod_marca as from_field
    from [wh_gold].[general].[dim_concesionarios]
    where cod_marca is not null
),

parent as (
    select cod_marca as to_field
    from [wh_gold].[general].[dim_marcas]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


