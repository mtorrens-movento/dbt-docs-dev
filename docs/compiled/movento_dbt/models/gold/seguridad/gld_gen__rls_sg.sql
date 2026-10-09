

select
    u.alias,
    sg.name_sg as grupseguretat,
    case
        when u.cat_grupo = sg.id_grupo_quiter then 1
        else 0
    end as pertany
from [wh_gold].[general].[users_info] u
cross join [wh_silver].[dbo].[dic_seg_grupo_sg] sg
where u.fec_baja is null
  and u.alias is not null