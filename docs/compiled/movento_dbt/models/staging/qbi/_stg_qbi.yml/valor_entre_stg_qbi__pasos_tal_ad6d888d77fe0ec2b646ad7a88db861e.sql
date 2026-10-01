

select *
from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
where (
    fec_apertura_or is null
    or
    fec_apertura_or < cast('1950-01-01' as date)
    or
    fec_apertura_or > cast('2026-10-01' as date)
)

