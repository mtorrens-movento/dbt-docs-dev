

with source_data as (
    select *
    
        from [lh_bronze].[qbi_incremental].[ftsobi_pr]
        where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[pasos_taller_cerrados])
          and  _ingestion_tst > (select max(aud_tst_ingestion) from [wh_silver].[stg_qbi].[pasos_taller_cerrados])
    
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
 as id_orden_reparacion,
    
    CASE
        WHEN referencia IS NULL THEN NULL
        WHEN CHARINDEX('-', referencia) > 0
            -- Obtener valores ala derecha del guion
            THEN try_cast(SUBSTRING(referencia, CHARINDEX('-', referencia) + 1, LEN(referencia)) as int)
        -- Obtener último carácter de referencia original
        ELSE try_cast(RIGHT(referencia, 1) as int)
    END
 as id_cargo
,
        
    nullif(ltrim(rtrim(cast(refx as varchar(255)))), '')
 as id_fila_tecnica,
        try_cast(fecha_apertura as date) as fec_apertura_or,
        try_cast(fecha_cierre as date) as fec_cierre_or,
        
    nullif(ltrim(rtrim(cast(num_factura as varchar(255)))), '')
 as num_factura,
        
    nullif(ltrim(rtrim(cast(idv as varchar(255)))), '')
 as id_vehiculo,
        
    nullif(ltrim(rtrim(cast(cta_cargo as varchar(255)))), '')
 as id_cuenta_cargo,
        
    nullif(ltrim(rtrim(cast(tipo_cta_cargo as varchar(255)))), '')
 as tpo_cuenta_cargo,
        
    nullif(ltrim(rtrim(cast(des_tipo_cta_cargo as varchar(255)))), '')
 as des_tipo_cuenta_cargo,
        
    nullif(ltrim(rtrim(cast(taller as varchar(255)))), '')
 as id_taller,
        
    nullif(ltrim(rtrim(cast(nom_taller as varchar(255)))), '')
 as nom_taller,
        
    nullif(ltrim(rtrim(cast(tipo_or as varchar(255)))), '')
 as tpo_or,
        
    nullif(ltrim(rtrim(cast(des_tipo_or as varchar(255)))), '')
 as des_tipo_or,
        try_cast(imp_total_mo as decimal(18, 2)) as imp_total_mano_obra,
        try_cast(imp_total_rec as decimal(18, 2)) as imp_total_materiales,
        try_cast(imp_total_iva as decimal(18, 2)) as imp_total_iva,
        try_cast(tpo_total_invertido as decimal(18, 2)) as ud_tiempo_invertido,
        try_cast(tpo_total_facturado as decimal(18, 2)) as ud_tiempo_facturado,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        
    nullif(ltrim(rtrim(cast(recepcionista as varchar(255)))), '')
 as id_recepcionista,
        
    nullif(ltrim(rtrim(cast(nom_recepcionista as varchar(255)))), '')
 as nom_recepcionista,
        try_cast(kms as decimal(18, 2)) as ud_km_or,
        
    nullif(ltrim(rtrim(cast(ref_abono as varchar(255)))), '')
 as id_orden_abonada,
        try_cast(fecha_primer_bono as date) as fec_primer_fichaje,
        
    nullif(ltrim(rtrim(cast(hora_primer_bono as varchar(255)))), '')
 as hora_primer_fichaje,
        try_cast(fecha_ultimo_bono as date) as fec_ultimo_fichaje,
        
    nullif(ltrim(rtrim(cast(hora_ultimo_bono as varchar(255)))), '')
 as hora_ultimo_fichaje,
        
    nullif(ltrim(rtrim(cast(comentarios as varchar(255)))), '')
 as des_comentarios_or,
        
    nullif(ltrim(rtrim(cast(tipo_facturacion as varchar(255)))), '')
 as tpo_facturacion,
        
    nullif(ltrim(rtrim(cast(des_tipo_facturacion as varchar(255)))), '')
 as des_tipo_facturacion,
        try_cast(rowcont as int) as seq_linea_or,
        try_cast(operacion as int) as num_operacion,
        
    nullif(ltrim(rtrim(cast(tipo_mo as varchar(255)))), '')
 as tpo_mano_obra,
        
    nullif(ltrim(rtrim(cast(des_tipo_mo as varchar(255)))), '')
 as des_tipo_mano_obra,
        
    nullif(ltrim(rtrim(cast(cod_mo as varchar(255)))), '')
 as id_mano_obra,
        
    nullif(ltrim(rtrim(cast(des_cod_mo as varchar(255)))), '')
 as des_mano_obra,
        try_cast(tiempo as decimal(18, 2)) as ud_tiempo_facturar,
        try_cast(precio_hora as decimal(18, 2)) as imp_precio_hora,
        try_cast(imp_subtotal_linea as decimal(18, 2)) as imp_subtotal_linea,
        try_cast(imp_dto_linea as decimal(18, 2)) as imp_descuento_linea,
        try_cast(imp_total_linea as decimal(18, 2)) as imp_total_linea,
        
    nullif(ltrim(rtrim(cast(operario as varchar(255)))), '')
 as id_operario,
        
    nullif(ltrim(rtrim(cast(nom_operario as varchar(255)))), '')
 as nom_operario,
        try_cast(imp_costo_linea as decimal(18, 2)) as imp_costo_linea,
        try_cast(imp_costo_manual_linea as decimal(18, 2)) as imp_costo_manual_linea,
        try_cast(por_dto_deferencia as decimal(18, 6)) as rat_descuento_deferencia,
        
    nullif(ltrim(rtrim(cast(tipo_registro as varchar(255)))), '')
 as tpo_registro_mano_obra,
        
    nullif(ltrim(rtrim(cast(des_tipo_registro as varchar(255)))), '')
 as des_tipo_registro_mano_obra,
        
    nullif(ltrim(rtrim(cast(codigo_kit as varchar(255)))), '')
 as id_kit,
        try_cast(fecha_terminacion as date) as fec_terminacion_or,
        try_cast(fecha_entrega as date) as fec_entrega_vehiculo,
        
    nullif(ltrim(rtrim(cast(forma_pago as varchar(255)))), '')
 as tpo_forma_pago,
        
    nullif(ltrim(rtrim(cast(des_forma_pago as varchar(255)))), '')
 as des_forma_pago,
        try_cast(recepcion_activa as bit) as ref_ind_recepcion_activa,
        try_cast(averia_repetitiva as bit) as ref_ind_averia_repetitiva,
        try_cast(servicio_elevador as bit) as ref_ind_servicio_elevador,
        try_cast(marca_or as int) as cod_marca,
        
    nullif(ltrim(rtrim(cast(des_marca_or as varchar(255)))), '')
 as des_marca,
        
    nullif(ltrim(rtrim(cast(des_averia as varchar(255)))), '')
 as des_averia,
        
    nullif(ltrim(rtrim(cast(persona_contacto as varchar(255)))), '')
 as nom_persona_contacto,
        
    nullif(ltrim(rtrim(cast(tel_contacto as varchar(255)))), '')
 as tel_contacto,
        
    nullif(ltrim(rtrim(cast(tel_contacto_alternativo as varchar(255)))), '')
 as tel_contacto_alternativo,
        -- El origen serializa la hora como 'HH:MM:SS+01'. El desplazamiento es
        -- constante en los 2,1 millones de filas, asi que recortarlo no pierde
        -- informacion, y sin recortar el cast devuelve null porque time no admite
        -- desplazamiento. Si algun dia el origen emitiera +02 en verano, esto lo
        -- tragaria sin avisar y mezclaria dos zonas horarias.
        try_cast(left(hora_apertura, 8) as time(0)) as hora_apertura_or,
        
    nullif(ltrim(rtrim(cast(localizacion_veh as varchar(255)))), '')
 as id_localizacion_vehiculo,
        
    nullif(ltrim(rtrim(cast(des_localizacion_veh as varchar(255)))), '')
 as des_localizacion_vehiculo,
        
    nullif(ltrim(rtrim(cast(estado as varchar(255)))), '')
 as cat_estado_or,
        
    nullif(ltrim(rtrim(cast(des_estado as varchar(255)))), '')
 as des_estado_or,
        
    nullif(ltrim(rtrim(cast(reparto as varchar(255)))), '')
 as ref_ind_reparto_mano_obra,
        try_cast(tiempo_tarifa as decimal(18, 2)) as ud_tiempo_tarifa,
        
    nullif(ltrim(rtrim(cast(hora_entrega as varchar(255)))), '')
 as hora_entrega_vehiculo,
        try_cast(fecha_entrega_prevista as date) as fec_entrega_prevista,
        
    nullif(ltrim(rtrim(cast(hora_entrega_prevista as varchar(255)))), '')
 as hora_entrega_prevista,
        
    nullif(ltrim(rtrim(cast(perito as varchar(255)))), '')
 as nom_perito,
        
    nullif(ltrim(rtrim(cast(nro_siniestro as varchar(255)))), '')
 as num_siniestro,
        
    nullif(ltrim(rtrim(cast(nro_orsec as varchar(255)))), '')
 as num_orsec,
        
    nullif(ltrim(rtrim(cast(es_garantia as varchar(255)))), '')
 as ref_ind_garantia,
        
    nullif(ltrim(rtrim(cast(es_interna as varchar(255)))), '')
 as ref_ind_or_interna,
        
    nullif(ltrim(rtrim(cast(es_presupuesto as varchar(255)))), '')
 as ref_ind_presupuesto,
        
    nullif(ltrim(rtrim(cast(es_servicio_rapido as varchar(255)))), '')
 as ref_ind_servicio_rapido,
        
    nullif(ltrim(rtrim(cast(codigo_informe as varchar(255)))), '')
 as cat_informe,
        
    nullif(ltrim(rtrim(cast(estado_vehiculo as varchar(255)))), '')
 as des_estado_vehiculo,
        try_cast(fecha_inicio_reparacion as date) as fec_inicio_reparacion,
        try_cast(fecha_diagnostico as date) as fec_diagnostico,
        try_cast(fecha_entrada_apertura as date) as fec_entrada_taller,
        
    nullif(ltrim(rtrim(cast(comentarios_internos as varchar(255)))), '')
 as des_comentarios_internos,
        
    nullif(ltrim(rtrim(cast(lugar_entrega as varchar(255)))), '')
 as des_lugar_entrega,
        try_cast(cuestionario as bit) as ref_ind_cuestionario_calidad,
        
    nullif(ltrim(rtrim(cast(motivo_entrada as varchar(255)))), '')
 as cat_motivo_entrada,
        
    nullif(ltrim(rtrim(cast(des_motivo_entrada as varchar(255)))), '')
 as des_motivo_entrada,
        
    nullif(ltrim(rtrim(cast(cta_titular as varchar(255)))), '')
 as id_cuenta_titular,
        try_cast(left(hora_cierre, 8) as time(0)) as hora_cierre_or,
        try_cast(tiempo_or as decimal(18, 2)) as ud_tiempo_or,
        
    nullif(ltrim(rtrim(cast(usuario_qis as varchar(255)))), '')
 as usr_qis,
        
    nullif(ltrim(rtrim(cast(cod_responsable as varchar(255)))), '')
 as id_responsable_or,
        
    nullif(ltrim(rtrim(cast(nom_responsable as varchar(255)))), '')
 as nom_responsable_or,
        try_cast(tiempo_otros as decimal(18, 2)) as ud_tiempo_otros,
        
    nullif(ltrim(rtrim(cast(tipo_averia as varchar(255)))), '')
 as tpo_averia,
        
    nullif(ltrim(rtrim(cast(des_tipo_averia as varchar(255)))), '')
 as des_tipo_averia,
        
    nullif(ltrim(rtrim(cast(nro_siniestro_face as varchar(255)))), '')
 as num_siniestro_face,
        
    nullif(ltrim(rtrim(cast(perito_face as varchar(255)))), '')
 as nom_perito_face,
        
    nullif(ltrim(rtrim(cast(nro_aut_face as varchar(255)))), '')
 as num_autorizacion_face,
        
    nullif(ltrim(rtrim(cast(cod_imputacion as varchar(255)))), '')
 as cat_imputacion,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-24 08:05:02' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select