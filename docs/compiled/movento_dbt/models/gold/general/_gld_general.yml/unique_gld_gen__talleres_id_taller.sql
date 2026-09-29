
    
    

select
    id_taller as unique_field,
    count(*) as n_records

from [wh_gold].[general].[dim_talleres]
where id_taller is not null
group by id_taller
having count(*) > 1


