
    
    

select
    id_movimiento_compra as unique_field,
    count(*) as n_records

from [wh_silver].[stg_qbi].[compras_vo]
where id_movimiento_compra is not null
group by id_movimiento_compra
having count(*) > 1


