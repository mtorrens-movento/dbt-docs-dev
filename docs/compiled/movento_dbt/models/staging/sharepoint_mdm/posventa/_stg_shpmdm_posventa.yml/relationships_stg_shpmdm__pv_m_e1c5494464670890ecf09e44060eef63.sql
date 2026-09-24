
    
    

with child as (
    select id_marca as from_field
    from [wh_silver].[stg_shp_mdm].[pv_marcas_col_agrup_inter]
    where id_marca is not null
),

parent as (
    select id_marca as to_field
    from [wh_silver].[stg_shp_mdm].[gen_marcas]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


