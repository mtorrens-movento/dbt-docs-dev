

select
	vo.id_fila_tecnica,
	vo.id_referencia,
	cast(convert(char(8), vo.fec_venta, 112) as int) as id_fecha_venta,
	vo.fec_venta,
	vo.id_concesionario,
	vo.nom_concesionario,
	vo.id_vendedor,
	vo.nom_vendedor,
	vo.id_tipo_vendedor,
	vo.des_tipo_vendedor,
	vo.id_canal_venta,
	vo.des_canal_venta,
	vo.id_vehiculo,
	vo.tpo_venta,
	vo.des_tipo_venta,
	vo.des_motivo_contabiliza_venta,
	vo.ind_contabiliza_venta,
	case
		when vo.imp_venta_vo < 0 then -1
		else 1
	end as ud_ventas,
	vo.imp_venta_vo,
	vo.imp_beneficio,
	cast(
		'2026-10-09 14:13:20'
		as datetime2(0)
	) as _gold_load_ts
from [wh_silver].[int_comercial].[ventas_vo_enriquecidas] as vo