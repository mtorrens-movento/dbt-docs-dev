

with source_data as (
    select *
    
        from [lh_bronze].[qbi_incremental].[fmvehbi_pr]
        where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[vehiculos])
          and  _ingestion_tst > (select max(aud_tst_ingestion) from [wh_silver].[stg_qbi].[vehiculos])
    
),

con_rn as (
    select *,
        row_number() over (
            partition by idv
            order by _ingestion_tst desc
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
        
    nullif(ltrim(rtrim(cast(idv as varchar(255)))), '')
 as id_vehiculo,
        
    nullif(ltrim(rtrim(cast(bastidor as varchar(255)))), '')
 as num_bastidor,
        
    nullif(ltrim(rtrim(cast(matricula as varchar(255)))), '')
 as num_matricula,
        try_cast(fec_matric as date) as fec_matriculacion,
        
    nullif(ltrim(rtrim(cast(marca as varchar(255)))), '')
 as id_marca,
        
    nullif(ltrim(rtrim(cast(des_marca as varchar(255)))), '')
 as des_marca,
        
    nullif(ltrim(rtrim(cast(modelo as varchar(255)))), '')
 as cat_modelo,
        
    nullif(ltrim(rtrim(cast(des_modelo as varchar(255)))), '')
 as des_modelo,
        
    nullif(ltrim(rtrim(cast(color as varchar(255)))), '')
 as cat_color,
        
    nullif(ltrim(rtrim(cast(des_color as varchar(255)))), '')
 as des_color,
        try_cast(km as decimal(18, 2)) as ud_km,
        
    nullif(ltrim(rtrim(cast(mod_tecnico as varchar(255)))), '')
 as cat_modelo_tecnico,
        
    nullif(ltrim(rtrim(cast(familia as varchar(255)))), '')
 as cat_familia,
        
    nullif(ltrim(rtrim(cast(des_familia as varchar(255)))), '')
 as des_familia,
        
    nullif(ltrim(rtrim(cast(fam_taller as varchar(255)))), '')
 as cat_familia_taller,
        
    nullif(ltrim(rtrim(cast(des_fam_taller as varchar(255)))), '')
 as des_familia_taller,
        
    nullif(ltrim(rtrim(cast(estado as varchar(255)))), '')
 as cat_estado_vehiculo,
        
    nullif(ltrim(rtrim(cast(des_estado as varchar(255)))), '')
 as des_estado_vehiculo,
        
    nullif(ltrim(rtrim(cast(categoria as varchar(255)))), '')
 as cat_categoria_vehiculo,
        
    nullif(ltrim(rtrim(cast(des_categoria as varchar(255)))), '')
 as des_categoria_vehiculo,
        
    nullif(ltrim(rtrim(cast(anio_vehi as varchar(255)))), '')
 as num_anio_vehiculo,
        
    nullif(ltrim(rtrim(cast(vendedor_reserva as varchar(255)))), '')
 as id_vendedor_reserva,
        
    nullif(ltrim(rtrim(cast(nom_vendedor_reserva as varchar(255)))), '')
 as nom_vendedor_reserva,
        
    nullif(ltrim(rtrim(cast(cliente_reserva as varchar(255)))), '')
 as id_cliente_reserva,
        
    nullif(ltrim(rtrim(cast(nom_cliente_reserva as varchar(255)))), '')
 as nom_cliente_reserva,
        try_cast(fec_reserva as date) as fec_reserva,
        
    nullif(ltrim(rtrim(cast(cta_titular as varchar(255)))), '')
 as id_cuenta_titular,
        
    nullif(ltrim(rtrim(cast(cta_cliente as varchar(255)))), '')
 as id_cuenta_cliente,
        
    nullif(ltrim(rtrim(cast(cta_conductor as varchar(255)))), '')
 as id_cuenta_conductor,
        
    nullif(ltrim(rtrim(cast(observaciones as varchar(255)))), '')
 as des_observaciones_vehiculo,
        
    nullif(ltrim(rtrim(cast(nro_bono as varchar(255)))), '')
 as num_bono,
        try_cast(fec_ultima_modificacion as date) as fec_ultima_modificacion,
        try_cast(fec_ultima_visita as date) as fec_ultima_visita_taller,
        
    nullif(ltrim(rtrim(cast(taller_ultima_visita as varchar(255)))), '')
 as id_taller_ultima_visita,
        
    nullif(ltrim(rtrim(cast(nom_taller_ultima_visita as varchar(255)))), '')
 as nom_taller_ultima_visita,
        try_cast(fec_prevista_entrega as date) as fec_entrega_prevista,
        try_cast(precio_modelo as decimal(18, 2)) as imp_precio_modelo,
        
    nullif(ltrim(rtrim(cast(nro_pedido as varchar(255)))), '')
 as num_pedido,
        
    nullif(ltrim(rtrim(cast(tipo_vehiculo as varchar(255)))), '')
 as tpo_vehiculo,
        
    nullif(ltrim(rtrim(cast(ubicacion_ultima as varchar(255)))), '')
 as cat_ubicacion_actual,
        
    nullif(ltrim(rtrim(cast(des_ubicacion_ultima as varchar(255)))), '')
 as des_ubicacion_actual,
        try_cast(fec_alta_rac as date) as fec_alta_rac,
        try_cast(fec_baja_rac as date) as fec_baja_rac,
        
    nullif(ltrim(rtrim(cast(clave_vehicular as varchar(255)))), '')
 as cat_clave_vehicular,
        try_cast(fec_creacion as date) as fec_creacion_registro,
        try_cast(fec_fabricacion as date) as fec_fabricacion_vehiculo,
        try_cast(fec_ultima_itv as date) as fec_ultima_itv,
        try_cast(fec_proxima_itv as date) as fec_proxima_itv,
        
    nullif(ltrim(rtrim(cast(codigo_externo as varchar(255)))), '')
 as id_codigo_externo,
        try_cast(co2 as decimal(18, 2)) as ud_co2,
        
    nullif(ltrim(rtrim(cast(nee as varchar(255)))), '')
 as cat_nee,
        
    nullif(ltrim(rtrim(cast(des_nee as varchar(255)))), '')
 as des_nee,
        try_cast(fec_rec_certif_garantia as date) as fec_recepcion_certificado_garantia,
        try_cast(fec_comunica_vta as date) as fec_comunicacion_venta,
        
    nullif(ltrim(rtrim(cast(tipo_cambio as varchar(255)))), '')
 as tpo_caja_cambios,
        
    nullif(ltrim(rtrim(cast(des_tipo_cambio as varchar(255)))), '')
 as des_caja_cambios,
        try_cast(nplazas as int) as ud_plazas,
        
    nullif(ltrim(rtrim(cast(concesionario_veh as varchar(255)))), '')
 as id_concesionario,
        
    nullif(ltrim(rtrim(cast(segmento as varchar(255)))), '')
 as cat_segmento_vehiculo,
        
    nullif(ltrim(rtrim(cast(des_segmento as varchar(255)))), '')
 as des_segmento_vehiculo,
        
    nullif(ltrim(rtrim(cast(numero_expediente as varchar(255)))), '')
 as num_expediente,
        try_cast(fecha_categoria as date) as fec_categoria_vehiculo,
        
    nullif(ltrim(rtrim(cast(tipo_motor as varchar(255)))), '')
 as tpo_motor,
        
    nullif(ltrim(rtrim(cast(des_tipo_motor as varchar(255)))), '')
 as des_tipo_motor,
        
    nullif(ltrim(rtrim(cast(tipo_carroceria as varchar(255)))), '')
 as tpo_carroceria,
        
    nullif(ltrim(rtrim(cast(des_tipo_carroceria as varchar(255)))), '')
 as des_tipo_carroceria,
        
    nullif(ltrim(rtrim(cast(des_tipo_vehiculo as varchar(255)))), '')
 as des_tipo_vehiculo,
        try_cast(valor_particular as decimal(18, 2)) as imp_valor_particular,
        
    nullif(ltrim(rtrim(cast(color_interior as varchar(255)))), '')
 as cat_color_interior,
        
    nullif(ltrim(rtrim(cast(des_color_interior as varchar(255)))), '')
 as des_color_interior,
        
    nullif(ltrim(rtrim(cast(destino_final as varchar(255)))), '')
 as cat_destino_final,
        
    nullif(ltrim(rtrim(cast(des_destino_final as varchar(255)))), '')
 as des_destino_final,
        
    nullif(ltrim(rtrim(cast(fam_vehiculo as varchar(255)))), '')
 as cat_familia_vehiculo,
        
    nullif(ltrim(rtrim(cast(des_fam_vehiculo as varchar(255)))), '')
 as des_familia_vehiculo,
        
    nullif(ltrim(rtrim(cast(nro_motor as varchar(255)))), '')
 as num_motor,
        
    nullif(ltrim(rtrim(cast(obs_publicacion as varchar(255)))), '')
 as des_observaciones_publicacion,
        
    nullif(ltrim(rtrim(cast(tipo_vehiculo_jato as varchar(255)))), '')
 as cat_tipo_vehiculo_jato,
        
    nullif(ltrim(rtrim(cast(nombre_dato_jato as varchar(255)))), '')
 as nom_atributo_jato,
        
    nullif(ltrim(rtrim(cast(valor_dato_jato as varchar(255)))), '')
 as des_valor_atributo_jato,
        
    nullif(ltrim(rtrim(cast(cod_reserva as varchar(255)))), '')
 as cat_reserva,
        
    nullif(ltrim(rtrim(cast(ano_comer_vehi as varchar(255)))), '')
 as num_anio_comercial_vehiculo,
        
    nullif(ltrim(rtrim(cast(marca_contable as varchar(255)))), '')
 as cod_marca_contable,
        
    nullif(ltrim(rtrim(cast(des_marca_contable as varchar(255)))), '')
 as des_marca_contable, 
        
    nullif(ltrim(rtrim(cast(cod_inf_tecnico as varchar(255)))), '')
 as id_informe_tecnico,
        try_cast(precio_publicacion as decimal(18, 2)) as imp_precio_publicacion,
        
    nullif(ltrim(rtrim(cast(traccion as varchar(255)))), '')
 as cat_traccion,
        
    nullif(ltrim(rtrim(cast(des_traccion as varchar(255)))), '')
 as des_traccion,
        try_cast(dias_gracia as int) as ud_dias_gracia,
        try_cast(ultimo_mov_vn as bigint) as num_ultimo_movimiento_vn,
        try_cast(ultimo_mov_vo as bigint) as num_ultimo_movimiento_vo,
        
    nullif(ltrim(rtrim(cast(nro_serie as varchar(255)))), '')
 as num_serie,
        
    nullif(ltrim(rtrim(cast(numero_llaves as varchar(255)))), '')
 as id_llaves,
        try_cast(fecha_llegada as date) as fec_llegada_vehiculo,
        try_cast(fecha_produccion as date) as fec_produccion_vehiculo,
        
    nullif(ltrim(rtrim(cast(tipo_combustible as varchar(255)))), '')
 as id_combustible,
        
    nullif(ltrim(rtrim(cast(des_tipo_combustible as varchar(255)))), '')
 as des_tipo_combustible,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-09-24 08:05:02' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select