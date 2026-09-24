

with intervenciones as (

    select
        c.id_marca,
        c.id_tipo_intervencion
    from [wh_silver].[int_posventa].[cargos_tipo_intervencion] as c
    inner join [wh_silver].[int_posventa].[pasos_cargo_collapsed] as p
        on p.id_orden_reparacion = c.id_orden_reparacion
       and p.id_cargo = c.id_cargo
    where p.fec_cierre_or >= dateadd(month, -12, cast(getdate() as date))
      and c.id_marca is not null

),

por_marca as (

    select
        id_marca,
        count(*) as ud_intervenciones_total,
        sum(case when id_tipo_intervencion = 2 then 1 else 0 end)
            as ud_intervenciones_tipo
    from intervenciones
    group by id_marca

)

select
    id_marca,
    ud_intervenciones_total,
    ud_intervenciones_tipo,
    cast(ud_intervenciones_tipo * 1.0 / nullif(ud_intervenciones_total, 0) as decimal(9, 4))
        as rat_tipo_sobre_total
from por_marca
where ud_intervenciones_tipo * 1.0 / nullif(ud_intervenciones_total, 0) < 0.05

