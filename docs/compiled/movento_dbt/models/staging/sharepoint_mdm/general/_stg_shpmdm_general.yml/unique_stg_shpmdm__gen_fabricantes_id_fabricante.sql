
    
    

select
    id_fabricante as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[gen_fabricantes]
where id_fabricante is not null
group by id_fabricante
having count(*) > 1


