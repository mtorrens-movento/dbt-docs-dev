
    
    

select
    id_agrupacion as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[pv_cols_agrup_inter]
where id_agrupacion is not null
group by id_agrupacion
having count(*) > 1


