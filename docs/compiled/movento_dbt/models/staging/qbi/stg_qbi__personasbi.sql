

with latest_cutoff as (
    select top 1
        _snapshot_date as max_snapshot_date,
        _ingestion_tst as max_ingestion_tst
    from [lh_bronze].[qbi_incremental].[personasbi_pr]
    order by _snapshot_date desc, _ingestion_tst desc
),

source_data as (
    select src.*
    from [lh_bronze].[qbi_incremental].[personasbi_pr] as src
    inner join latest_cutoff as cut
        on src._snapshot_date = cut.max_snapshot_date
       and src._ingestion_tst = cut.max_ingestion_tst
),

con_rn as (
    select *,
        row_number() over (
            partition by identificador
            order by _ingestion_tst desc
        ) as rn
    from source_data
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
        
    nullif(ltrim(rtrim(cast(identificador as varchar(255)))), '')
 as id_persona,
        
    nullif(ltrim(rtrim(cast(nombre as varchar(255)))), '')
 as nom_persona,
        
    nullif(ltrim(rtrim(cast(email as varchar(255)))), '')
 as eml_persona,
        case
            when charindex('@', 
    nullif(ltrim(rtrim(cast(email as varchar(255)))), '')
) > 0
            then lower(left(
            
    nullif(ltrim(rtrim(cast(email as varchar(255)))), '')
,
            charindex('@', 
    nullif(ltrim(rtrim(cast(email as varchar(255)))), '')
) - 1
            ))
        end as alias,
        try_cast(fecha_alta as date) as fec_alta,
        try_cast(fecha_baja as date) as fec_baja,
        try_cast(empresa as int) as id_empresa,
        
    nullif(ltrim(rtrim(cast(asesor as varchar(255)))), '')
 as id_asesor,
        
    nullif(ltrim(rtrim(cast(operario as varchar(255)))), '')
 as id_operario,
        
    nullif(ltrim(rtrim(cast(vendedor_comercial as varchar(255)))), '')
 as id_vendedor_comercial,
        
    nullif(ltrim(rtrim(cast(vendedor_almacen as varchar(255)))), '')
 as id_vendedor_almacen,
        
    nullif(ltrim(rtrim(cast(cajero as varchar(255)))), '')
 as id_cajero,
        
    nullif(ltrim(rtrim(cast(usuario as varchar(255)))), '')
 as id_usuario,
        
    nullif(ltrim(rtrim(cast(departamento as varchar(255)))), '')
 as cat_departamento,
        
    nullif(ltrim(rtrim(cast(des_departamento as varchar(255)))), '')
 as des_departamento,
        
    nullif(ltrim(rtrim(cast(telefono as varchar(255)))), '')
 as tel_telefono,
        
    nullif(ltrim(rtrim(cast(grupo as varchar(255)))), '')
 as cat_grupo,
        
    nullif(ltrim(rtrim(cast(desc_grupo as varchar(255)))), '')
 as des_grupo,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 11:30:52' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select