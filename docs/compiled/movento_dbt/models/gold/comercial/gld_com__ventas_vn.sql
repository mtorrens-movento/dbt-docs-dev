

select
	vn.id_fila_tecnica,
	vn.id_referencia,
	cast(convert(char(8), vn.fec_venta, 112) as int) as id_fecha_venta,
	vn.fec_venta,
	vn.id_concesionario,
	vn.nom_concesionario,
	vn.id_concesionario_venta,
	vn.nom_concesionario_venta,
	vn.id_vendedor,
	vn.nom_vendedor,
	vn.id_tipo_vendedor,
	vn.des_tipo_vendedor,
	vn.id_vehiculo,
	vn.tpo_venta,
	vn.des_tipo_venta,
	vn.des_motivo_automatricula,
	vn.ind_automatricula,
	vn.des_motivo_contabiliza_venta,
	vn.ind_contabiliza_venta,
	case
		when vn.imp_venta_vn < 0 then -1
		else 1
	end as ud_ventas,
	vn.imp_venta_vn,
	vn.imp_beneficio,
	cast(
		'2026-10-09 13:20:57'
		as datetime2(0)
	) as _gold_load_ts
from [wh_silver].[int_comercial].[ventas_vn_enriquecidas] as vn