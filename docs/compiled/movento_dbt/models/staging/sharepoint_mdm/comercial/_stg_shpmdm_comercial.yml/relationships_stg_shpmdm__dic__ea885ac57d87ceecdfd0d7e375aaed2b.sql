
    
    

with child as (
    select id_subcanal_venta as from_field
    from [wh_silver].[stg_shp_mdm].[dic_com_tipo_venta_subcanal_venta]
    where id_subcanal_venta is not null
),

parent as (
    select id_subcanal_venta as to_field
    from [wh_silver].[stg_shp_mdm].[com_subcanales_venta]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


