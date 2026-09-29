

select *
from [wh_silver].[stg_qbi].[ventas_almacen]
where (
    imp_total_base_imponible is null
    or
    imp_total_base_imponible < 0
    or
    imp_total_base_imponible > 1000000
)

