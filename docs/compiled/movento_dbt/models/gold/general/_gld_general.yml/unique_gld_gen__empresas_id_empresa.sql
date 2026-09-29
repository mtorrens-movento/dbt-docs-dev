
    
    

select
    id_empresa as unique_field,
    count(*) as n_records

from [wh_gold].[general].[dim_empresas]
where id_empresa is not null
group by id_empresa
having count(*) > 1


