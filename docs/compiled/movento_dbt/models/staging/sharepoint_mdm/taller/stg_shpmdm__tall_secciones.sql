

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_subseccion] as varchar(100)))), '')
 as id_subseccion_raw,
		
    nullif(ltrim(rtrim(cast([desc_subseccion] as varchar(255)))), '')
 as desc_subseccion_raw,
		
    nullif(ltrim(rtrim(cast([id_seccion] as varchar(100)))), '')
 as id_seccion_raw,
		
    nullif(ltrim(rtrim(cast([desc_seccion] as varchar(255)))), '')
 as desc_seccion_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
	from [lh_bronze].[sharepoint_mdm].[m_tall_secciones]
),

typed as (
	select
		try_cast(id_subseccion_raw as int) as id_subseccion,
		desc_subseccion_raw as desc_subseccion,
		try_cast(id_seccion_raw as int) as id_seccion,
		desc_seccion_raw as desc_seccion,
		try_cast(no_informado_raw as bit) as no_informado,
		try_cast(no_contabiliza_raw as bit) as no_contabiliza
	from source_data
)

select distinct
	id_subseccion,
	desc_subseccion,
	id_seccion,
	desc_seccion,
	no_informado,
	no_contabiliza
from typed