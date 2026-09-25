


with latest_cutoff as (
    select top 1
        _snapshot_date as max_snapshot_date,
        _ingestion_tst as max_ingestion_tst
    from [lh_bronze].[qbi_incremental].[fmtabi_pr]
    order by _snapshot_date desc, _ingestion_tst desc
),
source_data as (
    select src.*
    from [lh_bronze].[qbi_incremental].[fmtabi_pr] as src
    inner join latest_cutoff as cut
        on src._snapshot_date = cut.max_snapshot_date
       and src._ingestion_tst = cut.max_ingestion_tst
),
con_rn as (
    select *,
        row_number() over (
            partition by taller
            order by _ingestion_tst desc
        ) as rn
    from source_data
    where taller is not null
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
        
    nullif(ltrim(rtrim(cast(taller as varchar(255)))), '')
 as id_taller,
        
    nullif(ltrim(rtrim(cast(nom_taller as varchar(255)))), '')
 as nom_taller,
        
    nullif(ltrim(rtrim(cast(marca_iv as varchar(255)))), '')
 as id_marca_iv,
        
    nullif(ltrim(rtrim(cast(localidad as varchar(255)))), '')
 as nom_localidad,
        
    nullif(ltrim(rtrim(cast(almacen as varchar(255)))), '')
 as id_almacen,
        
    nullif(ltrim(rtrim(cast(nom_almacen as varchar(255)))), '')
 as nom_almacen,
        try_cast(empresa as int) as id_empresa,
        
    nullif(ltrim(rtrim(cast(nom_empresa as varchar(255)))), '')
 as nom_empresa,
        
    nullif(ltrim(rtrim(cast(direccion_taller as varchar(255)))), '')
 as des_direccion,
        
    nullif(ltrim(rtrim(cast(nom_comercial as varchar(255)))), '')
 as nom_comercial,
        try_cast(latitud_gps as decimal(18, 6)) as num_latitud_gps,
        try_cast(longitud_gps as decimal(18, 6)) as num_longitud_gps,
        
    nullif(ltrim(rtrim(cast(talleres_mismo_recep as varchar(255)))), '')
 as des_talleres_mismo_recepcion,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)
select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 11:30:52' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select