
    
    

with child as (
    select id_orden_reparacion as from_field
    from [wh_silver].[int_posventa].[cargos_tipo_intervencion]
    where id_orden_reparacion is not null
),

parent as (
    select id_orden_reparacion as to_field
    from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


