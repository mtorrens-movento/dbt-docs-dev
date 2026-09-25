


with latest_cutoff as (
    select top 1
        _snapshot_date as max_snapshot_date,
        _ingestion_tst as max_ingestion_tst
    from [lh_bronze].[qbi_incremental].[fmconcbi_pr]
    order by _snapshot_date desc, _ingestion_tst desc
),

source_data as (
    select src.*
    from [lh_bronze].[qbi_incremental].[fmconcbi_pr] as src
    inner join latest_cutoff as cut
        on src._snapshot_date = cut.max_snapshot_date
       and src._ingestion_tst = cut.max_ingestion_tst
),

con_rn as (
    select *,
        row_number() over (
            partition by concesionario
            order by _ingestion_tst desc
        ) as rn
    from source_data
    where concesionario is not null
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
        
    nullif(ltrim(rtrim(cast(concesionario as varchar(255)))), '')
 as id_concesionario,
        
    nullif(ltrim(rtrim(cast(nom_concesionario as varchar(255)))), '')
 as nom_concesionario,
        
    nullif(ltrim(rtrim(cast(nom_completo as varchar(255)))), '')
 as nom_completo,
        
    nullif(ltrim(rtrim(cast(nom_comercial as varchar(255)))), '')
 as nom_comercial,
        
    nullif(ltrim(rtrim(cast(direccion as varchar(255)))), '')
 as des_direccion,
        
    nullif(ltrim(rtrim(cast(localidad as varchar(255)))), '')
 as nom_localidad,
        
    nullif(ltrim(rtrim(cast(telefono as varchar(255)))), '')
 as tel_telefono,
        try_cast(empresa as int) as id_empresa,
        
    nullif(ltrim(rtrim(cast(nom_empresa as varchar(255)))), '')
 as nom_empresa,
        try_cast(marca as int) as cod_marca,
        
    nullif(ltrim(rtrim(cast(des_marca as varchar(255)))), '')
 as des_marca,
        try_cast(sucursal as int) as id_sucursal,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 11:30:52' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select