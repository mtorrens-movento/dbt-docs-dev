

-- La concesion es la vigente hoy en el diccionario concesionario-concesion.

SELECT
    c.id_concesionario,
    c.nom_concesionario,
    c.nom_completo,
    c.nom_comercial,
    c.des_direccion,
    c.nom_localidad,
    c.tel_telefono,
    c.id_empresa,
    c.nom_empresa,
    c.cod_marca,
    c.des_marca,
    c.id_sucursal,
    con.id_reg_concesion,
    con.nom_concesion
FROM [wh_silver].[stg_qbi].[concesionarios] AS c
outer apply (
    select top 1
        d.id_reg_concesion,
        d.nom_concesion
    from [wh_silver].[stg_shp_mdm].[dic_com_con_concesion] as d
    where d.id_concesionario = c.id_concesionario
      and (d.fec_ini is null or d.fec_ini <= cast(getdate() as date))
      and (d.fec_fin is null or d.fec_fin >= cast(getdate() as date))
    order by
        coalesce(d.fec_ini, cast('1900-01-01' as date)) desc,
        coalesce(d.fec_fin, cast('9999-12-31' as date)) desc
) as con