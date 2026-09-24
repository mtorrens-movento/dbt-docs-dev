

with latest_cutoff as (
    select top 1
        _snapshot_date as max_snapshot_date,
        _ingestion_tst as max_ingestion_tst
    from [lh_bronze].[qbi_incremental].[usuatribi_pr]
    order by _snapshot_date desc, _ingestion_tst desc
),

source_data as (
    select src.*
    from [lh_bronze].[qbi_incremental].[usuatribi_pr] as src
    inner join latest_cutoff as cut
        on src._snapshot_date = cut.max_snapshot_date
       and src._ingestion_tst = cut.max_ingestion_tst
),

final_select as (
    select
        
    nullif(ltrim(rtrim(cast(refx as varchar(255)))), '')
 as id_fila_tecnica,
        
    nullif(ltrim(rtrim(cast(identificador as varchar(255)))), '')
 as id_usuario,
        
    nullif(ltrim(rtrim(cast(atributo as varchar(255)))), '')
 as cat_atributo,
        
    nullif(ltrim(rtrim(cast(des_atributo as varchar(255)))), '')
 as des_atributo,
        
    nullif(ltrim(rtrim(cast(valor_atributo as varchar(255)))), '')
 as des_valor_atributo,
        
    nullif(ltrim(rtrim(cast(tipo_objeto as varchar(255)))), '')
 as cat_tipo_objeto,
        
    nullif(ltrim(rtrim(cast(cod_objeto as varchar(255)))), '')
 as cat_fichero_objeto,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from source_data
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-24 08:05:02' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select