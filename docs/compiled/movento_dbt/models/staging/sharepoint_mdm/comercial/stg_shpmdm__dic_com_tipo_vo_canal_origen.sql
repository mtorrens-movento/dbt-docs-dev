

with source_data as (
	select
		coalesce(
    nullif(ltrim(rtrim(cast([tipo_vo] as varchar(100)))), '')
, '(en blanco)') as tipo_vo_raw,
		
    nullif(ltrim(rtrim(cast([id_canal_origen] as varchar(100)))), '')
 as id_canal_origen_raw,
		
    nullif(ltrim(rtrim(cast([desc_canal_origen] as varchar(255)))), '')
 as des_canal_origen_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[dic_com_tipo_vo_canal_origen]
),

typed as (
	select
		tipo_vo_raw as tipo_vo,
		try_cast(id_canal_origen_raw as int) as id_canal_origen,
		des_canal_origen_raw as des_canal_origen,
		
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
 as fec_fin
	from source_data
)

select distinct
	tipo_vo,
	id_canal_origen,
	des_canal_origen,
	fec_ini,
	fec_fin
from typed