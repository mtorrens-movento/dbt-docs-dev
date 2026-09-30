

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([tipo_or] as varchar(100)))), '')
 as tipo_or_raw,
		
    nullif(ltrim(rtrim(cast([id_seccion_taller] as varchar(100)))), '')
 as id_seccion_taller_raw,
		
    nullif(ltrim(rtrim(cast([desc_seccion_taller] as varchar(255)))), '')
 as desc_seccion_taller_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[dic_tall_tipo_or_seccion]
),

typed as (
	select
		tipo_or_raw as tipo_or,
		try_cast(id_seccion_taller_raw as int) as id_seccion_taller,
		desc_seccion_taller_raw as desc_seccion_taller,
		
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
	tipo_or,
	id_seccion_taller,
	desc_seccion_taller,
	fec_ini,
	fec_fin
from typed