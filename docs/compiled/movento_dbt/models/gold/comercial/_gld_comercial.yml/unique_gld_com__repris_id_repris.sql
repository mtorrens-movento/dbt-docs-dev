
    
    

select
    id_repris as unique_field,
    count(*) as n_records

from [wh_gold].[comercial].[facts_repris]
where id_repris is not null
group by id_repris
having count(*) > 1


