
    
    

select
    id_flujo as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[tes_flujos]
where id_flujo is not null
group by id_flujo
having count(*) > 1


