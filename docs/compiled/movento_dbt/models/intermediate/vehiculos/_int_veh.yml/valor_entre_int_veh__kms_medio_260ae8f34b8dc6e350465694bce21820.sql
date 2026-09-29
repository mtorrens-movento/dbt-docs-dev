

select *
from [wh_silver].[int_vehiculos].[kms_medios]
where (
    ud_km_medio_mensual is null
    or
    ud_km_medio_mensual < 0
    or
    ud_km_medio_mensual > 10000
)
  and ud_km_medio_mensual is not null

