

with ventas_vn as (
    select
        *
    from [wh_silver].[stg_qbi].[ventas_vn]
    where fec_venta is not null
)

select
    vn.id_fila_tecnica,
    vn.id_referencia,
    vn.fec_venta,
    vn.id_concesionario,
    vn.nom_concesionario,
    vn.id_vendedor as id_vendedor_quiter,
    vn.nom_vendedor as nom_vendedor_quiter,
    ven.id_vendedor,
    ven.nom_vendedor,
    ven.id_tipo_vendedor,
    ven.des_tipo_vendedor,
    vn.id_vehiculo,
    vn.tpo_venta,
    vn.des_tipo_venta,
    vn.id_cuenta_cliente,
    subcan.id_subcanal_venta,
    subcan.des_subcanal_venta,
    can.id_canal_venta,
    can.des_canal_venta,
    case
        when vn.id_cuenta_cliente = 'K110012' then 'cliente_stern'
        when upper(coalesce(ven.des_tipo_vendedor, '')) like '%AUTOMATRI%' then 'tipo_vendedor_automatricula'
        when upper(coalesce(subcan.des_subcanal_venta, '')) like '%AUTOMATRI%' then 'subcanal_automatricula'
        when upper(coalesce(can.des_canal_venta, '')) like '%AUTOMATRI%' then 'canal_automatricula'
        else null
    end as des_motivo_automatricula,
    case
        when vn.id_cuenta_cliente = 'K110012' then cast(1 as int)
        when upper(coalesce(ven.des_tipo_vendedor, '')) like '%AUTOMATRI%' then cast(1 as int)
        when upper(coalesce(subcan.des_subcanal_venta, '')) like '%AUTOMATRI%' then cast(1 as int)
        when upper(coalesce(can.des_canal_venta, '')) like '%AUTOMATRI%' then cast(1 as int)
        else cast(0 as int)
    end as ind_automatricula,
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
    vn.imp_venta_vn,
    vn.imp_beneficio,
    vn.aud_dte_snapshot,
    vn.aud_tst_ingestion,
    vn.aud_tst_ultima_actualizacion
from ventas_vn as vn
outer apply (
    select top 1
        d.id_ven_org
    from [wh_silver].[stg_shp_mdm].[dic_com_vendedores_quiter_org] as d
    where d.id_ven_quiter = vn.id_vendedor
      and (d.fec_ini is null or d.fec_ini <= cast(vn.fec_venta as date))
      and (d.fec_fin is null or d.fec_fin >= cast(vn.fec_venta as date))
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
      and (v.fec_ini is null or v.fec_ini <= cast(vn.fec_venta as date))
      and (v.fec_fin is null or v.fec_fin >= cast(vn.fec_venta as date))
    order by
        coalesce(v.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(v.fec_fin, cast('9999-12-31' as date)) desc
) as ven
outer apply (
    select top 1
        d.id_subcanal_venta
    from [wh_silver].[stg_shp_mdm].[dic_com_tipo_venta_subcanal_venta] as d
    where d.id_tipo_venta = vn.tpo_venta
      and (d.fec_ini is null or d.fec_ini <= cast(vn.fec_venta as date))
      and (d.fec_fin is null or d.fec_fin >= cast(vn.fec_venta as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as dic
left join [wh_silver].[stg_shp_mdm].[com_subcanales_venta] as subcan
    on subcan.id_subcanal_venta = dic.id_subcanal_venta
left join [wh_silver].[stg_shp_mdm].[com_canales_venta] as can
    on can.id_canal_venta = subcan.id_canal_venta