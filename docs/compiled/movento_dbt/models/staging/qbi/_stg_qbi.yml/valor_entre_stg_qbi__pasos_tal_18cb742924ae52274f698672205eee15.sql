

select *
from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
where (
    ud_tiempo_invertido is null
    or
    ud_tiempo_invertido < 0
    or
    ud_tiempo_invertido > 1000
)

