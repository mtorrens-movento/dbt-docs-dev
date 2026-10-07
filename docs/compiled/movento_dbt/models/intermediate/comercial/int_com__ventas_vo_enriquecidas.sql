

with ventas_vo as (
    select
        *
    from [wh_silver].[stg_qbi].[ventas_vo]
    where fec_venta is not null
)

select
    vo.id_fila_tecnica,
    vo.id_referencia,
    vo.fec_venta,
    vo.id_concesionario,
    vo.nom_concesionario,
    vo.id_concesionario_venta,
    vo.nom_concesionario_venta,
    vo.id_vendedor as id_vendedor_quiter,
    vo.nom_vendedor as nom_vendedor_quiter,
    ven.id_vendedor,
    ven.nom_vendedor,
    ven.id_tipo_vendedor,
    ven.des_tipo_vendedor,
    vo.id_vehiculo,
    vo.tpo_venta,
    vo.des_tipo_venta,
    vo.id_cuenta_cliente,
    can.id_canal_venta,
    can.des_canal_venta,
    case
        when coalesce(ven.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then 'vendedor_no_contabilizable'
        when coalesce(subcan.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then 'subcanal_no_contabilizable'
        when coalesce(can.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then 'canal_no_contabilizable'
        else null
    end as des_motivo_contabiliza_venta,
    case
        when coalesce(ven.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then cast(0 as int)
        when coalesce(subcan.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then cast(0 as int)
        when coalesce(can.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then cast(0 as int)
        else cast(1 as int)
    end as ind_contabiliza_venta,
    vo.imp_venta_vo,
    vo.imp_beneficio,
    vo.aud_dte_snapshot,
    vo.aud_tst_ingestion,
    vo.aud_tst_ultima_actualizacion
from ventas_vo as vo
outer apply (
    select top 1
        d.id_ven_org
    from [wh_silver].[stg_shp_mdm].[dic_com_vendedores_quiter_org] as d
    where d.id_ven_quiter = vo.id_vendedor
      and (d.fec_ini is null or d.fec_ini <= cast(vo.fec_venta as date))
      and (d.fec_fin is null or d.fec_fin >= cast(vo.fec_venta as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as ven_dic
outer apply (
    select top 1
        v.id_vendedor,
        v.nom_vendedor,
        v.id_tipo_vendedor,
        v.des_tipo_vendedor,
        v.no_contabiliza
    from [wh_silver].[stg_shp_mdm].[com_vendedores] as v
    where v.id_vendedor = ven_dic.id_ven_org
      and (v.fec_ini is null or v.fec_ini <= cast(vo.fec_venta as date))
      and (v.fec_fin is null or v.fec_fin >= cast(vo.fec_venta as date))
    order by
        coalesce(v.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(v.fec_fin, cast('9999-12-31' as date)) desc
) as ven
outer apply (
    select top 1
        d.id_subcanal_venta
    from [wh_silver].[stg_shp_mdm].[dic_com_tipo_venta_subcanal_venta] as d
    where d.id_tipo_venta = vo.tpo_venta
      and (d.fec_ini is null or d.fec_ini <= cast(vo.fec_venta as date))
      and (d.fec_fin is null or d.fec_fin >= cast(vo.fec_venta as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as dic
left join [wh_silver].[stg_shp_mdm].[com_subcanales_venta] as subcan
    on subcan.id_subcanal_venta = dic.id_subcanal_venta
left join [wh_silver].[stg_shp_mdm].[com_canales_venta] as can
    on can.id_canal_venta = subcan.id_canal_venta