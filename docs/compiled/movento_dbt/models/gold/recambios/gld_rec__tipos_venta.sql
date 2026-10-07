

-- Dimension de tipos de venta para los hechos de ventas de almacen (se relaciona por
-- tpo_venta). La logica vive en int_rec__tipos_venta.

SELECT
    tpo_venta,
    id_canal,
    nom_canal,
    id_agrupacion_canal,
    nom_agrupacion_canal
FROM [wh_silver].[int_recambios].[tipos_venta]