
    
    

select
    id_familia as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[com_familias]
where id_familia is not null
group by id_familia
having count(*) > 1


