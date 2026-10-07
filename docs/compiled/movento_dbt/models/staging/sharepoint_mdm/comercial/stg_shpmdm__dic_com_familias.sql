

with source_data as (
	select
		coalesce(
    nullif(ltrim(rtrim(cast([id_familia_quiter] as varchar(100)))), '')
, '(en blanco)') as id_familia_quiter_raw,
		
    nullif(ltrim(rtrim(cast([desc_familia] as varchar(255)))), '')
 as des_familia_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw,
		
    nullif(ltrim(rtrim(cast([id_familia] as varchar(100)))), '')
 as id_familia_raw
	from [lh_bronze].[sharepoint_mdm].[dic_com_familias]
),

typed as (
	select
		id_familia_quiter_raw as id_familia_quiter,
		des_familia_raw as des_familia,
		
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
		try_cast(id_familia_raw as int) as id_familia
	from source_data
)

select distinct
	id_familia_quiter,
	des_familia,
	fec_ini,
	fec_fin,
	id_familia
from typed
where id_familia_quiter is not null