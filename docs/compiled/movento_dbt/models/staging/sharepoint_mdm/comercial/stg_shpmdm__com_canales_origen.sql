

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_canal_origen] as varchar(100)))), '')
 as id_canal_origen_raw,
		
    nullif(ltrim(rtrim(cast([desc_canal_origen] as varchar(255)))), '')
 as desc_canal_origen_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
	from [lh_bronze].[sharepoint_mdm].[m_com_canales_origen]
),

typed as (
	select
		try_cast(id_canal_origen_raw as int) as id_canal_origen,
		desc_canal_origen_raw as desc_canal_origen,
		case no_informado_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_informado,
		case no_contabiliza_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_contabiliza
	from source_data
)

select distinct
	id_canal_origen,
	desc_canal_origen,
	no_informado,
	no_contabiliza
from typed