

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([Code] as varchar(100)))), '')
 as code_raw,
		
    nullif(ltrim(rtrim(cast([Description] as varchar(255)))), '')
 as description_raw
	from [lh_bronze].[sharepoint_mdm].[m_tes_flujos]
),

typed as (
	select
		code_raw as id_flujo,
		description_raw as des_flujo
	from source_data
)

select
	*
from typed