
    
    

with child as (
    select id_tipo_zona as from_field
    from [wh_silver].[stg_shp_mdm].[rec_zonas]
    where id_tipo_zona is not null
),

parent as (
    select id_tipo_zona as to_field
    from [wh_silver].[stg_shp_mdm].[rec_tipos_zonas]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


