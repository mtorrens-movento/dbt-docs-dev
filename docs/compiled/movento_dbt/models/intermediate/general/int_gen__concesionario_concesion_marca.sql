

-- Marca contable final por concesionario, vigencia del diccionario y marca contable de la
-- linea. Por defecto la marca contable es la concesion. Actividad RA (Auser): 10 y 11 se
-- mantienen, resto a 10. Centro 421 (XPE): 95 se mantiene, resto a 94.

with base as (
    select
        c.id_concesionario,
        c.id_empresa,
        emp.cat_actividad,
        d.id_reg_concesion,
        d.nom_concesion,
        d.fec_ini,
        d.fec_fin,
        m.cod_marca as cod_marca_contable
    from [wh_silver].[stg_shp_mdm].[dic_com_con_concesion] as d
    join [wh_silver].[stg_qbi].[concesionarios] as c
        on c.id_concesionario = d.id_concesionario
    left join [wh_silver].[stg_qbi].[empresas] as emp
        on emp.id_empresa = c.id_empresa
    cross join [wh_silver].[int_general].[marcas] as m
),

marca as (
    select
        b.*,
        case
            when b.cat_actividad = 'RA' then case when b.cod_marca_contable in (10, 11) then b.cod_marca_contable else 10 end
            when b.id_concesionario in ('420', '422') then case when b.cod_marca_contable = 95 then 95 else 94 end
            else b.id_reg_concesion
        end as id_marca_concesion_marca,
        case when b.cat_actividad = 'RA' or b.id_concesionario in ('420', '422') then 1 else 0 end as ind_marca_propia
    from base as b
)

select
    ma.id_concesionario,
    ma.id_reg_concesion,
    ma.nom_concesion,
    ma.fec_ini,
    ma.fec_fin,
    ma.cod_marca_contable,
    ma.id_marca_concesion_marca,
    case
        when ma.ind_marca_propia = 1 then coalesce(mf.nom_marca, ma.nom_concesion)
        else ma.nom_concesion
    end as nom_marca_concesion_marca,
    cast(ma.ind_marca_propia as bit) as ind_marca_propia
from marca as ma
left join [wh_silver].[int_general].[marcas] as mf
    on mf.cod_marca = ma.id_marca_concesion_marca