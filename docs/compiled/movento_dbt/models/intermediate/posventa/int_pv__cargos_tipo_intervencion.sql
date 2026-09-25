

with cargos as (
    select
        c.id_orden_reparacion,
        c.id_cargo,
        c.cod_marca,
        m.id_marca,
        c.des_marca,
        c.aud_dte_snapshot,
        c.aud_tst_ingestion
    from [wh_silver].[int_posventa].[pasos_cargo_collapsed] c
    left join [wh_silver].[stg_qbi].[marcas] m
        on m.cod_marca = c.cod_marca
),

materiales as (
    select
        id_orden_reparacion,
        id_cargo,
        cat_articulo,
        des_articulo,
        cat_familia_articulo,
        cat_familia_aprovisionamiento,
        cat_grupo_neumaticos,
        aud_dte_snapshot as aud_dte_snapshot_material,
        aud_tst_ingestion as aud_tst_ingestion_material
    from [wh_silver].[int_recambios].[ventas_internas]
    where id_orden_reparacion is not null
      and id_cargo is not null
),

columnas_agrupacion_marcas as (
    select
        id_marca,
        id_agrupacion
    from [wh_silver].[stg_shp_mdm].[pv_marcas_col_agrup_inter]
),

columnas_agrupaciones as (
    select
        id_agrupacion,
        desc_agrupacion as nom_columna_usada
    from [wh_silver].[stg_shp_mdm].[pv_cols_agrup_inter]
),

catalogo_codigos as (
    select
        id_agrupacion,
        codigo,
        id_tipo_intervencion,
        fec_inicio,
        fec_fin
    from [wh_silver].[stg_shp_mdm].[pv_codigos_inter]
),

base as (
    select
        c.id_orden_reparacion,
        c.id_cargo,
        c.cod_marca,
        c.id_marca,
        c.des_marca,
        m.cat_articulo,
        m.des_articulo,
        m.cat_familia_articulo,
        m.cat_familia_aprovisionamiento,
        m.cat_grupo_neumaticos,
        ma.id_agrupacion,
        ag.nom_columna_usada,
        case ag.nom_columna_usada
            when 'ARTICULO' then
            case
                when c.id_marca = 'HY' and coalesce(m.cat_articulo, '') like '50/263%'
                    then left(m.cat_articulo, 6)
                when c.id_marca = 'HY'
                    then left(m.cat_articulo, 8)
                else m.cat_articulo
            end
            when 'FAM_APRO' then m.cat_familia_aprovisionamiento
            when 'FAMILIA_ART' then m.cat_familia_articulo
            when 'GRUPO' then m.cat_grupo_neumaticos
        end as cod_origen_relacionado,
        greatest(m.aud_dte_snapshot_material, c.aud_dte_snapshot) as aud_dte_snapshot,
        greatest(m.aud_tst_ingestion_material, c.aud_tst_ingestion) as aud_tst_ingestion
    from cargos c
    inner join materiales m
        on m.id_orden_reparacion = c.id_orden_reparacion
       and m.id_cargo = c.id_cargo
    inner join columnas_agrupacion_marcas ma
        on ma.id_marca = c.id_marca
    inner join columnas_agrupaciones ag
        on ag.id_agrupacion = ma.id_agrupacion
),

dedup as (
    select
        b.id_orden_reparacion,
        b.id_cargo,
        b.cod_marca,
        b.id_marca,
        b.des_marca,
        b.cat_articulo,
        b.des_articulo,
        b.id_agrupacion,
        b.nom_columna_usada,
        b.cod_origen_relacionado,
        cc.id_tipo_intervencion,
        b.aud_dte_snapshot,
        b.aud_tst_ingestion,
        row_number() over (
            partition by b.id_orden_reparacion, b.id_cargo, cc.id_tipo_intervencion
            order by
                case b.nom_columna_usada
                    when 'ARTICULO' then 1
                    when 'FAM_APRO' then 2
                    when 'FAMILIA_ART' then 3
                    when 'GRUPO' then 4
                    else 5
                end,
                b.aud_tst_ingestion desc
        ) as rn
    from base b
    inner join catalogo_codigos cc
        on cc.id_agrupacion = b.id_agrupacion
       and cc.codigo = b.cod_origen_relacionado
    where b.cod_origen_relacionado is not null
      and b.cod_origen_relacionado <> ''
)

select
    d.id_orden_reparacion,
    d.id_cargo,
    d.cod_marca,
    d.id_marca,
    d.des_marca,
    d.id_tipo_intervencion,
    ti.des_intervencion,
    d.id_agrupacion,
    d.nom_columna_usada,
    d.cod_origen_relacionado,
    d.cat_articulo,
    d.des_articulo,
    d.aud_dte_snapshot,
    d.aud_tst_ingestion,
    cast(coalesce(d.aud_tst_ingestion, cast(d.aud_dte_snapshot as datetime2(0)), cast('2026-09-25 12:49:51' as datetime2(0))) as datetime2(0)) as aud_tst_ultima_actualizacion
from dedup d
inner join [wh_silver].[stg_shp_mdm].[pv_tipos_inter] ti
    on ti.id_tipo_intervencion = d.id_tipo_intervencion
where d.rn = 1