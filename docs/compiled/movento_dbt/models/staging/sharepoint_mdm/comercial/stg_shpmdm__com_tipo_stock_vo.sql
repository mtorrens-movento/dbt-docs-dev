

with source_data as (
    select
        
    nullif(ltrim(rtrim(cast([id_tipo_stock_vo] as varchar(100)))), '')
 as id_tipo_stock_vo_raw,
        
    nullif(ltrim(rtrim(cast([des_stock_vo] as varchar(255)))), '')
 as des_tipo_stock_vo_raw,
        
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
        
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
    from [lh_bronze].[sharepoint_mdm].[m_com_tipo_stock_vo]
),

typed as (
    select
        try_cast(id_tipo_stock_vo_raw as int) as id_tipo_stock_vo,
        des_tipo_stock_vo_raw as des_tipo_stock_vo,
        case upper(no_informado_raw)
            when 'S' then cast(1 as bit)
            when 'N' then cast(0 as bit)
        end as no_informado,
        case upper(no_contabiliza_raw)
            when 'S' then cast(1 as bit)
            when 'N' then cast(0 as bit)
        end as no_contabiliza
    from source_data
)

select distinct
    id_tipo_stock_vo,
    des_tipo_stock_vo,
    no_informado,
    no_contabiliza
from typed