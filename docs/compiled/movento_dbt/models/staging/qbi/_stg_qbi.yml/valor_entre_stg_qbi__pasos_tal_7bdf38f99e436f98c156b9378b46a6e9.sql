

select *
from [wh_silver].[stg_qbi].[pasos_taller_cerrados]
where (
    ud_tiempo_facturado is null
    or
    ud_tiempo_facturado < 0
    or
    ud_tiempo_facturado > 1000
)

