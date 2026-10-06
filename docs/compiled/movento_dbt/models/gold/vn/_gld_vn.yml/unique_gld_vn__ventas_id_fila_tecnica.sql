
    
    

select
    id_fila_tecnica as unique_field,
    count(*) as n_records

from [wh_gold].[vn].[facts_ventas]
where id_fila_tecnica is not null
group by id_fila_tecnica
having count(*) > 1


