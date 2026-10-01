
    
    

select
    id_servicio_taller as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[tall_servicios_taller]
where id_servicio_taller is not null
group by id_servicio_taller
having count(*) > 1


