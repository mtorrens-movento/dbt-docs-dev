


select
    v.id_marca,
    count(*) as ud_vehiculos_sin_regla
from [wh_silver].[stg_qbi].[vehiculos] as v
where v.id_marca is not null
  and not exists (
      select 1
      from [wh_silver].[stg_shp_mdm].[pv_marcas_prox_inter] as r
      where r.id_marca = v.id_marca
  )
group by v.id_marca