

-- Dimension de tipos de mano de obra para facts_or_mo (se relaciona por tpo_mano_obra).
-- La logica vive en int_pv__tipos_mo.

SELECT
    tpo_mano_obra,
    id_servicio,
    nom_servicio,
    ind_hora_facturada,
    ind_no_contabiliza
FROM [wh_silver].[int_posventa].[tipos_mo]