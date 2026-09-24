
    
    

select
    id_vehiculo as unique_field,
    count(*) as n_records

from [wh_silver].[stg_qbi].[vehiculos]
where id_vehiculo is not null
group by id_vehiculo
having count(*) > 1


