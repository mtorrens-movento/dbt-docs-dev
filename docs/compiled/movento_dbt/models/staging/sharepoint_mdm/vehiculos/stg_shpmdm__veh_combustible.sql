

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_combustible] as varchar(100)))), '')
 as id_combustible_raw,
		
    nullif(ltrim(rtrim(cast([desc_combustible] as varchar(255)))), '')
 as des_combustible_raw,
		
    nullif(ltrim(rtrim(cast([id_grupo_combustible] as varchar(100)))), '')
 as id_grupo_combustible_raw,
		
    nullif(ltrim(rtrim(cast([desc_grupo_combustible] as varchar(255)))), '')
 as des_grupo_combustible_raw
	from [lh_bronze].[sharepoint_mdm].[m_veh_combustible]
),

typed as (
	select
		id_combustible_raw as id_combustible,
		des_combustible_raw as des_combustible,
		try_cast(id_grupo_combustible_raw as int) as id_grupo_combustible,
		des_grupo_combustible_raw as des_grupo_combustible
	from source_data
)

select distinct
	id_combustible,
	des_combustible,
	id_grupo_combustible,
	des_grupo_combustible
from typed
where id_combustible is not null