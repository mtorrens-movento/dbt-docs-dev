
    
    

select
    id_subseccion as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[tall_secciones]
where id_subseccion is not null
group by id_subseccion
having count(*) > 1


