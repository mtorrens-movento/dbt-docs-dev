

select *
from [wh_silver].[stg_qbi].[ventas_almacen]
where (
    ud_unidades_venta is null
    or
    ud_unidades_venta < 0
    or
    ud_unidades_venta > 1000
)

