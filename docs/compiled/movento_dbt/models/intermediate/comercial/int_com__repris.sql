

with compras_filtradas as (
    select
        c.id_fila_tecnica,
        c.id_movimiento_compra,
        c.id_vehiculo,
        c.fec_movimiento as fec_repris,
        c.id_concesionario,
        c.nom_concesionario,
        c.id_vendedor,
        c.nom_vendedor,
        c.tpo_vo,
        c.des_tipo_vo,
        c.imp_compra,
        try_cast(
            case
                when charindex('/', c.id_movimiento_compra) > 0 then left(c.id_movimiento_compra, charindex('/', c.id_movimiento_compra) - 1)
            end as int
        ) as id_referencia_venta,
        can_dic.id_canal_origen,
        can.des_canal_origen,
        case
            when coalesce(c.imp_compra, cast(0 as decimal(18, 2))) between -2 and 2 then 'Precio compra entre -2 y 2'
            else NULL
        end as des_motivo_chatarra,
        case
            when coalesce(c.imp_compra, cast(0 as decimal(18, 2))) between -2 and 2 then cast(1 as int)
            else cast(0 as int)
        end as ind_chatarra,
        case
            when coalesce(c.imp_compra, cast(0 as decimal(18, 2))) between -2 and 2 then cast(1 as int)
            else cast(0 as int)
        end as ud_repris_con_chatarra,
        case
            when coalesce(c.imp_compra, cast(0 as decimal(18, 2))) between -2 and 2 then cast(0 as int)
            else cast(1 as int)
        end as ud_repris_sin_chatarra,
        c.aud_dte_snapshot,
        c.aud_tst_ingestion,
        c.aud_tst_ultima_actualizacion
    from [wh_silver].[stg_qbi].[compras_vo] as c
    outer apply (
        select top 1
            d.id_canal_origen
        from [wh_silver].[stg_shp_mdm].[dic_com_tipo_vo_canal_origen] as d
        where d.tipo_vo = c.tpo_vo
          and (d.fec_ini is null or d.fec_ini <= cast(c.fec_movimiento as date))
          and (d.fec_fin is null or d.fec_fin >= cast(c.fec_movimiento as date))
        order by
            coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
            coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
    ) as can_dic
    outer apply (
        select top 1
            d.id_ven_org
        from [wh_silver].[stg_shp_mdm].[dic_com_vendedores_quiter_org] as d
        where d.id_ven_quiter = c.id_vendedor
          and (d.fec_ini is null or d.fec_ini <= cast(c.fec_movimiento as date))
          and (d.fec_fin is null or d.fec_fin >= cast(c.fec_movimiento as date))
        order by
            coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
            coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
    ) as ven_dic
    left join [wh_silver].[stg_shp_mdm].[com_canales_origen] as can
        on can.id_canal_origen = can_dic.id_canal_origen
    left join [wh_silver].[stg_shp_mdm].[com_vendedores] as ven
        on ven.id_vendedor = ven_dic.id_ven_org
    where coalesce(ven.no_contabiliza, cast(0 as bit)) = cast(0 as bit)
      and charindex('/', coalesce(c.id_movimiento_compra, '')) > 0
      and coalesce(can_dic.id_canal_origen, cast(0 as int)) in (1,2) --Canales origen REPRIS VN y VO
),

repris_vo as (
    select
        concat(c.id_fila_tecnica, '_VO') as id_repris,
        'VO' as cat_repris,
        c.id_fila_tecnica,
        c.id_movimiento_compra,
        c.id_referencia_venta,
        c.fec_repris,
        c.id_vehiculo,
        vo.id_vehiculo as id_vehiculo_venta,
        c.id_concesionario,
        c.nom_concesionario,
        vo.id_concesionario_venta,
        vo.nom_concesionario_venta,
        c.id_vendedor,
        c.nom_vendedor,
        c.tpo_vo,
        c.des_tipo_vo,
        c.id_canal_origen,
        c.des_canal_origen,
        c.imp_compra,
        c.des_motivo_chatarra,
        c.ind_chatarra,
        cast(1 as int) as ud_repris,
        c.ud_repris_con_chatarra,
        c.ud_repris_sin_chatarra,
        c.aud_dte_snapshot,
        c.aud_tst_ingestion,
        c.aud_tst_ultima_actualizacion
    from compras_filtradas as c
    inner join [wh_silver].[stg_qbi].[ventas_vo] as vo
        on vo.id_referencia = c.id_referencia_venta
       and c.id_canal_origen = 2 --Canal Origen REPRIS VO
),

repris_vn as (
    select
        concat(c.id_fila_tecnica, '_VN') as id_repris,
        'VN' as cat_repris,
        c.id_fila_tecnica,
        c.id_movimiento_compra,
        c.id_referencia_venta,
        c.fec_repris,
        c.id_vehiculo,
        vn.id_vehiculo as id_vehiculo_venta,
        c.id_concesionario,
        c.nom_concesionario,
        vn.id_concesionario_venta,
        vn.nom_concesionario_venta,
        c.id_vendedor,
        c.nom_vendedor,
        c.tpo_vo,
        c.des_tipo_vo,
        c.id_canal_origen,
        c.des_canal_origen,
        c.imp_compra,
        c.des_motivo_chatarra,
        c.ind_chatarra,
        cast(1 as int) as ud_repris,
        c.ud_repris_con_chatarra,
        c.ud_repris_sin_chatarra,
        c.aud_dte_snapshot,
        c.aud_tst_ingestion,
        c.aud_tst_ultima_actualizacion
    from compras_filtradas as c
    inner join [wh_silver].[stg_qbi].[ventas_vn] as vn
        on vn.id_referencia = c.id_referencia_venta
       and c.id_canal_origen = 1 --Canal Origen REPRIS VN
)

select * from repris_vo
union all
select * from repris_vn