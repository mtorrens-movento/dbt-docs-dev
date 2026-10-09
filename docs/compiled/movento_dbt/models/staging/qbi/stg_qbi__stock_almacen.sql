

with source_data as (
    select *
    from [lh_bronze].[qbi_incremental].[fhmabi_pr]
    
    where _snapshot_date > (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_almacen])
       or (
            _snapshot_date = (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_almacen])
        and _ingestion_tst > (
            select max(aud_tst_ingestion)
            from [wh_silver].[stg_qbi].[stock_almacen]
            where aud_dte_snapshot = (select max(aud_dte_snapshot) from [wh_silver].[stg_qbi].[stock_almacen])
        )
       )
    
    -- Si se hace full refresh, se seleccionara el registro mas frecuente por id_fila_tecnica y el snapshot_date
),

con_rn as (
    select
        *,
        row_number() over (
            partition by _snapshot_date, refx
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
        
    nullif(ltrim(rtrim(cast(almacen as varchar(255)))), '')
 as id_almacen,
        
    nullif(ltrim(rtrim(cast(nom_almacen as varchar(255)))), '')
 as nom_almacen,
        try_cast(marca_almacen as int) as cod_marca_almacen,
        
    nullif(ltrim(rtrim(cast(des_marca_almacen as varchar(255)))), '')
 as des_marca_almacen,
        
    nullif(ltrim(rtrim(cast(antiguedad as varchar(255)))), '')
 as cat_antiguedad,
        
    nullif(ltrim(rtrim(cast(familia as varchar(255)))), '')
 as cat_familia_articulo,
        
    nullif(ltrim(rtrim(cast(des_familia as varchar(255)))), '')
 as des_familia_articulo,
        
    nullif(ltrim(rtrim(cast(fam_apro as varchar(255)))), '')
 as cat_familia_aprovisionamiento,
        
    nullif(ltrim(rtrim(cast(des_fam_apro as varchar(255)))), '')
 as des_familia_aprovisionamiento,
        
    nullif(ltrim(rtrim(cast(grupo as varchar(255)))), '')
 as cat_grupo_articulo,
        
    nullif(ltrim(rtrim(cast(des_grupo as varchar(255)))), '')
 as des_grupo_articulo,
        try_cast(marca_contable as int) as cod_marca_contable,
        
    nullif(ltrim(rtrim(cast(des_marca_contable as varchar(255)))), '')
 as des_marca_contable,
        
    nullif(ltrim(rtrim(cast(clase as varchar(255)))), '')
 as cat_clase_articulo,
        
    nullif(ltrim(rtrim(cast(subclase as varchar(255)))), '')
 as cat_subclase_articulo,
        try_cast(existencias as decimal(18, 2)) as ud_existencias,
        try_cast(exis_bope as int) as ud_existencias_bope,
        try_cast(pvp as decimal(18, 2)) as imp_pvp_unitario,
        try_cast(costo_medio as decimal(18, 8)) as imp_costo_medio_unitario,
        try_cast(costo_ultimo as decimal(18, 8)) as imp_costo_ultimo_unitario,
        
    nullif(ltrim(rtrim(cast(moneda as varchar(255)))), '')
 as cat_moneda,
        
    nullif(ltrim(rtrim(cast(ubicacion as varchar(255)))), '')
 as id_ubicacion,
        
    nullif(ltrim(rtrim(cast(articulo as varchar(255)))), '')
 as cat_articulo,
        
    nullif(ltrim(rtrim(cast(des_articulo as varchar(255)))), '')
 as des_articulo,
        try_cast(fec_alta as datetime2(0)) as fec_alta,
        try_cast(fec_ultima_venta as datetime2(0)) as fec_ultima_venta,
        try_cast(fec_ultima_compra as datetime2(0)) as fec_ultima_compra,
        
    nullif(ltrim(rtrim(cast(clave_descuento as varchar(255)))), '')
 as cat_clave_descuento,
        
    nullif(ltrim(rtrim(cast(indice as varchar(255)))), '')
 as cat_indice_articulo,
        try_cast(multiplos as int) as num_multiplos,
        
    nullif(ltrim(rtrim(cast(fam_marketing as varchar(255)))), '')
 as cat_familia_marketing,
        
    nullif(ltrim(rtrim(cast(des_fam_marketing as varchar(255)))), '')
 as des_familia_marketing,
        
    nullif(ltrim(rtrim(cast(ref_ult_entrada as varchar(255)))), '')
 as id_referencia_ultima_entrada,
        
    nullif(ltrim(rtrim(cast(clasificacion as varchar(255)))), '')
 as cat_clasificacion,
        
    nullif(ltrim(rtrim(cast(des_clasificacion as varchar(255)))), '')
 as des_clasificacion,
        
    nullif(ltrim(rtrim(cast(modelos as varchar(255)))), '')
 as des_modelos,
        
    nullif(ltrim(rtrim(cast(clase_abc as varchar(255)))), '')
 as cat_clase_abc,
        
    nullif(ltrim(rtrim(cast(anulada as varchar(255)))), '')
 as ind_anulada,
        try_cast(fec_ult_lectura as datetime2(0)) as fec_ult_lectura,
        try_cast(existencias_disp as decimal(18, 2)) as ud_existencias_disponibles,
        
    nullif(ltrim(rtrim(cast(existencias_raw as varchar(255)))), '')
 as txt_existencias_raw,
        try_cast(_snapshot_tst as datetime2(0)) as aud_tst_snapshot,
        try_cast(_snapshot_date as date) as aud_dte_snapshot,
        try_cast(_ingestion_tst as datetime2(0)) as aud_tst_ingestion
    from unicos
)

select
    final_select.*,
    cast(coalesce(final_select.aud_tst_ingestion, cast(final_select.aud_dte_snapshot as datetime2(0)), cast('2026-10-09 12:20:25' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from final_select