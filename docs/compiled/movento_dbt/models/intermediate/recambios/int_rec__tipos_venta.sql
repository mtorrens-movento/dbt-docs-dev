

-- Tipos de venta de almacen con su canal de recambios (se relaciona por tpo_venta).
-- Junta el diccionario de tipo de venta y el maestro de canales de recambios, con el
-- canal y su agrupacion (TALLER, EXTERIOR...).
--
-- El diccionario tiene vigencias: algunos tipos de venta cambiaron de canal en 2019.
-- Se toma siempre la version vigente, para que tpo_venta sea clave unica. Las ventas
-- disponibles empiezan en 2025, asi que no cambia ningun dato actual.

WITH diccionario AS (
    SELECT
        tipo_venta,
        id_canal_venta,
        ROW_NUMBER() OVER (PARTITION BY tipo_venta ORDER BY fec_ini DESC) AS rn
    FROM [wh_silver].[stg_shp_mdm].[dic_rec_tipo_venta_canal_venta]
    WHERE fec_fin IS NULL OR fec_fin >= CAST(GETDATE() AS DATE)
)

SELECT
    d.tipo_venta AS tpo_venta,
    d.id_canal_venta AS id_canal,
    m.canal_venta AS nom_canal,
    m.id_agrup_canal AS id_agrupacion_canal,
    m.des_agrup_canal AS nom_agrupacion_canal
FROM diccionario d
LEFT JOIN [wh_silver].[stg_shp_mdm].[rec_canales_venta] m
    ON m.id_canal_venta = d.id_canal_venta
WHERE d.rn = 1