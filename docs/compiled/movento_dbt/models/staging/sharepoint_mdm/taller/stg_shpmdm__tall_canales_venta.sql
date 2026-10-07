

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_canal_venta] as varchar(100)))), '')
 as id_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([desc_canal_venta] as varchar(255)))), '')
 as des_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([orden_canal] as varchar(100)))), '')
 as orden_canal_raw
	from [lh_bronze].[sharepoint_mdm].[m_tall_canales_venta]
),

typed as (
	select
		try_cast(id_canal_venta_raw as int) as id_canal_venta,
		des_canal_venta_raw as des_canal_venta,
		try_cast(orden_canal_raw as int) as orden_canal
	from source_data
)

select distinct
	id_canal_venta,
	des_canal_venta,
	orden_canal
from typed