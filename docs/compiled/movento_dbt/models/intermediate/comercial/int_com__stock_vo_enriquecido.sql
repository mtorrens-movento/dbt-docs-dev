

select
    sv.id_fila_tecnica,
    sv.fec_corte_stock as fec_stock,
    sv.id_vehiculo,
    sv.id_concesionario,
    sv.nom_concesionario,
    veh.des_marca as desc_abr_marca,
    veh.num_matricula,
    veh.num_bastidor,
    sv.cod_familia,
    sv.tpo_vo,
    sv.des_tipo_vo,
    case
        when sv.tpo_vo in ('7', '8', '08') then (
            select max(v.fecha_inicio)
            from (
                values
                    (sv.fec_recepcion),
                    (sv.fec_entrada_real),
                    (mvo.fec_factura_origen)
            ) as v(fecha_inicio)
        )
        else sv.fec_compra
    end as fec_inicio_stock,
    case
        when sv.fec_corte_stock is null then null
        when sv.tpo_vo in ('7', '8', '08') then (
            select max(v.dias_stock)
            from (
                values
                    (case when sv.fec_recepcion is not null then datediff(day, sv.fec_recepcion, sv.fec_corte_stock) end),
                    (case when sv.fec_entrada_real is not null then datediff(day, sv.fec_entrada_real, sv.fec_corte_stock) end),
                    (case when mvo.fec_factura_origen is not null then datediff(day, mvo.fec_factura_origen, sv.fec_corte_stock) end)
            ) as v(dias_stock)
        )
        when sv.fec_compra is null then null
        else datediff(day, sv.fec_compra, sv.fec_corte_stock)
    end as ud_dias_stock,
    cast(1 as int) as ud_stock,
    can.id_canal_origen,
    can.des_canal_origen,
    case
        when try_cast(sv.imp_compra as decimal(18, 2)) <= 1 then 'precio_compra_inferior_igual_1'
        when coalesce(can.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then 'canal_origen_no_contabilizable'
        else null
    end as des_motivo_contabiliza_stock,
    case
        when try_cast(sv.imp_compra as decimal(18, 2)) <= 1 then cast(0 as int)
        when coalesce(can.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then cast(0 as int)
        else cast(1 as int)
    end as ind_contabiliza_stock,
    sv.imp_compra,
    sv.imp_costo,
    sv.aud_dte_snapshot,
    sv.aud_tst_ingestion,
    sv.aud_tst_ultima_actualizacion
from [wh_silver].[stg_qbi].[stock_vo] as sv
left join [wh_silver].[stg_qbi].[vehiculos] as veh
    on veh.id_vehiculo = sv.id_vehiculo
left join [wh_silver].[stg_qbi].[compras_vo] as mvo
    on mvo.id_movimiento_compra = sv.id_movimiento_referencia
outer apply (
    select top 1
        d.id_canal_origen
    from [wh_silver].[stg_shp_mdm].[dic_com_tipo_vo_canal_origen] as d
    where d.tipo_vo = sv.tpo_vo
      and (d.fec_ini is null or d.fec_ini <= cast(sv.fec_corte_stock as date))
      and (d.fec_fin is null or d.fec_fin >= cast(sv.fec_corte_stock as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as dic
left join [wh_silver].[stg_shp_mdm].[com_canales_origen] as can
    on can.id_canal_origen = dic.id_canal_origen