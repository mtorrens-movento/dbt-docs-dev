

with usuarios_validos as (

    select
        u.alias,
        u.cat_grupo
    from [wh_gold].[general].[users_info] u
    where u.fec_baja is null
      and u.alias is not null
      and exists (
            select 1
            from [wh_silver].[dbo].[dic_seg_grupo_sg] sg
            where sg.id_grupo_quiter = u.cat_grupo
      )

)

select
    u.alias,
    sg.name_sg as grupseguretat,
    case
        when u.cat_grupo = sg.id_grupo_quiter then 1
        else 0
    end as pertany
from usuarios_validos u
cross join [wh_silver].[dbo].[dic_seg_grupo_sg] sg