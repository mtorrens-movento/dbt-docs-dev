

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_servicio_taller] as varchar(100)))), '')
 as id_servicio_taller_raw,
		
    nullif(ltrim(rtrim(cast([desc_servicio_taller] as varchar(255)))), '')
 as desc_servicio_taller_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
	from [lh_bronze].[sharepoint_mdm].[m_tall_servicios_taller]
),

typed as (
	select
		try_cast(id_servicio_taller_raw as int) as id_servicio_taller,
		desc_servicio_taller_raw as desc_servicio_taller,
		case no_informado_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_informado,
		case no_contabiliza_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_contabiliza
	from source_data
)

select distinct
	id_servicio_taller,
	desc_servicio_taller,
	no_informado,
	no_contabiliza
from typed