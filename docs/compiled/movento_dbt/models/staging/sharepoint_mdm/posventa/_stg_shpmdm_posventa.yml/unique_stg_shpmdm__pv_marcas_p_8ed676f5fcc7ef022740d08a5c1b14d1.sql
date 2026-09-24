
    
    

select
    concat(id_marca, '-', cast(id_grupo_combustible as varchar(10)), '-', cast(id_tipo_intervencion as varchar(10))) as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[pv_marcas_prox_inter]
where concat(id_marca, '-', cast(id_grupo_combustible as varchar(10)), '-', cast(id_tipo_intervencion as varchar(10))) is not null
group by concat(id_marca, '-', cast(id_grupo_combustible as varchar(10)), '-', cast(id_tipo_intervencion as varchar(10)))
having count(*) > 1


