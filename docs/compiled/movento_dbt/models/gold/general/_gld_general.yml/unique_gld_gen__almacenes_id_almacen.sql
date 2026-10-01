
    
    

select
    id_almacen as unique_field,
    count(*) as n_records

from [wh_gold].[general].[dim_almacenes]
where id_almacen is not null
group by id_almacen
having count(*) > 1


