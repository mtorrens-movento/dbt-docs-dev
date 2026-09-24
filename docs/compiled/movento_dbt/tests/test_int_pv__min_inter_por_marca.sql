with marcas as (
    select distinct
        id_marca
    from [wh_silver].[int_posventa].[cargos_tipo_intervencion]
    where id_marca is not null
),

intervenciones_30d as (
    select
        c.id_marca,
        count(*) as total_intervenciones_30d
    from [wh_silver].[int_posventa].[cargos_tipo_intervencion] c
    inner join [wh_silver].[int_posventa].[pasos_cargo_collapsed] p
        on p.id_orden_reparacion = c.id_orden_reparacion
       and p.id_cargo = c.id_cargo
    where p.fec_cierre_or >= dateadd(day, -30, cast(getdate() as date))
      and c.id_marca is not null
    group by c.id_marca
)

select
    m.id_marca,
    coalesce(i.total_intervenciones_30d, 0) as total_intervenciones_30d
from marcas m
left join intervenciones_30d i
    on i.id_marca = m.id_marca
where coalesce(i.total_intervenciones_30d, 0) < 200