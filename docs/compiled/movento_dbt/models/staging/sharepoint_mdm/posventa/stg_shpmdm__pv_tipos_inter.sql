

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_intervencion] as varchar(100)))), '')
 as id_tipo_intervencion_raw,
		
    nullif(ltrim(rtrim(cast([desc_intervencion] as varchar(255)))), '')
 as desc_intervencion_raw,
		
    nullif(ltrim(rtrim(cast([nombre_col_sf] as varchar(50)))), '')
 as nom_col_sf
	from [lh_bronze].[sharepoint_mdm].[m_pv_tipos_inter]
),

typed as (
	select
		try_cast(id_tipo_intervencion_raw as int) as id_tipo_intervencion,
		desc_intervencion_raw as des_intervencion,
		nom_col_sf as nom_col_sf
	from source_data
)

select distinct
	id_tipo_intervencion,
	des_intervencion,
	nom_col_sf
from typed