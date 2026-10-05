
    
    

select
    id_grupo_quiter as unique_field,
    count(*) as n_records

from [wh_silver].[dbo].[dic_seg_grupo_sg]
where id_grupo_quiter is not null
group by id_grupo_quiter
having count(*) > 1


