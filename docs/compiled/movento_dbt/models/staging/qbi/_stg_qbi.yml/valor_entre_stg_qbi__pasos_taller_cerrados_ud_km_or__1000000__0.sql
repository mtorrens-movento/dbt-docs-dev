

select *
from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
where (
    ud_km_or is null
    or
    ud_km_or < 0
    or
    ud_km_or > 1000000
)

