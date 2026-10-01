

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([tipo_mo] as varchar(100)))), '')
 as tipo_mo_raw,
		
    nullif(ltrim(rtrim(cast([id_servicio_taller] as varchar(100)))), '')
 as id_servicio_taller_raw,
		
    nullif(ltrim(rtrim(cast([desc_servicio_taller] as varchar(255)))), '')
 as desc_servicio_taller_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[dic_tall_tipo_mo_servicio]
),

typed as (
	select
		tipo_mo_raw as tipo_mo,
		try_cast(id_servicio_taller_raw as int) as id_servicio_taller,
		desc_servicio_taller_raw as desc_servicio_taller,
		
    coalesce(
        try_cast(fec_ini_raw as date),
        try_convert(date, fec_ini_raw, 103),
        try_convert(date, fec_ini_raw, 101)
    )
 as fec_ini,
		
    coalesce(
        try_cast(fec_fin_raw as date),
        try_convert(date, fec_fin_raw, 103),
        try_convert(date, fec_fin_raw, 101)
    )
 as fec_fin
	from source_data
)

select distinct
	tipo_mo,
	id_servicio_taller,
	desc_servicio_taller,
	fec_ini,
	fec_fin
from typed