

with source_data as (
    
    select *
    from [lh_bronze].[qbi_incremental].[ftcvobi_pr]
    where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[compras_vo])
      and _ingestion_tst > (select max(aud_tst_ingestion) from [wh_silver].[stg_qbi].[compras_vo])
    
),

con_rn as (
    select
        *,
        row_number() over (
            partition by referencia
            order by _snapshot_date desc, _ingestion_tst desc
        ) as rn
    from source_data
    where referencia is not null
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
 as id_movimiento_compra,
        
    nullif(ltrim(rtrim(cast(idv as varchar(255)))), '')
 as id_vehiculo,
        try_cast(fecha as datetime2(0)) as fec_movimiento,
        
    nullif(ltrim(rtrim(cast(concesionario as varchar(255)))), '')
 as id_concesionario,
        
    nullif(ltrim(rtrim(cast(nom_concesionario as varchar(255)))), '')
 as nom_concesionario,
        
    nullif(ltrim(rtrim(cast(proveedor as varchar(255)))), '')
 as id_proveedor,
        
    nullif(ltrim(rtrim(cast(nom_proveedor as varchar(255)))), '')
 as nom_proveedor,
        
    nullif(ltrim(rtrim(cast(vendedor as varchar(255)))), '')
 as id_vendedor,
        
    nullif(ltrim(rtrim(cast(nom_vendedor as varchar(255)))), '')
 as nom_vendedor,
        
    nullif(ltrim(rtrim(cast(tipo_vendedor as varchar(255)))), '')
 as id_tipo_vendedor,
        
    nullif(ltrim(rtrim(cast(des_tipo_vendedor as varchar(255)))), '')
 as des_tipo_vendedor,
        
    nullif(ltrim(rtrim(cast(tipo_vo as varchar(255)))), '')
 as tpo_vo,
        
    nullif(ltrim(rtrim(cast(des_tipo_vo as varchar(255)))), '')
 as des_tipo_vo,
        try_cast(km_mov as decimal(18, 2)) as ud_km_movimiento,
        try_cast(dias_mov as int) as ud_dias_movimiento,
        
    nullif(ltrim(rtrim(cast(ubicacion as varchar(255)))), '')
 as id_ubicacion,
        
    nullif(ltrim(rtrim(cast(des_ubicacion as varchar(255)))), '')
 as des_ubicacion,
        
    nullif(ltrim(rtrim(cast(estado_mov as varchar(255)))), '')
 as id_estado_movimiento,
        
    nullif(ltrim(rtrim(cast(des_estado_mov as varchar(255)))), '')
 as des_estado_movimiento,
        
    nullif(ltrim(rtrim(cast(tipo_mov as varchar(255)))), '')
 as id_tipo_movimiento,
        
    nullif(ltrim(rtrim(cast(des_tipo_mov as varchar(255)))), '')
 as des_tipo_movimiento,
        try_cast(imp_compra as decimal(18, 2)) as imp_compra,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        
    nullif(ltrim(rtrim(cast(delegacion_vendedor as varchar(255)))), '')
 as id_delegacion_vendedor,
        
    nullif(ltrim(rtrim(cast(des_delegacion_vendedor as varchar(255)))), '')
 as des_delegacion_vendedor,
        
    nullif(ltrim(rtrim(cast(destino as varchar(255)))), '')
 as cat_destino,
        
    nullif(ltrim(rtrim(cast(des_destino as varchar(255)))), '')
 as des_destino,
        try_cast(fec_creacion as datetime2(0)) as fec_creacion,
        
    nullif(ltrim(rtrim(cast(hora_creacion as varchar(255)))), '')
 as hora_creacion,
        
    nullif(ltrim(rtrim(cast(ref_factura as varchar(255)))), '')
 as id_referencia_factura,
        try_cast(precio_referencia as decimal(18, 2)) as imp_precio_referencia,
        
    nullif(ltrim(rtrim(cast(cta_banco as varchar(255)))), '')
 as id_cuenta_banco,
        try_cast(imp_reacon as decimal(18, 2)) as imp_reacondicionamiento,
        try_cast(imp_vales_compra as decimal(18, 2)) as imp_vales_compra,
        
    nullif(ltrim(rtrim(cast(fra_rectif as varchar(255)))), '')
 as id_factura_rectificativa,
        try_cast(fec_fact_orig as datetime2(0)) as fec_factura_origen,
        
    nullif(ltrim(rtrim(cast(tipo_venta as varchar(255)))), '')
 as tpo_venta,
        
    nullif(ltrim(rtrim(cast(des_tipo_venta as varchar(255)))), '')
 as des_tipo_venta,
        
    nullif(ltrim(rtrim(cast(categoria_anterior as varchar(255)))), '')
 as cat_categoria_anterior,
        
    nullif(ltrim(rtrim(cast(des_categ_anterior as varchar(255)))), '')
 as des_categoria_anterior,
        try_cast(imp_garantia as decimal(18, 2)) as imp_garantia,
        try_cast(imp_trasferencia as decimal(18, 2)) as imp_transferencia,
        
    nullif(ltrim(rtrim(cast(cta_poliza as varchar(255)))), '')
 as id_cuenta_poliza,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-10-07 14:16:01' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select