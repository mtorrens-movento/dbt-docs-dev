
    
    

with child as (
    select id_familia as from_field
    from [wh_silver].[stg_shp_mdm].[dic_com_familias]
    where id_familia is not null
),

parent as (
    select id_familia as to_field
    from [wh_silver].[stg_shp_mdm].[com_familias]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


