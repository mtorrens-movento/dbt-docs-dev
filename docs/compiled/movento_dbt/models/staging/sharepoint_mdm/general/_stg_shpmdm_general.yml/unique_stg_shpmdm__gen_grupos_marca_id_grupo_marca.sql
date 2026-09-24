
    
    

select
    id_grupo_marca as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[gen_grupos_marca]
where id_grupo_marca is not null
group by id_grupo_marca
having count(*) > 1


