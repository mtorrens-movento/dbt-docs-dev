

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_agrupacion] as varchar(100)))), '')
 as id_agrupacion_raw,
		
    nullif(ltrim(rtrim(cast([desc_agrupacion] as varchar(255)))), '')
 as des_agrupacion_raw
	from [lh_bronze].[sharepoint_mdm].[m_pv_agrup_cols_inter]
),

typed as (
	select
		try_cast(id_agrupacion_raw as int) as id_agrupacion,
		des_agrupacion_raw as des_agrupacion
	from source_data
)

select distinct
	id_agrupacion,
	des_agrupacion
from typed