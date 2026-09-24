

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([Bank Code] as varchar(100)))), '')
 as bank_code_raw,
		
    nullif(ltrim(rtrim(cast([Bank Desc] as varchar(255)))), '')
 as bank_desc_raw,
		
    nullif(ltrim(rtrim(cast([Bank Group] as varchar(255)))), '')
 as bank_group_raw
	from [lh_bronze].[sharepoint_mdm].[m_tes_bancos]
),

typed as (
	select
		try_cast(bank_code_raw as int) as id_banco,
		bank_desc_raw as des_banco,
		bank_group_raw as des_grupo_banco
	from source_data
)

select
	*
from typed