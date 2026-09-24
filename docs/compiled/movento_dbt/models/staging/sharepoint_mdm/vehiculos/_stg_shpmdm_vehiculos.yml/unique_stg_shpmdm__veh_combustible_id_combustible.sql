
    
    

select
    id_combustible as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[veh_combustibles]
where id_combustible is not null
group by id_combustible
having count(*) > 1


