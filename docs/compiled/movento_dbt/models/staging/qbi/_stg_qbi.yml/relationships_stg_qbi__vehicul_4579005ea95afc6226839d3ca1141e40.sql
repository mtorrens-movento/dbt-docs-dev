
    
    

with child as (
    select cod_marca_contable as from_field
    from [wh_silver].[stg_qbi].[vehiculos]
    where cod_marca_contable is not null
),

parent as (
    select cod_marca as to_field
    from [wh_silver].[stg_qbi].[marcas]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


