
    
    

with child as (
    select id_combustible as from_field
    from [wh_silver].[stg_qbi].[vehiculos]
    where id_combustible is not null
),

parent as (
    select id_combustible as to_field
    from [wh_silver].[stg_shp_mdm].[veh_combustibles]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


