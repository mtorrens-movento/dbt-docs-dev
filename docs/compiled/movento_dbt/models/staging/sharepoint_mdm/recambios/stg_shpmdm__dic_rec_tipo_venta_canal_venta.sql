

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([tipo_venta] as varchar(100)))), '')
 as tipo_venta_raw,
		
    nullif(ltrim(rtrim(cast([id_canal_venta] as varchar(100)))), '')
 as id_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([desc_canal_venta] as varchar(255)))), '')
 as des_canal_venta_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[dic_rec_tipo_venta_canal_venta]
),

typed as (
	select
		tipo_venta_raw as tipo_venta,
		try_cast(id_canal_venta_raw as int) as id_canal_venta,
		des_canal_venta_raw as des_canal_venta,
		
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
	tipo_venta,
	id_canal_venta,
	des_canal_venta,
	fec_ini,
	fec_fin
from typed