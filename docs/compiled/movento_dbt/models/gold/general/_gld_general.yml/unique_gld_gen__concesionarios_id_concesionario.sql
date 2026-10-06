
    
    

select
    id_concesionario as unique_field,
    count(*) as n_records

from [wh_gold].[general].[dim_concesionarios]
where id_concesionario is not null
group by id_concesionario
having count(*) > 1


