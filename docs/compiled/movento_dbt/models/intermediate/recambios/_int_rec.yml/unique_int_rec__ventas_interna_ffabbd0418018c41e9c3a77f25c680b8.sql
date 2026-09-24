
    
    

select
    concat(id_orden_venta, '-', cast(seq_linea_venta as varchar(50))) as unique_field,
    count(*) as n_records

from [wh_silver].[int_recambios].[ventas_internas]
where concat(id_orden_venta, '-', cast(seq_linea_venta as varchar(50))) is not null
group by concat(id_orden_venta, '-', cast(seq_linea_venta as varchar(50)))
having count(*) > 1


