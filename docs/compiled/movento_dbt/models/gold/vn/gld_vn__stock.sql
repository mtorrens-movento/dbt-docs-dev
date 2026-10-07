

SELECT
	vn.id_fila_tecnica,
	CAST(CONVERT(CHAR(8), vn.fec_stock, 112) AS INT) AS id_fecha_stock,
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
	vn.fec_factura,
	vn.fec_recepcion,
	vn.imp_precio_venta_distribuidor,
	vn.imp_iva,
	vn.imp_total,
	vn.ud_unidades,
	vn.id_vendedor_reserva,
	vn.id_cliente_reserva,
	vn.nom_cliente_reserva,
	vn.fec_reserva,
	vn.cod_marca_contable,
	vn.des_motivo_contabiliza_stock,
	vn.ind_contabiliza_stock,
	CAST(
		'2026-10-07 09:07:40'
		AS DATETIME2(0)
	) AS _gold_load_ts
FROM [wh_silver].[int_vn].[stock_enriquecido] AS vn