

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_familia] as varchar(100)))), '')
 as id_familia_raw,
		
    nullif(ltrim(rtrim(cast([desc_familia] as varchar(255)))), '')
 as des_familia_raw,
		
    nullif(ltrim(rtrim(cast([id_marca] as varchar(100)))), '')
 as id_marca_raw,
		
    nullif(ltrim(rtrim(cast([id_subsegmento] as varchar(100)))), '')
 as id_subsegmento_raw,
		
    nullif(ltrim(rtrim(cast([cod_familia] as varchar(100)))), '')
 as cod_familia_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
	from [lh_bronze].[sharepoint_mdm].[m_com_familias]
),

typed as (
	select
		try_cast(id_familia_raw as int) as id_familia,
		des_familia_raw as des_familia,
		try_cast(id_marca_raw as int) as id_marca,
		try_cast(id_subsegmento_raw as int) as id_subsegmento,
		cod_familia_raw as cod_familia,
		case no_informado_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_informado,
		case no_contabiliza_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_contabiliza
	from source_data
)

select distinct
	id_familia,
	des_familia,
	id_marca,
	id_subsegmento,
	cod_familia,
	no_informado,
	no_contabiliza
from typed
where id_familia is not null