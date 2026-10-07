

with source_data as (
	select
		coalesce(
    nullif(ltrim(rtrim(cast([id_vendedor] as varchar(100)))), '')
, '(en blanco)') as id_vendedor_raw,
		
    nullif(ltrim(rtrim(cast([nom_vendedor] as varchar(255)))), '')
 as nom_vendedor_raw,
		
    nullif(ltrim(rtrim(cast([id_tipo_vendedor] as varchar(100)))), '')
 as id_tipo_vendedor_raw,
		
    nullif(ltrim(rtrim(cast([desc_tipo_vendedor] as varchar(255)))), '')
 as des_tipo_vendedor_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw,
		
    nullif(ltrim(rtrim(cast([observaciones] as varchar(1000)))), '')
 as observaciones_raw,
		
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
		
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
	from [lh_bronze].[sharepoint_mdm].[m_com_vendedores]
),

typed as (
	select
		id_vendedor_raw as id_vendedor,
		nom_vendedor_raw as nom_vendedor,
		try_cast(id_tipo_vendedor_raw as int) as id_tipo_vendedor,
		des_tipo_vendedor_raw as des_tipo_vendedor,
		
    coalesce(
        try_cast(fec_ini_raw as date),
        try_convert(date, fec_ini_raw, 103),
        try_convert(date, fec_ini_raw, 101)
    )
 as fec_ini,
		
    coalesce(
        try_cast(fec_fin_raw as date),
        try_convert(date, fec_fin_raw, 103),
        try_convert(date, fec_fin_raw, 101)
    )
 as fec_fin,
		observaciones_raw as observaciones,
		case no_informado_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_informado,
		case no_contabiliza_raw when 'S' then cast(1 as bit) when 'N' then cast(0 as bit) end as no_contabiliza
	from source_data
)

select distinct
	id_vendedor,
	nom_vendedor,
	id_tipo_vendedor,
	des_tipo_vendedor,
	fec_ini,
	fec_fin,
	observaciones,
	no_informado,
	no_contabiliza
from typed