

with source_data as (
    select
        coalesce(
    nullif(ltrim(rtrim(cast([tipo_vo] as varchar(100)))), '')
, '(en blanco)') as tipo_vo_raw,
        
    nullif(ltrim(rtrim(cast([id_tipo_stock] as varchar(100)))), '')
 as id_tipo_stock_vo_raw,
        
    nullif(ltrim(rtrim(cast([desc_tipo_stock] as varchar(255)))), '')
 as des_tipo_stock_vo_raw,
        
    nullif(ltrim(rtrim(cast([fec_ini] as varchar(100)))), '')
 as fec_ini_raw,
        
    nullif(ltrim(rtrim(cast([fec_fin] as varchar(100)))), '')
 as fec_fin_raw
    from [lh_bronze].[sharepoint_mdm].[dic_com_tipo_vo_tipo_stock]
),

typed as (
    select
        tipo_vo_raw as tipo_vo,
        try_cast(id_tipo_stock_vo_raw as int) as id_tipo_stock_vo,
        des_tipo_stock_vo_raw as des_tipo_stock_vo,
        
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
    id_tipo_stock_vo,
    des_tipo_stock_vo,
    fec_ini,
    fec_fin
from typed