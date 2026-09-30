

select *
from [wh_silver].[stg_qbi].[vehiculos]
where (
    fec_matriculacion is null
    or
    fec_matriculacion < cast('1950-01-01' as date)
    or
    fec_matriculacion > cast('2026-09-30' as date)
)
  and fec_matriculacion is not null

