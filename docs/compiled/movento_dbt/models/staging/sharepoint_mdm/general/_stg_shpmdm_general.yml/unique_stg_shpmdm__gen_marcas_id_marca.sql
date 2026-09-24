
    
    

select
    id_marca as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[gen_marcas]
where id_marca is not null
group by id_marca
having count(*) > 1


