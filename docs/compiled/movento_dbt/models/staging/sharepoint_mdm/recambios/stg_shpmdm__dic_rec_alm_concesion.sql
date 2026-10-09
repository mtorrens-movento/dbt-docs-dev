

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_almacen] as varchar(100)))), '')
 as id_almacen_raw,
		
    nullif(ltrim(rtrim(cast([id_reg_concesion] as varchar(100)))), '')
 as id_reg_concesion_raw,
		
    nullif(ltrim(rtrim(cast([nom_concesion] as varchar(255)))), '')
 as nom_concesion_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[dic_rec_alm_concesion]
),

typed as (
	select
		id_almacen_raw as id_almacen,
		try_cast(id_reg_concesion_raw as int) as id_reg_concesion,
		nom_concesion_raw as nom_concesion,
		
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
	id_almacen,
	id_reg_concesion,
	nom_concesion,
	fec_ini,
	fec_fin
from typed