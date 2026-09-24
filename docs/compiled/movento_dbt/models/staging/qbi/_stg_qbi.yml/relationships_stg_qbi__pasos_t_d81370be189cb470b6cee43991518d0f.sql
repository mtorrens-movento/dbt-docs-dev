
    
    

with child as (
    select id_vehiculo as from_field
    from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
    where id_vehiculo is not null
),

parent as (
    select id_vehiculo as to_field
    from [wh_silver].[stg_qbi].[vehiculos]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


