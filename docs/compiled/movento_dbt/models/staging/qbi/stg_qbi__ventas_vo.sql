

with source_data as (
    select *
    
        from [lh_bronze].[qbi_incremental].[ftavobi_pr]
        where _snapshot_date >= (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[ventas_vo])
          and _ingestion_tst > (select max(aud_tst_ingestion) from [wh_silver].[stg_qbi].[ventas_vo])
    
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
        try_cast(referencia as int) as id_referencia,
        try_cast(fecha as datetime2(0)) as fec_venta,
        
    nullif(ltrim(rtrim(cast(concesionario as varchar(255)))), '')
 as id_concesionario,
        
    nullif(ltrim(rtrim(cast(nom_concesionario as varchar(255)))), '')
 as nom_concesionario,
        
    nullif(ltrim(rtrim(cast(tipo_venta as varchar(255)))), '')
 as tpo_venta,
        
    nullif(ltrim(rtrim(cast(des_tipo_venta as varchar(255)))), '')
 as des_tipo_venta,
        
    nullif(ltrim(rtrim(cast(origen as varchar(255)))), '')
 as cat_origen,
        
    nullif(ltrim(rtrim(cast(des_origen as varchar(255)))), '')
 as des_origen,
        
    nullif(ltrim(rtrim(cast(vendedor as varchar(255)))), '')
 as id_vendedor,
        
    nullif(ltrim(rtrim(cast(nom_vendedor as varchar(255)))), '')
 as nom_vendedor,
        
    nullif(ltrim(rtrim(cast(delegacion_ven as varchar(255)))), '')
 as id_delegacion_venta,
        
    nullif(ltrim(rtrim(cast(des_delegacion_ven as varchar(255)))), '')
 as des_delegacion_venta,
        
    nullif(ltrim(rtrim(cast(idv as varchar(255)))), '')
 as id_vehiculo,
        
    nullif(ltrim(rtrim(cast(tipo_vo as varchar(255)))), '')
 as tpo_vo,
        
    nullif(ltrim(rtrim(cast(des_tipo_vo as varchar(255)))), '')
 as des_tipo_vo,
        try_cast(km_mov as decimal(18, 2)) as ud_km_movimiento,
        try_cast(fec_recepcion as datetime2(0)) as fec_recepcion,
        try_cast(fec_rac as datetime2(0)) as fec_rac,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        
    nullif(ltrim(rtrim(cast(cta_cliente as varchar(255)))), '')
 as id_cuenta_cliente,
        
    nullif(ltrim(rtrim(cast(ref_abono as varchar(255)))), '')
 as id_referencia_abono,
        try_cast(imp_venta_vo as decimal(18, 2)) as imp_venta_vo,
        try_cast(imp_venta_taller as decimal(18, 2)) as imp_venta_taller,
        try_cast(imp_venta_matric as decimal(18, 2)) as imp_venta_matriculacion,
        try_cast(imp_costo_vo as decimal(18, 2)) as imp_costo_vo,
        try_cast(imp_costo_taller as decimal(18, 2)) as imp_costo_taller,
        try_cast(imp_costo_gestoria as decimal(18, 2)) as imp_costo_gestoria,
        try_cast(imp_reacon as decimal(18, 2)) as imp_reacondicionamiento,
        try_cast(imp_ingresos as decimal(18, 2)) as imp_ingresos,
        try_cast(imp_gastos as decimal(18, 2)) as imp_gastos,
        try_cast(imp_varios as decimal(18, 2)) as imp_varios,
        try_cast(imp_regalos as decimal(18, 2)) as imp_regalos,
        try_cast(imp_beneficio as decimal(18, 2)) as imp_beneficio,
        try_cast(imp_beneficio_vo as decimal(18, 2)) as imp_beneficio_vo,
        try_cast(por_depreciacion as decimal(18, 6)) as rat_depreciacion,
        try_cast(imp_depreciacion as decimal(18, 2)) as imp_depreciacion,
        try_cast(imp_reacon_previsto as decimal(18, 2)) as imp_reacondicionamiento_previsto,
        
    nullif(ltrim(rtrim(cast(vendedor_compra as varchar(255)))), '')
 as id_vendedor_compra,
        
    nullif(ltrim(rtrim(cast(nom_vendedor_compra as varchar(255)))), '')
 as nom_vendedor_compra,
        try_cast(imp_com_vendedor as decimal(18, 2)) as imp_comision_vendedor,
        try_cast(imp_com_agente as decimal(18, 2)) as imp_comision_agente,
        try_cast(imp_beneficio_gestion as decimal(18, 2)) as imp_beneficio_gestion,
        try_cast(imp_ingresos_varios as decimal(18, 2)) as imp_ingresos_varios,
        try_cast(imp_comision as decimal(18, 2)) as imp_comision,
        try_cast(imp_rec_fabrica as decimal(18, 2)) as imp_recuperacion_fabrica,
        
    nullif(ltrim(rtrim(cast(concesionario_venta as varchar(255)))), '')
 as id_concesionario_venta,
        
    nullif(ltrim(rtrim(cast(nom_concesionario_venta as varchar(255)))), '')
 as nom_concesionario_venta,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-10-09 11:20:57' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select