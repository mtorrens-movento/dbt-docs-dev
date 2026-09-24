
    
    

with child as (
    select id_taller_ultima_visita as from_field
    from [wh_silver].[stg_qbi].[vehiculos]
    where id_taller_ultima_visita is not null
),

parent as (
    select id_taller as to_field
    from [wh_silver].[stg_qbi].[talleres]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


