

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_agrupacion] as varchar(100)))), '')
 as id_agrupacion_raw,
		
    nullif(ltrim(rtrim(cast([desc_agrupacion] as varchar(255)))), '')
 as desc_agrupacion_raw,
		
    nullif(ltrim(rtrim(cast([codigo] as varchar(100)))), '')
 as codigo_raw,
		
    nullif(ltrim(rtrim(cast([id_tipo_intervencion] as varchar(100)))), '')
 as id_tipo_intervencion_raw,
		
    nullif(ltrim(rtrim(cast([id_fabricante] as varchar(100)))), '')
 as id_fabricante_raw,
		
    nullif(ltrim(rtrim(cast([inicio] as varchar(100)))), '')
 as fec_inicio_raw,
		
    nullif(ltrim(rtrim(cast([fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[m_pv_codigos_inter]
),

typed as (
	select
		try_cast(id_agrupacion_raw as int) as id_agrupacion,
		desc_agrupacion_raw as desc_agrupacion,
		codigo_raw as codigo,
		try_cast(id_tipo_intervencion_raw as int) as id_tipo_intervencion,
		try_cast(id_fabricante_raw as int) as id_fabricante,
		
    coalesce(
        try_cast(fec_inicio_raw as date),
        try_convert(date, fec_inicio_raw, 103),
        try_convert(date, fec_inicio_raw, 101)
    )
 as fec_inicio,
		
    coalesce(
        try_cast(fec_fin_raw as date),
        try_convert(date, fec_fin_raw, 103),
        try_convert(date, fec_fin_raw, 101)
    )
 as fec_fin
	from source_data
)

select distinct
	id_agrupacion,
	desc_agrupacion,
	codigo,
	id_tipo_intervencion,
	id_fabricante,
	fec_inicio,
	fec_fin
from typed