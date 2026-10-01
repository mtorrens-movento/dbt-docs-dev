

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_canal_venta] as varchar(100)))), '')
 as id_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([canal_venta] as varchar(255)))), '')
 as canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([id_agrup_canal] as varchar(100)))), '')
 as id_agrup_canal_raw,
		
    nullif(ltrim(rtrim(cast([desc_agrup_canal] as varchar(255)))), '')
 as desc_agrup_canal_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
	from [lh_bronze].[sharepoint_mdm].[m_rec_canales_venta]
),

typed as (
	select
		try_cast(id_canal_venta_raw as int) as id_canal_venta,
		canal_venta_raw as canal_venta,
		try_cast(id_agrup_canal_raw as int) as id_agrup_canal,
		desc_agrup_canal_raw as desc_agrup_canal,
		case no_informado_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_informado,
		case no_contabiliza_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_contabiliza
	from source_data
)

select distinct
	id_canal_venta,
	canal_venta,
	id_agrup_canal,
	desc_agrup_canal,
	no_informado,
	no_contabiliza
from typed