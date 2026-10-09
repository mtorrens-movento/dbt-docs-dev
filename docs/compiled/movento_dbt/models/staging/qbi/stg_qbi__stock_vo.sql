

with source_data as (
    select
        src.*,
        cast(1 as int) as src_priority
    
    from [lh_bronze].[qbi_incremental].[ftsvembi2_pr] as src
    where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_vo])
       or (
            _snapshot_date = (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_vo])
        and _ingestion_tst > (
            select max(aud_tst_ingestion)
            from [wh_silver].[stg_qbi].[stock_vo]
            where aud_dte_snapshot = (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_vo])
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
        try_cast(imp_reacon as decimal(18, 2)) as imp_reacondicionamiento,
        try_cast(imp_reacon_previsto as decimal(18, 2)) as imp_reacondicionamiento_previsto,
        try_cast(imp_gravamenes as decimal(18, 2)) as imp_gravamenes,
        try_cast(imp_rectificacion as decimal(18, 2)) as imp_rectificacion,
        try_cast(p_venta as decimal(18, 2)) as imp_precio_venta,
        try_cast(p_compraventa as decimal(18, 2)) as imp_precio_compraventa,
        try_cast(p_exportacion as decimal(18, 2)) as imp_precio_exportacion,
        try_cast(p_publicacion as decimal(18, 2)) as imp_precio_publicacion,
        try_cast(imp_depreciacion as decimal(18, 2)) as imp_depreciacion,
        try_cast(porc_depreciacion as decimal(18, 6)) as rat_depreciacion,
        try_cast(dias_depreciacion as int) as ud_dias_depreciacion,
        try_cast(valor_residual as decimal(18, 2)) as imp_valor_residual,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        try_cast(periodo as decimal(18, 2)) as num_periodo,
        
    nullif(ltrim(rtrim(cast(estado as varchar(255)))), '')
 as cat_estado,
        
    nullif(ltrim(rtrim(cast(desc_estado as varchar(255)))), '')
 as des_estado,
        
    nullif(ltrim(rtrim(cast(categoria as varchar(255)))), '')
 as cat_categoria,
        
    nullif(ltrim(rtrim(cast(des_categoria as varchar(255)))), '')
 as des_categoria,
        
    nullif(ltrim(rtrim(cast(tipo_vo as varchar(255)))), '')
 as tpo_vo,
        
    nullif(ltrim(rtrim(cast(des_tipo_vo as varchar(255)))), '')
 as des_tipo_vo,
        
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
        try_cast(km as decimal(18, 2)) as ud_km,
        
    nullif(ltrim(rtrim(cast(vendedor as varchar(255)))), '')
 as id_vendedor,
        
    nullif(ltrim(rtrim(cast(nom_vendedor as varchar(255)))), '')
 as nom_vendedor,
        
    nullif(ltrim(rtrim(cast(en_stock as varchar(255)))), '')
 as ind_en_stock,
        
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
        try_cast(precio_venta_total as decimal(18, 2)) as imp_precio_venta_total,
        try_cast(precio_venta_publicado as decimal(18, 2)) as imp_precio_venta_publicado,
        try_cast(fec_entrada_real as datetime2(0)) as fec_entrada_real,
        try_cast(imp_iva_compra as decimal(18, 2)) as imp_iva_compra,
        try_cast(imp_vales_compra as decimal(18, 2)) as imp_vales_compra,
        try_cast(fec_valor_mercado as datetime2(0)) as fec_valor_mercado,
        try_cast(valor_mercado as decimal(18, 2)) as imp_valor_mercado,
        try_cast(valor_red as decimal(18, 2)) as imp_valor_red,
        try_cast(valor_particular as decimal(18, 2)) as imp_valor_particular,
        try_cast(valor_profesional as decimal(18, 2)) as imp_valor_profesional,
        
    nullif(ltrim(rtrim(cast(categoria_anterior as varchar(255)))), '')
 as cat_categoria_anterior,
        
    nullif(ltrim(rtrim(cast(des_categoria_anterior as varchar(255)))), '')
 as des_categoria_anterior,
        try_cast(meses_garantia as decimal(18, 2)) as ud_meses_garantia,
        try_cast(imp_referencia as decimal(18, 2)) as imp_referencia,
        try_cast(imp_nuevo as decimal(18, 2)) as imp_nuevo,
        
    nullif(ltrim(rtrim(cast(ref_mvto as varchar(255)))), '')
 as id_movimiento_referencia,
        
    nullif(ltrim(rtrim(cast(destino as varchar(255)))), '')
 as cat_destino,
        try_cast(fec_ult_pvtapar as datetime2(0)) as fec_ult_venta_particular,
        try_cast(fec_ult_pvtapro as datetime2(0)) as fec_ult_venta_profesional,
        try_cast(fec_ult_pvtaexp as datetime2(0)) as fec_ult_venta_exportacion,
        try_cast(fec_ult_pvtapub as datetime2(0)) as fec_ult_venta_publicada,
        try_cast(rotacion_veh as decimal(18, 2)) as ud_rotacion_vehiculo,
        
    nullif(ltrim(rtrim(cast(cta_banco as varchar(255)))), '')
 as id_cuenta_banco,
        
    nullif(ltrim(rtrim(cast(portales_web as varchar(255)))), '')
 as des_portales_web,
        try_cast(dias_garantia as decimal(18, 2)) as ud_dias_garantia,
        
    nullif(ltrim(rtrim(cast(des_destino as varchar(255)))), '')
 as des_destino,
        
    nullif(ltrim(rtrim(cast(cod_marca as varchar(255)))), '')
 as cod_marca,
        
    nullif(ltrim(rtrim(cast(cod_familia as varchar(255)))), '')
 as cod_familia,
        
    nullif(ltrim(rtrim(cast(des_familia as varchar(255)))), '')
 as des_familia,
        try_cast(_snapshot_tst as datetime2(0)) as aud_tst_snapshot,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-10-09 12:13:20' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select