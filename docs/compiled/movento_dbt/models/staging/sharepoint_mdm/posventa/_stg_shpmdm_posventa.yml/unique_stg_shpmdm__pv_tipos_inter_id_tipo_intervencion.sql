
    
    

select
    id_tipo_intervencion as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[pv_tipos_inter]
where id_tipo_intervencion is not null
group by id_tipo_intervencion
having count(*) > 1


