
    
    

with child as (
    select id_reg_concesion as from_field
    from [wh_silver].[stg_shp_mdm].[dic_tall_tall_concesion]
    where id_reg_concesion is not null
),

parent as (
    select id_reg_concesion as to_field
    from [wh_silver].[stg_shp_mdm].[gen_concesion]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


