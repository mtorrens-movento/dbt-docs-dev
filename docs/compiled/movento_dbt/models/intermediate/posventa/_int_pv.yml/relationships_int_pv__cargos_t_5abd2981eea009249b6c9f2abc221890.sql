
    
    

with child as (
    select id_agrupacion as from_field
    from [wh_silver].[int_posventa].[cargos_tipo_intervencion]
    where id_agrupacion is not null
),

parent as (
    select id_agrupacion as to_field
    from [wh_silver].[stg_shp_mdm].[pv_cols_agrup_inter]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


