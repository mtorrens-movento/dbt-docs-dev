
    
    

with child as (
    select id_canal_origen as from_field
    from [wh_silver].[stg_shp_mdm].[dic_com_tipo_vo_canal_origen]
    where id_canal_origen is not null
),

parent as (
    select id_canal_origen as to_field
    from [wh_silver].[stg_shp_mdm].[com_canales_origen]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


