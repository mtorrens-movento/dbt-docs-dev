
    
    

select
    id_repris as unique_field,
    count(*) as n_records

from [wh_silver].[int_comercial].[repris]
where id_repris is not null
group by id_repris
having count(*) > 1


