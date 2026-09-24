
    
    

select
    concat(cast(id_agrupacion as varchar(10)), '-', codigo, '-', cast(id_tipo_intervencion as varchar(10)), '-', cast(id_fabricante as varchar(10)), '-', convert(varchar(10), fec_inicio, 120)) as unique_field,
    count(*) as n_records

from [wh_silver].[stg_shp_mdm].[pv_codigos_inter]
where concat(cast(id_agrupacion as varchar(10)), '-', codigo, '-', cast(id_tipo_intervencion as varchar(10)), '-', cast(id_fabricante as varchar(10)), '-', convert(varchar(10), fec_inicio, 120)) is not null
group by concat(cast(id_agrupacion as varchar(10)), '-', codigo, '-', cast(id_tipo_intervencion as varchar(10)), '-', cast(id_fabricante as varchar(10)), '-', convert(varchar(10), fec_inicio, 120))
having count(*) > 1


