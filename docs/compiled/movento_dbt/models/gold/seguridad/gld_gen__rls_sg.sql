

select
    u.alias,
    sg.name_sg
from [wh_gold].[general].[users_info] u
inner join [wh_silver].[dbo].[dic_seg_grupo_sg] sg
    on u.cat_grupo = sg.id_grupo_quiter
where u.fec_baja is null
and u.alias is not null