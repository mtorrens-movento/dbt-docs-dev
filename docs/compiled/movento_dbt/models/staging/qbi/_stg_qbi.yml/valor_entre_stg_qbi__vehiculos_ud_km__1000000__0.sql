

select *
from [wh_silver].[stg_qbi].[vehiculos]
where (
    ud_km is null
    or
    ud_km < 0
    or
    ud_km > 1000000
)

