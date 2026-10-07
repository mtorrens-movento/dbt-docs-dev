
    
    

select
    id_fila_tecnica as unique_field,
    count(*) as n_records

from [wh_silver].[int_vo].[stock_enriquecido]
where id_fila_tecnica is not null
group by id_fila_tecnica
having count(*) > 1


