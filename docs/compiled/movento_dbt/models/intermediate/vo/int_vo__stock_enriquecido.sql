

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
    can.id_canal_origen,
    can.desc_canal_origen,
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
    cast(1 as int) as ud_unidades,
    sv.aud_dte_snapshot,
    sv.aud_tst_ingestion,
    sv.aud_tst_ultima_actualizacion
from [wh_silver].[stg_qbi].[stock_vo] as sv
left join [wh_silver].[stg_qbi].[vehiculos] as veh
    on veh.id_vehiculo = sv.id_vehiculo
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