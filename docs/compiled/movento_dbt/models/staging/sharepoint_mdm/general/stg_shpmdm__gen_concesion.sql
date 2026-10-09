

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_reg_concesion] as varchar(100)))), '')
 as id_reg_concesion_raw,
		
    nullif(ltrim(rtrim(cast([nom_concesion] as varchar(255)))), '')
 as nom_concesion_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
	from [lh_bronze].[sharepoint_mdm].[m_gen_concesion]
),

typed as (
	select
		try_cast(id_reg_concesion_raw as int) as id_reg_concesion,
		nom_concesion_raw as nom_concesion,
		case no_informado_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_informado,
		case no_contabiliza_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_contabiliza
	from source_data
)

select distinct
	id_reg_concesion,
	nom_concesion,
	no_informado,
	no_contabiliza
from typed