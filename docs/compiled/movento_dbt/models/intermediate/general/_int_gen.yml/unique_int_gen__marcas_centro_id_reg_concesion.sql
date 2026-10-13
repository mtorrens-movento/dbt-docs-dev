
    
    

select
    id_reg_concesion as unique_field,
    count(*) as n_records

from [wh_silver].[int_general].[marcas_centro]
where id_reg_concesion is not null
group by id_reg_concesion
having count(*) > 1


