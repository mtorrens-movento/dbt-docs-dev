

with source_data as (
    select
        
    nullif(ltrim(rtrim(cast([id_ruta] as varchar(100)))), '')
 as id_ruta_raw,
        
    nullif(ltrim(rtrim(cast([id_zona] as varchar(100)))), '')
 as id_zona_raw,
        
    nullif(ltrim(rtrim(cast([des_zona] as varchar(255)))), '')
 as des_zona_raw,
        
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
        
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
    from [lh_bronze].[sharepoint_mdm].[dic_rec_ruta_zona]
),

typed as (
    select
        id_ruta_raw as id_ruta,
        try_cast(id_zona_raw as int) as id_zona,
        des_zona_raw as des_zona,
        
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
    id_ruta,
    id_zona,
    des_zona,
    fec_ini,
    fec_fin
from typed