

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([id_fabricante] as varchar(100)))), '')
 as id_fabricante_raw,
		
    nullif(ltrim(rtrim(cast([nom_fabricante] as varchar(255)))), '')
 as nom_fabricante_raw
	from [lh_bronze].[sharepoint_mdm].[m_gen_fabricantes]
),

typed as (
	select
		try_cast(id_fabricante_raw as int) as id_fabricante,
		nom_fabricante_raw as nom_fabricante
	from source_data
)

select
	*
from typed