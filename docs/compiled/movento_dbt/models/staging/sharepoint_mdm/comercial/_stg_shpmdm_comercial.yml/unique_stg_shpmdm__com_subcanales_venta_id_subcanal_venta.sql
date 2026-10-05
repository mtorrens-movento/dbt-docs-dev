
    
    

select
    id_subcanal_venta as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[com_subcanales_venta]
where id_subcanal_venta is not null
group by id_subcanal_venta
having count(*) > 1


