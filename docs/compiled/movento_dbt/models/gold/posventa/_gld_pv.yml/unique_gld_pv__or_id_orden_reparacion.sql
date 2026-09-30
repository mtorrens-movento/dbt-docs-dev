
    
    

select
    id_orden_reparacion as unique_field,
    count(*) as n_records

from [wh_gold].[posventa].[facts_or]
where id_orden_reparacion is not null
group by id_orden_reparacion
having count(*) > 1


