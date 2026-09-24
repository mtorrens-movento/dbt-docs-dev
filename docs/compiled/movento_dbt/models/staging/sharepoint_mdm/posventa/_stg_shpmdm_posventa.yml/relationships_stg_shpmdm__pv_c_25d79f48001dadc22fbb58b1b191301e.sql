
    
    

with child as (
    select id_fabricante as from_field
    from [wh_silver].[stg_shp_mdm].[pv_codigos_inter]
    where id_fabricante is not null
),

parent as (
    select id_fabricante as to_field
    from [wh_silver].[stg_shp_mdm].[gen_fabricantes]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


