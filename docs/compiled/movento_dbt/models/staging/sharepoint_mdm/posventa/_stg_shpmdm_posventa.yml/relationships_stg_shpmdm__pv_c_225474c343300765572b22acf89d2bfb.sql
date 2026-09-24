
    
    

with child as (
    select id_tipo_intervencion as from_field
    from [wh_silver].[stg_shp_mdm].[pv_codigos_inter]
    where id_tipo_intervencion is not null
),

parent as (
    select id_tipo_intervencion as to_field
    from [wh_silver].[stg_shp_mdm].[pv_tipos_inter]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


