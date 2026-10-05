

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_canal_venta] as varchar(100)))), '')
 as id_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([desc_canal_venta] as varchar(255)))), '')
 as desc_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw,
		
    nullif(ltrim(rtrim(cast([id_actividad_final] as varchar(100)))), '')
 as id_actividad_final_raw
	from [lh_bronze].[sharepoint_mdm].[m_com_canales_venta]
),

typed as (
	select
		try_cast(id_canal_venta_raw as int) as id_canal_venta,
		desc_canal_venta_raw as desc_canal_venta,
		case no_informado_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_informado,
		case no_contabiliza_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_contabiliza,
		try_cast(id_actividad_final_raw as int) as id_actividad_final
	from source_data
)

select distinct
	id_canal_venta,
	desc_canal_venta,
	no_informado,
	no_contabiliza,
	id_actividad_final
from typed