

with source_data as (
    select *
    
        from [lh_bronze].[qbi_incremental].[ftasbi_pr]
        where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[cuentas_contables])
            and  _ingestion_tst > (select max(aud_tst_ingestion) from [wh_silver].[stg_qbi].[cuentas_contables])
    
),

con_rn as (
    select
        *,
        row_number() over (
            partition by refx
            order by _ingestion_tst desc
        ) as rn
    from source_data
    where refx is not null
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
        
    nullif(ltrim(rtrim(cast(referencia as varchar(255)))), '')
 as id_referencia,
        try_cast(fecha as datetime2(0)) as fec_movimiento_contable,
        try_cast(cuentam as int) as id_cuenta_mayor,
        try_cast(cuentap as int) as id_cuenta_apunte,
        try_cast(imp_debe as decimal(18, 2)) as imp_debe,
        try_cast(imp_haber as decimal(18, 2)) as imp_haber,
        
    nullif(ltrim(rtrim(cast(diario as varchar(255)))), '')
 as id_diario,
        
    nullif(ltrim(rtrim(cast(des_diario as varchar(255)))), '')
 as des_diario,
        try_cast(empresa as int) as id_empresa,
        
    nullif(ltrim(rtrim(cast(nom_empresa as varchar(255)))), '')
 as nom_empresa,
        
    nullif(ltrim(rtrim(cast(concepto as varchar(255)))), '')
 as id_concepto,
        
    nullif(ltrim(rtrim(cast(des_concepto as varchar(255)))), '')
 as des_concepto,
        
    nullif(ltrim(rtrim(cast(ampliacion_concepto as varchar(255)))), '')
 as des_ampliacion_concepto,
        try_cast(nro_total_lineas as decimal(18, 0)) as num_total_lineas_asiento,
        try_cast(nro_linea as int) as seq_linea_asiento,
        
    nullif(ltrim(rtrim(cast(ref_asiento as varchar(255)))), '')
 as id_asiento,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        
    nullif(ltrim(rtrim(cast(cierre_apertura as varchar(255)))), '')
 as ind_cierre_apertura,
        try_cast(nro_documento as int) as id_documento,
        
    nullif(ltrim(rtrim(cast(usuario_creacion as varchar(255)))), '')
 as id_usuario_creacion,
        try_cast(fecha_creacion as datetime2(0)) as fec_creacion,
        
    nullif(ltrim(rtrim(cast(hora_creacion as varchar(255)))), '')
 as hora_creacion,
        
    nullif(ltrim(rtrim(cast(punteado as varchar(255)))), '')
 as ind_punteado,
        
    nullif(ltrim(rtrim(cast(ref_completa as varchar(255)))), '')
 as id_referencia_completa,
        
    nullif(ltrim(rtrim(cast(doc_concil as varchar(255)))), '')
 as id_documento_conciliacion,
        
    nullif(ltrim(rtrim(cast(clave_analitica as varchar(255)))), '')
 as id_clave_analitica,
        try_cast(_snapshot_tst as datetime2(0)) as aud_tst_snapshot,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-10-05 12:25:11' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select