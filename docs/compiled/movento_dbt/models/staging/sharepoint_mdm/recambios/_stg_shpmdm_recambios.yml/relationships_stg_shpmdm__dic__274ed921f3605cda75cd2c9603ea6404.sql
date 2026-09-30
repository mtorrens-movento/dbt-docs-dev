
    
    

with child as (
    select id_canal_venta as from_field
    from [wh_silver].[stg_shp_mdm].[dic_rec_tipo_venta_canal_venta]
    where id_canal_venta is not null
),

parent as (
    select id_canal_venta as to_field
    from [wh_silver].[stg_shp_mdm].[rec_canales_venta]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


