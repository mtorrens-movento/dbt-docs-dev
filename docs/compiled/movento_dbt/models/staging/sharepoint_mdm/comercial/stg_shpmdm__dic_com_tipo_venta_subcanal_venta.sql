

with source_data as (
	select
		coalesce(
    nullif(ltrim(rtrim(cast([id_tipo_venta] as varchar(100)))), '')
, '(en blanco)') as id_tipo_venta_raw,
		
    nullif(ltrim(rtrim(cast([id_subcanal_venta] as varchar(100)))), '')
 as id_subcanal_venta_raw,
		
    nullif(ltrim(rtrim(cast([desc_subcanal_venta] as varchar(255)))), '')
 as des_subcanal_venta_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[dic_com_tipo_venta_scanal_venta]
),

typed as (
	select
		id_tipo_venta_raw as id_tipo_venta,
		try_cast(id_subcanal_venta_raw as int) as id_subcanal_venta,
		des_subcanal_venta_raw as des_subcanal_venta,
		
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
	id_tipo_venta,
	id_subcanal_venta,
	des_subcanal_venta,
	fec_ini,
	fec_fin
from typed