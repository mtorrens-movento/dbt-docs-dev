

-- Tabla de hechos de ventas VN a nivel de operacion de venta. Para el KPI actual
-- solo conserva el grano temporal y comercial necesario para medir ventas netas
-- frente al año anterior en el semantic model. La lógica de diccionarios y mapeos
-- de vendedores se resuelve en la capa intermediate.

SELECT
	vn.id_fila_tecnica,
	vn.id_referencia,

	CAST(CONVERT(CHAR(8), vn.fec_venta, 112) AS INT) AS id_fecha_venta,
	vn.fec_venta,

	vn.id_concesionario,
	vn.nom_concesionario,
	vn.id_concesionario_venta,
	vn.nom_concesionario_venta,
	vn.id_vendedor,
	vn.nom_vendedor,
	vn.id_tipo_vendedor,
	vn.desc_tipo_vendedor,
	vn.id_vehiculo,
	vn.tpo_venta,
	vn.des_tipo_venta,
	vn.des_motivo_automatricula,
	vn.ind_automatricula,
	vn.des_motivo_contabiliza_venta,
	vn.ind_contabiliza_venta,

	CASE
		WHEN vn.imp_venta_vn < 0 THEN -1
		ELSE 1
	END AS ud_ventas_netas,

	vn.imp_venta_vn,
	vn.imp_beneficio,

	CAST(
		'2026-10-06 18:31:18'
		AS DATETIME2(0)
	) AS _gold_load_ts
FROM [wh_silver].[int_vn].[ventas_enriquecidas] AS vn