
    
    

with child as (
    select id_servicio_taller as from_field
    from [wh_silver].[stg_shp_mdm].[dic_tall_tipo_mo_servicio]
    where id_servicio_taller is not null
),

parent as (
    select id_servicio_taller as to_field
    from [wh_silver].[stg_shp_mdm].[tall_servicios_taller]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


