

with source_data as (
    select
        
    nullif(ltrim(rtrim(cast([id_zona] as varchar(100)))), '')
 as id_zona_raw,
        
    nullif(ltrim(rtrim(cast([desc_zona] as varchar(255)))), '')
 as des_zona_raw,
        
    nullif(ltrim(rtrim(cast([id_tipo_zona] as varchar(100)))), '')
 as id_tipo_zona_raw,
        
    nullif(ltrim(rtrim(cast([no_informa] as varchar(100)))), '')
 as no_informado_raw,
        
    nullif(ltrim(rtrim(cast([no_contabiliza] as varchar(100)))), '')
 as no_contabiliza_raw
    from [lh_bronze].[sharepoint_mdm].[m_rec_zonas]
),

typed as (
    select
        try_cast(id_zona_raw as int) as id_zona,
        des_zona_raw as des_zona,
        try_cast(id_tipo_zona_raw as int) as id_tipo_zona,
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
    id_zona,
    des_zona,
    id_tipo_zona,
    no_informado,
    no_contabiliza
from typed