
    
    

select
    id_tipo_stock_vo as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[com_tipo_stock_vo]
where id_tipo_stock_vo is not null
group by id_tipo_stock_vo
having count(*) > 1


