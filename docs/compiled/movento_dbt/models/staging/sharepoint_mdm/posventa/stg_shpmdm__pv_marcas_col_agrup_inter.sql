

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_marca] as varchar(100)))), '')
 as id_marca_raw,
		
    nullif(ltrim(rtrim(cast([id_agrupacion] as varchar(100)))), '')
 as id_agrupacion_raw
	from [lh_bronze].[sharepoint_mdm].[m_pv_marcas_col_agrup_inter]
),

typed as (
	select
		id_marca_raw as id_marca,
		try_cast(id_agrupacion_raw as int) as id_agrupacion
	from source_data
)

select distinct
	id_marca,
	id_agrupacion
from typed