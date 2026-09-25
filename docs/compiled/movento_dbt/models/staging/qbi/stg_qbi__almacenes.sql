

with latest_cutoff as (
    select top 1
        _snapshot_date as max_snapshot_date,
        _ingestion_tst as max_ingestion_tst
    from [lh_bronze].[qbi_incremental].[fmalbi_pr]
    order by _snapshot_date desc, _ingestion_tst desc
),

source_data as (
    select src.*
    from [lh_bronze].[qbi_incremental].[fmalbi_pr] as src
    inner join latest_cutoff as cut
        on src._snapshot_date = cut.max_snapshot_date
       and src._ingestion_tst = cut.max_ingestion_tst
),

con_rn as (
    select
        *,
        row_number() over (
            partition by almacen
            order by _ingestion_tst desc
        ) as rn
    from source_data
    where almacen is not null
),

unicos as (
    select *
    from con_rn
    where rn = 1
),

final_select as (
    select
        
    nullif(ltrim(rtrim(cast(refx as varchar(255)))), '')
 as id_fila_tecnica,
        
    nullif(ltrim(rtrim(cast(almacen as varchar(255)))), '')
 as id_almacen,
        
    nullif(ltrim(rtrim(cast(nom_almacen as varchar(255)))), '')
 as nom_almacen,
        try_cast(empresa as int) as id_empresa,
        
    nullif(ltrim(rtrim(cast(nom_empresa as varchar(255)))), '')
 as nom_empresa,
        
    nullif(ltrim(rtrim(cast(direccion as varchar(255)))), '')
 as des_direccion,
        
    nullif(ltrim(rtrim(cast(localidad as varchar(255)))), '')
 as nom_localidad,
        try_cast(almacen_consumos as int) as id_almacen_consumos,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)   

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 12:49:51' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select