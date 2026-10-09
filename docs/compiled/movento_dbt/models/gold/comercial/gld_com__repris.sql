

select
	rep.id_repris,
	rep.id_fila_tecnica,
	rep.id_movimiento_compra,
	rep.id_referencia_venta,
	cast(convert(char(8), rep.fec_repris, 112) as int) as id_fecha_repris,
	rep.fec_repris,
	rep.cat_repris,
	rep.id_vehiculo,
	rep.id_vehiculo_venta,
	rep.id_concesionario,
	rep.nom_concesionario,
	rep.id_concesionario_venta,
	rep.nom_concesionario_venta,
	rep.id_vendedor,
	rep.nom_vendedor,
	rep.tpo_vo,
	rep.des_tipo_vo,
	rep.id_canal_origen,
	rep.des_canal_origen,
	rep.imp_compra,
	rep.des_motivo_chatarra,
	rep.ind_chatarra,
	rep.ud_repris,
	rep.ud_repris_con_chatarra,
	rep.ud_repris_sin_chatarra,
	cast(
		'2026-10-09 14:20:25'
		as datetime2(0)
	) as _gold_load_ts
from [wh_silver].[int_comercial].[repris] as rep