

-- Centro de la jerarquia de negocio para los hechos de taller. La empresa, la
-- explotacion y la zona no se copian aqui: salen de dim_empresas a traves de
-- id_empresa, y el almacen de dim_almacenes a traves de id_almacen. La concesion es la
-- vigente hoy en el diccionario taller-concesion.

SELECT
    t.id_taller,
    t.nom_taller,
    t.nom_comercial,
    t.id_marca_iv,
    t.nom_localidad,
    t.des_direccion,
    t.num_latitud_gps,
    t.num_longitud_gps,
    t.des_talleres_mismo_recepcion,
    t.id_empresa,
    t.id_almacen,
    con.id_reg_concesion,
    con.nom_concesion
FROM [wh_silver].[stg_qbi].[talleres] AS t
outer apply (
    select top 1
        d.id_reg_concesion,
        d.nom_concesion
    from [wh_silver].[stg_shp_mdm].[dic_tall_tall_concesion] as d
    where d.id_taller = t.id_taller
      and (d.fec_ini is null or d.fec_ini <= cast(getdate() as date))
      and (d.fec_fin is null or d.fec_fin >= cast(getdate() as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as con