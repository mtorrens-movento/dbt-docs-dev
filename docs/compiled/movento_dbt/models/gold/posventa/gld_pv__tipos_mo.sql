

-- Dimension de tipos de mano de obra para facts_or_mo (se relaciona por tpo_mano_obra).
-- Junta el diccionario de tipo de MO a servicio de taller, en su version vigente, con
-- el maestro de servicios.
--
-- ind_hora_facturada marca los tipos de MO cuyas horas e importes cuentan en las horas
-- facturadas y en la cifra de negocio de mano de obra: los servicios de mano de obra de
-- mecanica y carroceria, propios y subcontratados. Mientras el maestro de servicios no
-- tenga este indicador, la lista de servicios se fija aqui.



WITH diccionario AS (
    SELECT
        tipo_mo,
        id_servicio_taller,
        ROW_NUMBER() OVER (PARTITION BY tipo_mo ORDER BY fec_ini DESC) AS rn
    FROM [wh_silver].[stg_shp_mdm].[dic_tall_tipo_mo_servicio]
    WHERE fec_fin IS NULL OR fec_fin >= CAST(GETDATE() AS DATE)
)

SELECT
    d.tipo_mo AS tpo_mano_obra,
    d.id_servicio_taller AS id_servicio,
    s.desc_servicio_taller AS nom_servicio,
    CASE
        WHEN d.id_servicio_taller IN (7, 8, 36, 38, 39) THEN 1
        ELSE 0
    END AS ind_hora_facturada,
    CAST(s.no_contabiliza AS INT) AS ind_no_contabiliza
FROM diccionario d
LEFT JOIN [wh_silver].[stg_shp_mdm].[tall_servicios_taller] s
    ON s.id_servicio_taller = d.id_servicio_taller
WHERE d.rn = 1