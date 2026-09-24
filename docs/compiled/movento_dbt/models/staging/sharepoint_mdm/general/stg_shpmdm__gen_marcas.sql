

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([code_marca] as varchar(100)))), '')
 as code_marca_raw,
		
    nullif(ltrim(rtrim(cast([nom_marca] as varchar(255)))), '')
 as nom_marca_raw,
		
    nullif(ltrim(rtrim(cast([id_grupo_marca] as varchar(100)))), '')
 as id_grupo_marca_raw,
		
    nullif(ltrim(rtrim(cast([nom_grupo_marca] as varchar(255)))), '')
 as nom_grupo_marca_raw,
		
    nullif(ltrim(rtrim(cast([id_fabricante] as varchar(100)))), '')
 as id_fabricante_raw,
		
    nullif(ltrim(rtrim(cast([nom_fabricante] as varchar(255)))), '')
 as nom_fabricante_raw,
		
    nullif(ltrim(rtrim(cast([incio] as varchar(100)))), '')
 as fec_inicio_raw,
		
    nullif(ltrim(rtrim(cast([fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[m_gen_marcas]
),

typed as (
	select
		code_marca_raw as id_marca,
		nom_marca_raw as nom_marca,
		try_cast(id_grupo_marca_raw as int) as id_grupo_marca,
		nom_grupo_marca_raw as nom_grupo_marca,
		try_cast(id_fabricante_raw as int) as id_fabricante,
		nom_fabricante_raw as nom_fabricante,
		
    coalesce(
        try_cast(fec_inicio_raw as date),
        try_convert(date, fec_inicio_raw, 103),
        try_convert(date, fec_inicio_raw, 101)
    )
 as fec_inicio,
		
    coalesce(
        try_cast(fec_fin_raw as date),
        try_convert(date, fec_fin_raw, 103),
        try_convert(date, fec_fin_raw, 101)
    )
 as fec_fin
	from source_data
)

select distinct
	id_marca,
	nom_marca,
	id_grupo_marca,
	nom_grupo_marca,
	id_fabricante,
	nom_fabricante,
	fec_inicio,
	fec_fin
from typed