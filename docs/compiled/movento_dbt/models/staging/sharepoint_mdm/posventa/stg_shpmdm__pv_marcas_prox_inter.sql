

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_marca] as varchar(100)))), '')
 as id_marca_raw,
		
    nullif(ltrim(rtrim(cast([id_grupo_combustible] as varchar(100)))), '')
 as id_grupo_combustible_raw,
		
    nullif(ltrim(rtrim(cast([tipo_intervencion] as varchar(100)))), '')
 as tipo_intervencion_raw,
		
    nullif(ltrim(rtrim(cast([meses] as varchar(100)))), '')
 as meses_raw,
		
    nullif(ltrim(rtrim(cast([kms] as varchar(100)))), '')
 as kms_raw
	from [lh_bronze].[sharepoint_mdm].[m_pv_marcas_prox_inter]
),

typed as (
	select
		id_marca_raw as id_marca,
		try_cast(id_grupo_combustible_raw as int) as id_grupo_combustible,
		try_cast(tipo_intervencion_raw as int) as id_tipo_intervencion,
		try_cast(meses_raw as int) as meses,
		try_cast(kms_raw as int) as kms
	from source_data
)

select distinct
	id_marca,
	id_grupo_combustible,
	id_tipo_intervencion,
	meses,
	kms
from typed