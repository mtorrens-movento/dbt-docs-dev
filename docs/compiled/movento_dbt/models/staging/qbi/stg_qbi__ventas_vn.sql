

with source_data as (
    select *
    
        from [lh_bronze].[qbi_incremental].[ftavnbi_pr]
        where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[ventas_vn])
          and _ingestion_tst > (select max(aud_tst_ingestion) from [wh_silver].[stg_qbi].[ventas_vn])
    
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
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        
    nullif(ltrim(rtrim(cast(cta_cliente as varchar(255)))), '')
 as id_cuenta_cliente,
        
    nullif(ltrim(rtrim(cast(ref_abono as varchar(255)))), '')
 as id_referencia_abono,
        try_cast(imp_venta_vn as decimal(18, 2)) as imp_venta_vn,
        try_cast(imp_venta_taller as decimal(18, 2)) as imp_venta_taller,
        try_cast(imp_venta_matric as decimal(18, 2)) as imp_venta_matriculacion,
        try_cast(imp_descuento as decimal(18, 2)) as imp_descuento,
        try_cast(imp_beneficio as decimal(18, 2)) as imp_beneficio,
        try_cast(imp_beneficio_vn as decimal(18, 2)) as imp_beneficio_vn,
        try_cast(imp_fabrica as decimal(18, 2)) as imp_fabrica,
        try_cast(imp_fabrica_esp as decimal(18, 2)) as imp_fabrica_especifico,
        try_cast(imp_com_cobrar as decimal(18, 2)) as imp_comision_cobrar,
        try_cast(imp_otros_ing as decimal(18, 2)) as imp_otros_ingresos,
        try_cast(imp_costo_vn as decimal(18, 2)) as imp_costo_vn,
        try_cast(imp_gestoria as decimal(18, 2)) as imp_gestoria,
        try_cast(imp_costo_taller as decimal(18, 2)) as imp_costo_taller,
        try_cast(imp_com_agente as decimal(18, 2)) as imp_comision_agente,
        try_cast(imp_gastos as decimal(18, 2)) as imp_gastos,
        try_cast(imp_dto_obligatorio as decimal(18, 2)) as imp_descuento_obligatorio,
        try_cast(imp_dto_voluntario as decimal(18, 2)) as imp_descuento_voluntario,
        try_cast(imp_com_gestoria as decimal(18, 2)) as imp_comision_gestoria,
        try_cast(imp_accesorios as decimal(18, 2)) as imp_accesorios,
        try_cast(imp_com_vendedor as decimal(18, 2)) as imp_comision_vendedor,
        try_cast(imp_matriculacion as decimal(18, 2)) as imp_matriculacion,
        try_cast(imp_identifiat as decimal(18, 2)) as imp_identifiat,
        try_cast(imp_com_financiera as decimal(18, 2)) as imp_comision_financiera,
        try_cast(imp_franco_fabrica as decimal(18, 2)) as imp_franco_fabrica,
        try_cast(imp_opciones_venta as decimal(18, 2)) as imp_opciones_venta,
        try_cast(imp_transporte as decimal(18, 2)) as imp_transporte,
        try_cast(imp_regalo as decimal(18, 2)) as imp_regalo,
        try_cast(imp_varios as decimal(18, 2)) as imp_varios,
        
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
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-10-05 14:58:38' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select