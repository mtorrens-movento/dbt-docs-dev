

-- Ventas de almacen a nivel de linea, el grano de origen de la sabi.
--
-- imp_venta es imp_total_linea, lo facturado. imp_total_base_imponible no se incluye: es
-- el total de la venta repetido en cada linea, y sumarlo aqui lo multiplicaria por el
-- numero de lineas.
--
-- La cifra de negocio de recambios a exterior se valora a PVP con el descuento de
-- deferencia (imp_venta_pvp) y cuenta solo las lineas con ind_venta_exterior: las que no
-- salen a taller y cuyo tipo de venta va, segun el diccionario, a un canal de las
-- agrupaciones EXTERIOR o AGENTES (RAS). Los canales NO CONTABILIZA (presupuestos, ventas
-- provisionales, traspasos internos...) no tienen agrupacion y quedan fuera. Los recambios
-- a taller no salen de aqui sino de int_pv__or_cargo, por la OR.
--
-- imp_venta_coste es el coste de la linea. Es la venta que se compara con el stock, que
-- tambien esta valorado a coste, para la rotacion de stock.



SELECT
    v.id_orden_venta,
    v.seq_linea_venta,
    v.fec_movimiento,

    v.id_almacen,
    v.cod_marca_contable,
    TRY_CAST(v.cod_marca_almacen AS INT) AS cod_marca_almacen,
    v.tpo_venta,

    v.ud_unidades_venta,
    v.imp_total_linea AS imp_venta,
    ROUND(v.ud_unidades_venta * v.imp_pvp_unitario * (1 - v.rat_descuento_deferencia / 100), 2)
        AS imp_venta_pvp,
    v.imp_costo_linea AS imp_venta_coste,

    CASE
        WHEN COALESCE(v.ref_ind_salida_taller, 'N') = 'N'
            AND t.nom_agrupacion_canal IN ('EXTERIOR', 'AGENTES (RAS)')
            THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END AS ind_venta_exterior
FROM [wh_silver].[stg_qbi].[ventas_almacen] v
LEFT JOIN [wh_silver].[int_recambios].[tipos_venta] t
    ON t.tpo_venta = v.tpo_venta