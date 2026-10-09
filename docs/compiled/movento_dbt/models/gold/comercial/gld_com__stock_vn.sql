

select
	vn.id_fila_tecnica,
	cast(convert(char(8), vn.fec_stock, 112) as int) as id_fecha_stock,
	vn.fec_stock,
	vn.id_vehiculo,
	vn.id_concesionario,
	vn.nom_concesionario,
	vn.desc_abr_marca,
	vn.num_matricula,
	vn.num_bastidor,
	vn.cod_familia,
	vn.cod_modelo,
	vn.ud_dias_stock,
	vn.ud_stock,
	vn.fec_factura,
	vn.fec_recepcion,
	vn.imp_precio_venta_distribuidor,
	vn.imp_iva,
	vn.imp_total,
	vn.id_vendedor_reserva,
	vn.id_cliente_reserva,
	vn.nom_cliente_reserva,
	vn.fec_reserva,
	vn.cod_marca_contable,
	vn.des_motivo_contabiliza_stock,
	vn.ind_contabiliza_stock,
	cast(
		'2026-10-09 13:20:57'
		as datetime2(0)
	) as _gold_load_ts
from [wh_silver].[int_comercial].[stock_vn_enriquecido] as vn