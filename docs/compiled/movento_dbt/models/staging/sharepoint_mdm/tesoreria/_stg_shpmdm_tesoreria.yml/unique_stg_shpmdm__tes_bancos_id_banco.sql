
    
    

select
    id_banco as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[tes_bancos]
where id_banco is not null
group by id_banco
having count(*) > 1


