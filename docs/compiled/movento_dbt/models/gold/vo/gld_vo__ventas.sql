

SELECT
	vo.id_fila_tecnica,
	vo.id_referencia,

	CAST(CONVERT(CHAR(8), vo.fec_venta, 112) AS INT) AS id_fecha_venta,
	vo.fec_venta,

	vo.id_concesionario,
	vo.nom_concesionario,
	vo.id_concesionario_venta,
	vo.nom_concesionario_venta,
	vo.id_vendedor,
	vo.nom_vendedor,
	vo.id_tipo_vendedor,
	vo.desc_tipo_vendedor,
	vo.id_canal_venta,
	vo.desc_canal_venta,
	vo.id_vehiculo,
	vo.tpo_venta,
	vo.des_tipo_venta,
	vo.des_motivo_contabiliza_venta,
	vo.ind_contabiliza_venta,

	CASE
		WHEN vo.imp_venta_vo < 0 THEN -1
		ELSE 1
	END AS ud_ventas_netas,

	vo.imp_venta_vo,
	vo.imp_beneficio,

	CAST(
		'2026-10-06 09:05:37'
		AS DATETIME2(0)
	) AS _gold_load_ts
FROM [wh_silver].[int_vo].[ventas_enriquecidas] AS vo