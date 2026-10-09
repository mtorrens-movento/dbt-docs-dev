

-- Centro de la jerarquia de negocio para los hechos de ventas de almacen. La empresa,
-- la explotacion y la zona salen de dim_empresas a traves de id_empresa. Los almacenes
-- de utillaje (U60, U61...) no tienen empresa en origen. La concesion es la vigente hoy
-- en el diccionario almacen-concesion.

SELECT
    a.id_almacen,
    a.nom_almacen,
    a.nom_localidad,
    a.des_direccion,
    a.id_almacen_consumos,
    a.id_empresa,
    con.id_reg_concesion,
    con.nom_concesion
FROM [wh_silver].[stg_qbi].[almacenes] AS a
outer apply (
    select top 1
        d.id_reg_concesion,
        d.nom_concesion
    from [wh_silver].[stg_shp_mdm].[dic_rec_alm_concesion] as d
    where d.id_almacen = a.id_almacen
      and (d.fec_ini is null or d.fec_ini <= cast(getdate() as date))
      and (d.fec_fin is null or d.fec_fin >= cast(getdate() as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as con