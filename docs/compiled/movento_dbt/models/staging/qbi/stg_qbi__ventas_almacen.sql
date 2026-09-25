

with source_data as (
    select *
    
        from [lh_bronze].[qbi_incremental].[ftsabi_pr]
        where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[ventas_almacen])
          and  _ingestion_tst > (select max(aud_tst_ingestion) from [wh_silver].[stg_qbi].[ventas_almacen])
    

),

con_rn as (
    select *,
        row_number() over (
            partition by 
    -- Obtener referencia a 7 digitos o limpiar migradas de otros sistemas (con guión)
    -- El identificador NO es numerico: 116.664 referencias del ultimo snapshot
    -- empiezan por letras (GG5257301...), de ordenes migradas. Castearlo a int las
    -- anula, y como la deduplicacion reparte por esta columna, colapsan entre si:
    -- se perdian 116.208 lineas de OR sin que saltara ningun error. El id_cargo si
    -- es numerico (cero no convertibles en 2.094.570) y ese cast se mantiene.
    CASE
        WHEN referencia IS NULL THEN NULL
        WHEN CHARINDEX('-', referencia) > 0
            THEN LEFT(referencia, CHARINDEX('-', referencia) - 1)
        WHEN LEN(referencia) > 0
            THEN LEFT(referencia, LEN(referencia) - 1)
        ELSE referencia
    END
, 
    CASE
        WHEN referencia IS NULL THEN NULL
        WHEN CHARINDEX('-', referencia) > 0
            -- Obtener valores ala derecha del guion
            THEN try_cast(SUBSTRING(referencia, CHARINDEX('-', referencia) + 1, LEN(referencia)) as int)
        -- Obtener último carácter de referencia original
        ELSE try_cast(RIGHT(referencia, 1) as int)
    END
, rowcont
            order by _ingestion_tst desc
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
 as id_orden_venta,
        
    nullif(ltrim(rtrim(cast(salt as varchar(255)))), '')
 as ref_ind_salida_taller,
        try_cast(fecha as date) as fec_movimiento,
        
    nullif(ltrim(rtrim(cast(num_factura as varchar(255)))), '')
 as num_factura,
        
    nullif(ltrim(rtrim(cast(cliente as varchar(255)))), '')
 as id_cliente,
        
    nullif(ltrim(rtrim(cast(tipo_cliente as varchar(255)))), '')
 as tpo_cliente,
        
    nullif(ltrim(rtrim(cast(des_tipo_cliente as varchar(255)))), '')
 as des_tipo_cliente,
        try_cast(codigo_envio as int) as id_cuenta_envio,
        
    nullif(ltrim(rtrim(cast(almacen as varchar(255)))), '')
 as id_almacen,
        
    nullif(ltrim(rtrim(cast(nom_almacen as varchar(255)))), '')
 as nom_almacen,
        
    nullif(ltrim(rtrim(cast(marca_almacen as varchar(255)))), '')
 as cod_marca_almacen,
        
    nullif(ltrim(rtrim(cast(des_marca_almacen as varchar(255)))), '')
 as des_marca_almacen,
        
    nullif(ltrim(rtrim(cast(tipo_venta as varchar(255)))), '')
 as tpo_venta,
        
    nullif(ltrim(rtrim(cast(des_tipo_venta as varchar(255)))), '')
 as des_tipo_venta,
        try_cast(imp_total_rec as decimal(18, 2)) as imp_total_base_imponible,
        try_cast(imp_total_iva as decimal(18, 2)) as imp_total_iva,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        
    nullif(ltrim(rtrim(cast(ref_abono as varchar(255)))), '')
 as id_venta_abonada,
        try_cast(rowcont as int) as seq_linea_venta,
        
    nullif(ltrim(rtrim(cast(articulo as varchar(255)))), '')
 as cat_articulo,
        
    nullif(ltrim(rtrim(cast(des_articulo as varchar(255)))), '')
 as des_articulo,
        
    nullif(ltrim(rtrim(cast(familia as varchar(255)))), '')
 as cat_familia_articulo_venta,
        
    nullif(ltrim(rtrim(cast(des_familia as varchar(255)))), '')
 as des_familia_articulo_venta,
        
    nullif(ltrim(rtrim(cast(fam_apro as varchar(255)))), '')
 as cat_familia_aprovisionamiento,
        
    nullif(ltrim(rtrim(cast(des_fam_apro as varchar(255)))), '')
 as des_familia_aprovisionamiento,
        
    nullif(ltrim(rtrim(cast(grupo as varchar(255)))), '')
 as cat_grupo_neumaticos,
        
    nullif(ltrim(rtrim(cast(des_grupo as varchar(255)))), '')
 as des_grupo_neumaticos,
        try_cast(marca_contable as int) as id_marca_contable,
        
    nullif(ltrim(rtrim(cast(des_marca_contable as varchar(255)))), '')
 as des_marca_contable,
        
    nullif(ltrim(rtrim(cast(indice as varchar(255)))), '')
 as cat_indice_articulo,
        
    nullif(ltrim(rtrim(cast(des_indice as varchar(255)))), '')
 as des_indice_articulo,
        
    nullif(ltrim(rtrim(cast(segmento as varchar(255)))), '')
 as cat_segmento_articulo,
        
    nullif(ltrim(rtrim(cast(des_segmento as varchar(255)))), '')
 as des_segmento_articulo,
        try_cast(cantidad as decimal(18, 2)) as ud_unidades_venta,
        try_cast(cantidad_real as decimal(18, 2)) as ud_unidades_salida_real,
        try_cast(pvp as decimal(18, 2)) as imp_pvp_unitario,
        try_cast(imp_subtotal_linea as decimal(18, 2)) as imp_subtotal_linea,
        try_cast(imp_dto_linea as decimal(18, 2)) as imp_descuento_linea,
        try_cast(imp_total_linea as decimal(18, 2)) as imp_total_linea,
        try_cast(imp_costo_linea as decimal(18, 2)) as imp_costo_linea,
        
    nullif(ltrim(rtrim(cast(almacen_lin as varchar(255)))), '')
 as id_almacen_linea,
        
    nullif(ltrim(rtrim(cast(nom_almacen_lin as varchar(255)))), '')
 as nom_almacen_linea,
        
    nullif(ltrim(rtrim(cast(vendedor as varchar(255)))), '')
 as id_vendedor,
        
    nullif(ltrim(rtrim(cast(nom_vendedor as varchar(255)))), '')
 as nom_vendedor,
        try_cast(fecha_salida as date) as fec_salida_pieza,
        
    nullif(ltrim(rtrim(cast(ref_pedido_cliente as varchar(255)))), '')
 as id_pedido_cliente_origen,
        try_cast(can_pedido_cliente as decimal(18, 2)) as ud_pedido_cliente_origen,
        try_cast(por_dto_deferencia as decimal(18, 6)) as rat_descuento_deferencia,
        try_cast(por_inc_gastos_gestion as decimal(18, 6)) as rat_incremento_gastos_gestion,
        
    nullif(ltrim(rtrim(cast(codigo_kit as varchar(255)))), '')
 as id_kit,
        
    nullif(ltrim(rtrim(cast(ruta as varchar(255)))), '')
 as cat_ruta,
        
    nullif(ltrim(rtrim(cast(des_ruta as varchar(255)))), '')
 as des_ruta,
        try_cast(fecha_envio_ruta as date) as fec_envio_ruta,
        
    nullif(ltrim(rtrim(cast(exp_grua as varchar(255)))), '')
 as id_expediente_grua,
        
    nullif(ltrim(rtrim(cast(texto as varchar(255)))), '')
 as des_texto_albaran,
        
    nullif(ltrim(rtrim(cast(tipo_cliente_venta as varchar(255)))), '')
 as tpo_cliente_venta,
        
    nullif(ltrim(rtrim(cast(des_tipo_cliente_venta as varchar(255)))), '')
 as des_tipo_cliente_venta,
        try_cast(ref_facturacion as int) as id_facturacion_resumen,
        
    nullif(ltrim(rtrim(cast(reparto as varchar(255)))), '')
 as ref_ind_reparto_material,
        
    nullif(ltrim(rtrim(cast(almacen_destino as varchar(255)))), '')
 as id_almacen_destino,
        
    nullif(ltrim(rtrim(cast(nom_almacen_destino as varchar(255)))), '')
 as nom_almacen_destino,
        try_cast(fecha_apertura as date) as fec_apertura_or,
        
    nullif(ltrim(rtrim(cast(familiam as varchar(255)))), '')
 as cat_familia_articulo_maestro,
        
    nullif(ltrim(rtrim(cast(des_familiam as varchar(255)))), '')
 as des_familia_articulo_maestro,
        
    nullif(ltrim(rtrim(cast(grupom as varchar(255)))), '')
 as cat_grupo_articulo_maestro,
        
    nullif(ltrim(rtrim(cast(des_grupom as varchar(255)))), '')
 as des_grupo_articulo_maestro,
        
    nullif(ltrim(rtrim(cast(fam_marketing as varchar(255)))), '')
 as cat_familia_marketing,
        
    nullif(ltrim(rtrim(cast(des_fam_marketing as varchar(255)))), '')
 as des_familia_marketing,
        
    nullif(ltrim(rtrim(cast(grupo_mli as varchar(255)))), '')
 as cat_grupo_mli,
        
    nullif(ltrim(rtrim(cast(des_grupo_mli as varchar(255)))), '')
 as des_grupo_mli,
        
    nullif(ltrim(rtrim(cast(procedencia as varchar(255)))), '')
 as cat_procedencia_articulo,
        
    nullif(ltrim(rtrim(cast(cliente_envio_directo as varchar(255)))), '')
 as id_cliente_envio_directo,
        
    nullif(ltrim(rtrim(cast(codigo_envio_directo as varchar(255)))), '')
 as id_cuenta_envio_directo,
        
    nullif(ltrim(rtrim(cast(forma_pago as varchar(255)))), '')
 as tpo_forma_pago,
        
    nullif(ltrim(rtrim(cast(des_forma_pago as varchar(255)))), '')
 as des_forma_pago,
        
    nullif(ltrim(rtrim(cast(cuenta_cargo as varchar(255)))), '')
 as id_cuenta_cargo,
        
    nullif(ltrim(rtrim(cast(sector_actividad as varchar(255)))), '')
 as cat_sector_actividad,
        
    nullif(ltrim(rtrim(cast(clave_descuento as varchar(255)))), '')
 as cat_clave_descuento,
        try_cast(operacion as int) as num_operacion,
        
    nullif(ltrim(rtrim(cast(vendedor_reserva as varchar(255)))), '')
 as id_vendedor_reserva,
        
    nullif(ltrim(rtrim(cast(nom_vendedor_reserva as varchar(255)))), '')
 as nom_vendedor_reserva,
        
    nullif(ltrim(rtrim(cast(numero_pedido as varchar(255)))), '')
 as num_pedido_cliente,
        
    nullif(ltrim(rtrim(cast(familia_art as varchar(255)))), '')
 as cat_familia_articulo,
        
    nullif(ltrim(rtrim(cast(des_familia_art as varchar(255)))), '')
 as des_familia_articulo,
        
    nullif(ltrim(rtrim(cast(motivo_devolucion as varchar(255)))), '')
 as cat_motivo_devolucion,
        
    nullif(ltrim(rtrim(cast(des_motivo_devolucion as varchar(255)))), '')
 as des_motivo_devolucion,
        
    nullif(ltrim(rtrim(cast(operario as varchar(255)))), '')
 as id_operario,
        
    nullif(ltrim(rtrim(cast(nom_operario as varchar(255)))), '')
 as nom_operario,
        try_cast(por_descuento as decimal(18, 6)) as rat_descuento_articulo,
        
    nullif(ltrim(rtrim(cast(des_manual as varchar(255)))), '')
 as des_manual_pieza,
        
    nullif(ltrim(rtrim(cast(origen as varchar(255)))), '')
 as cat_origen,
        
    nullif(ltrim(rtrim(cast(des_origen as varchar(255)))), '')
 as des_origen,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 12:49:51' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select