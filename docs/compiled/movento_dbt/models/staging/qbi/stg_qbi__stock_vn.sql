

with source_data as (
    select
        src.*,
        cast(1 as int) as src_priority
    
    from [lh_bronze].[qbi_incremental].[ftsvembi_pr] as src
    where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_vn])
       or (
            _snapshot_date = (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_vn])
        and _ingestion_tst > (
            select max(aud_tst_ingestion)
            from [wh_silver].[stg_qbi].[stock_vn]
            where aud_dte_snapshot = (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_vn])
        )
       )
    
),

con_rn as (
    select
        *,
        row_number() over (
            partition by cast(fecha as date), idv
            order by _snapshot_date desc, _ingestion_tst desc, src_priority desc
        ) as rn
    from source_data
    where idv is not null
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
        try_cast(fecha as datetime2(0)) as fec_corte_stock,
        
    nullif(ltrim(rtrim(cast(idv as varchar(255)))), '')
 as id_vehiculo,
        
    nullif(ltrim(rtrim(cast(antiguedad as varchar(255)))), '')
 as cat_antiguedad,
        
    nullif(ltrim(rtrim(cast(concesionario as varchar(255)))), '')
 as id_concesionario,
        
    nullif(ltrim(rtrim(cast(nom_concesionario as varchar(255)))), '')
 as nom_concesionario,
        try_cast(fec_compra as datetime2(0)) as fec_compra,
        try_cast(imp_compra as decimal(18, 2)) as imp_compra,
        try_cast(imp_costo as decimal(18, 2)) as imp_costo,
        try_cast(p_venta as decimal(18, 2)) as imp_precio_venta,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        try_cast(periodo as decimal(18, 2)) as num_periodo,
        
    nullif(ltrim(rtrim(cast(estado as varchar(255)))), '')
 as cat_estado,
        
    nullif(ltrim(rtrim(cast(desc_estado as varchar(255)))), '')
 as des_estado,
        
    nullif(ltrim(rtrim(cast(en_stock as varchar(255)))), '')
 as ind_en_stock,
        
    nullif(ltrim(rtrim(cast(vendedor_reserva as varchar(255)))), '')
 as id_vendedor_reserva,
        
    nullif(ltrim(rtrim(cast(nom_vendedor_reserva as varchar(255)))), '')
 as nom_vendedor_reserva,
        
    nullif(ltrim(rtrim(cast(cliente_reserva as varchar(255)))), '')
 as id_cliente_reserva,
        
    nullif(ltrim(rtrim(cast(nom_cliente_reserva as varchar(255)))), '')
 as nom_cliente_reserva,
        try_cast(fec_reserva as datetime2(0)) as fec_reserva,
        try_cast(fec_recepcion as datetime2(0)) as fec_recepcion,
        
    nullif(ltrim(rtrim(cast(ubicacion as varchar(255)))), '')
 as id_ubicacion,
        
    nullif(ltrim(rtrim(cast(des_ubicacion as varchar(255)))), '')
 as des_ubicacion,
        
    nullif(ltrim(rtrim(cast(nro_opr as varchar(255)))), '')
 as num_operacion,
        try_cast(nro_puertas as decimal(18, 0)) as ud_puertas,
        
    nullif(ltrim(rtrim(cast(tipo_vehiculo as varchar(255)))), '')
 as tpo_vehiculo,
        
    nullif(ltrim(rtrim(cast(des_tipo_vehiculo as varchar(255)))), '')
 as des_tipo_vehiculo,
        
    nullif(ltrim(rtrim(cast(transmision as varchar(255)))), '')
 as tpo_transmision,
        
    nullif(ltrim(rtrim(cast(des_transmision as varchar(255)))), '')
 as des_transmision,
        
    nullif(ltrim(rtrim(cast(color as varchar(255)))), '')
 as cat_color,
        
    nullif(ltrim(rtrim(cast(des_color as varchar(255)))), '')
 as des_color,
        
    nullif(ltrim(rtrim(cast(tapiceria as varchar(255)))), '')
 as cat_tapiceria,
        
    nullif(ltrim(rtrim(cast(des_tapiceria as varchar(255)))), '')
 as des_tapiceria,
        try_cast(cilindrada as decimal(18, 2)) as cat_cilindrada,
        
    nullif(ltrim(rtrim(cast(tipo_motor as varchar(255)))), '')
 as id_motor,
        
    nullif(ltrim(rtrim(cast(des_tipo_motor as varchar(255)))), '')
 as des_tipo_motor,
        try_cast(potencia_cv as decimal(18, 2)) as ud_potencia_cv,
        try_cast(precio_venta as decimal(18, 2)) as imp_precio_venta_neto,
        try_cast(precio_venta_total as decimal(18, 2)) as imp_precio_venta_total,
        try_cast(precio_venta_publicado as decimal(18, 2)) as imp_precio_venta_publicado,
        try_cast(costo_transporte as decimal(18, 2)) as imp_costo_transporte,
        
    nullif(ltrim(rtrim(cast(tipo_pedido as varchar(255)))), '')
 as tpo_pedido,
        
    nullif(ltrim(rtrim(cast(des_tipo_pedido as varchar(255)))), '')
 as des_tipo_pedido,
        
    nullif(ltrim(rtrim(cast(cta_banco as varchar(255)))), '')
 as id_cuenta_banco,
        try_cast(precio_compra_total as decimal(18, 2)) as imp_precio_compra_total,
        try_cast(venta_transporte as decimal(18, 2)) as imp_venta_transporte,
        try_cast(fec_prevista_entrega as datetime2(0)) as fec_prevista_entrega,
        try_cast(imp_iva_compra as decimal(18, 2)) as imp_iva_compra,
        try_cast(imp_vales_compra as decimal(18, 2)) as imp_vales_compra,
        try_cast(fec_factura as datetime2(0)) as fec_factura,
        try_cast(fec_adjudicacion as datetime2(0)) as fec_adjudicacion,
        try_cast(fec_campa as datetime2(0)) as fec_campa,
        
    nullif(ltrim(rtrim(cast(cod_marca as varchar(255)))), '')
 as id_marca,
        try_cast(imp_reacond as decimal(18, 2)) as imp_reacondicionamiento,
        try_cast(imp_pp as decimal(18, 2)) as imp_pp,
        try_cast(imp_opciones as decimal(18, 2)) as imp_opciones,
        try_cast(_snapshot_tst as datetime2(0)) as aud_tst_snapshot,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-10-09 11:20:57' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select