
    
    

with child as (
    select id_tipo_stock_vo as from_field
    from [wh_silver].[stg_shp_mdm].[dic_com_tipo_vo_tipo_stock]
    where id_tipo_stock_vo is not null
),

parent as (
    select id_tipo_stock_vo as to_field
    from [wh_silver].[stg_shp_mdm].[com_tipo_stock_vo]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


