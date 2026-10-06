

select *
from [wh_silver].[stg_qbi].[ventas_almacen]
where (
    fec_apertura_or is null
    or
    fec_apertura_or < cast('1950-01-01' as date)
    or
    fec_apertura_or > cast('2026-10-06' as date)
)
  and fec_apertura_or is not null

