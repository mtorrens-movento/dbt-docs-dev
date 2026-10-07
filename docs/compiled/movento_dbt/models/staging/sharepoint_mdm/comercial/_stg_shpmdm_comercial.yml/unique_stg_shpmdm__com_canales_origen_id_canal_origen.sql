
    
    

select
    id_canal_origen as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[com_canales_origen]
where id_canal_origen is not null
group by id_canal_origen
having count(*) > 1


