
    
    

select
    id_tipo_zona as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[rec_tipos_zonas]
where id_tipo_zona is not null
group by id_tipo_zona
having count(*) > 1


