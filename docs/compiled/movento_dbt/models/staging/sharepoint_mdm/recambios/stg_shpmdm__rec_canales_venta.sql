

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_canal_venta] as varchar(100)))), '')
 as id_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([canal_venta] as varchar(255)))), '')
 as canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([id_agrup_canal] as varchar(100)))), '')
 as id_agrup_canal_raw,
		
    nullif(ltrim(rtrim(cast([desc_agrup_canal] as varchar(255)))), '')
 as desc_agrup_canal_raw
	from [lh_bronze].[sharepoint_mdm].[m_rec_canales_venta]
),

typed as (
	select
		try_cast(id_canal_venta_raw as int) as id_canal_venta,
		canal_venta_raw as canal_venta,
		try_cast(id_agrup_canal_raw as int) as id_agrup_canal,
		desc_agrup_canal_raw as desc_agrup_canal
	from source_data
)

select distinct
	id_canal_venta,
	canal_venta,
	id_agrup_canal,
	desc_agrup_canal
from typed