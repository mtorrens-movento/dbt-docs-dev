
    
    

select
    id_orden_reparacion as unique_field,
    count(*) as n_records

from [wh_silver].[int_posventa].[pasos_referencia_collapsed]
where id_orden_reparacion is not null
group by id_orden_reparacion
having count(*) > 1


