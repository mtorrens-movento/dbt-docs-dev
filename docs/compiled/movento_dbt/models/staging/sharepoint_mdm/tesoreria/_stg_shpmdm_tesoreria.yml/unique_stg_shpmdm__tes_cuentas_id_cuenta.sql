
    
    

select
    id_cuenta as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[tes_cuentas]
where id_cuenta is not null
group by id_cuenta
having count(*) > 1


