
    
    

select
    id_canal_venta as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[tall_canales_venta]
where id_canal_venta is not null
group by id_canal_venta
having count(*) > 1


