
    
    

select
    id_zona as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[rec_zonas]
where id_zona is not null
group by id_zona
having count(*) > 1


