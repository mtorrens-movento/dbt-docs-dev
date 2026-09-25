
    
    

select
    id_fecha as unique_field,
    count(*) as n_records

from [wh_gold].[general].[dim_fecha]
where id_fecha is not null
group by id_fecha
having count(*) > 1


