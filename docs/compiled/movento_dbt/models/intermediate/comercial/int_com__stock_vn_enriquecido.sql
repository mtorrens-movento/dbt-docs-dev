

select
    sv.id_fila_tecnica,
    sv.fec_corte_stock as fec_stock,
    sv.id_vehiculo,
    sv.id_concesionario,
    sv.nom_concesionario,
    veh.des_marca as desc_abr_marca,
    veh.num_matricula as num_matricula,
    veh.num_bastidor as num_bastidor,
    veh.cat_familia as id_familia_quiter,
    dic.id_familia,
    fam.cod_familia,
    veh.cat_modelo as cod_modelo,
    case
        when sv.fec_factura is null or sv.fec_corte_stock is null then null
        else abs(datediff(day, sv.fec_factura, sv.fec_corte_stock))
    end as ud_dias_stock,
    cast(1 as int) as ud_stock,
    sv.fec_factura,
    sv.fec_recepcion,
    case
        when sv.imp_costo is null or sv.imp_costo = 0 then sv.imp_compra
        else sv.imp_costo
    end as imp_precio_venta_distribuidor,
    sv.imp_iva_compra as imp_iva,
    sv.imp_precio_compra_total as imp_total,
    sv.id_vendedor_reserva,
    sv.id_cliente_reserva,
    sv.nom_cliente_reserva,
    sv.cat_estado,
    sv.fec_reserva,
    veh.cod_marca_contable,
    case
        when coalesce(sv.cat_estado, '') in ('DEM', 'SUS') then 'estado_no_contabilizable'
        when coalesce(fam.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then 'familia_no_contabilizable'
        else null
    end as des_motivo_contabiliza_stock,
    case
        when coalesce(sv.cat_estado, '') in ('DEM', 'SUS') then cast(0 as int)
        when coalesce(fam.no_contabiliza, cast(0 as bit)) = cast(1 as bit) then cast(0 as int)
        else cast(1 as int)
    end as ind_contabiliza_stock,
    sv.aud_dte_snapshot,
    sv.aud_tst_ingestion,
    sv.aud_tst_ultima_actualizacion
from [wh_silver].[stg_qbi].[stock_vn] as sv
left join [wh_silver].[stg_qbi].[vehiculos] as veh
    on veh.id_vehiculo = sv.id_vehiculo
outer apply (
    select top 1
        d.id_familia
    from [wh_silver].[stg_shp_mdm].[dic_com_familias] as d
    where d.id_familia_quiter = veh.cat_familia
      and (d.fec_ini is null or d.fec_ini <= cast(sv.fec_corte_stock as date))
      and (d.fec_fin is null or d.fec_fin >= cast(sv.fec_corte_stock as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as dic
left join [wh_silver].[stg_shp_mdm].[com_familias] as fam
    on fam.id_familia = dic.id_familia