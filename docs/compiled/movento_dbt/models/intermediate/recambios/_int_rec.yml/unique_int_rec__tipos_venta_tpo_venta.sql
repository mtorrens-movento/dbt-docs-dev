
    
    

select
    tpo_venta as unique_field,
    count(*) as n_records

from [wh_silver].[int_recambios].[tipos_venta]
where tpo_venta is not null
group by tpo_venta
having count(*) > 1


