

select
	vo.id_fila_tecnica,
	cast(convert(char(8), vo.fec_stock, 112) as int) as id_fecha_stock,
	vo.fec_stock,
	vo.id_vehiculo,
	vo.id_concesionario,
	vo.nom_concesionario,
	vo.desc_abr_marca,
	vo.num_matricula,
	vo.num_bastidor,
	vo.cod_familia,
	vo.tpo_vo,
	vo.des_tipo_vo,
	vo.ud_dias_stock,
	vo.ud_stock,
	vo.id_canal_origen,
	vo.des_canal_origen,
	vo.des_motivo_contabiliza_stock,
	vo.ind_contabiliza_stock,
	vo.imp_compra,
	vo.imp_costo,
	cast(
		'2026-10-07 16:16:01'
		as datetime2(0)
	) as _gold_load_ts
from [wh_silver].[int_comercial].[stock_vo_enriquecido] as vo