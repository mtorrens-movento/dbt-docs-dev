

-- Lineas de mano de obra de las OR, el grano de origen de la sobi. Solo lleva las medidas
-- que son de la linea: los importes del cargo (imp_total_mo, imp_total_rec) se repiten en
-- cada linea y aqui se inflarian al sumar.
--
-- imp_cn_mano_obra es la cifra de negocio de mano de obra de la linea: horas por precio
-- hora, o el importe de la linea si las horas o el precio son 0. Que tipos de MO cuentan
-- lo decide ind_hora_facturada de int_pv__tipos_mo.

SELECT
    id_orden_reparacion,
    id_cargo,
    seq_linea_or,
    fec_cierre_or,

    id_taller,
    id_vehiculo,
    cod_marca,
    tpo_or,
    tpo_mano_obra,

    ud_tiempo_or AS ud_horas_facturadas,
    imp_precio_hora,
    imp_total_linea AS imp_mano_obra,

    CASE
        WHEN ud_tiempo_or = 0 OR imp_precio_hora = 0 THEN imp_total_linea
        ELSE ud_tiempo_or * imp_precio_hora
    END AS imp_cn_mano_obra
FROM [wh_silver].[stg_qbi].[pasos_taller_cerrados]
WHERE id_orden_reparacion IS NOT NULL
  AND id_cargo IS NOT NULL