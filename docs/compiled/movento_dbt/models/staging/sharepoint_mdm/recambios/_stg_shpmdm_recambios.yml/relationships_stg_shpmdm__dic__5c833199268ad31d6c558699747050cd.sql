
    
    

with child as (
    select id_zona as from_field
    from [wh_silver].[stg_shp_mdm].[dic_rec_ruta_zona]
    where id_zona is not null
),

parent as (
    select id_zona as to_field
    from [wh_silver].[stg_shp_mdm].[rec_zonas]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


