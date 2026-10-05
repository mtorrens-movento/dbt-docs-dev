

with source_data as (
	select
		coalesce(
    nullif(ltrim(rtrim(cast([id_ven_quiter] as varchar(100)))), '')
, '(en blanco)') as id_ven_quiter_raw,
		coalesce(
    nullif(ltrim(rtrim(cast([id_ven_org] as varchar(100)))), '')
, '(en blanco)') as id_ven_org_raw,
		
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
		
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
	from [lh_bronze].[sharepoint_mdm].[dic_com_vendedores_quiter_org]
),

typed as (
	select
		id_ven_quiter_raw as id_ven_quiter,
		id_ven_org_raw as id_ven_org,
		
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
	id_ven_quiter,
	id_ven_org,
	fec_ini,
	fec_fin
from typed