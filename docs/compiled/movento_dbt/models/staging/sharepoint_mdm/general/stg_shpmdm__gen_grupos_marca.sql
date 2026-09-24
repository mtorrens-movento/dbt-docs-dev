

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_grupo_marca] as varchar(100)))), '')
 as id_grupo_marca_raw,
		
    nullif(ltrim(rtrim(cast([nom_grupo_marca] as varchar(255)))), '')
 as nom_grupo_marca_raw
	from [lh_bronze].[sharepoint_mdm].[m_gen_grupos_marcas]
),

typed as (
	select
		try_cast(id_grupo_marca_raw as int) as id_grupo_marca,
		nom_grupo_marca_raw as nom_grupo_marca
	from source_data
)

select distinct
	id_grupo_marca,
	nom_grupo_marca
from typed