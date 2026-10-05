

with source_data as (

    select
        
    nullif(ltrim(rtrim(cast([id_grupo_quiter] as varchar(50)))), '')
 as id_grupo_quiter_raw,
        cast([id_sg] as int) as id_sg,
        
    nullif(ltrim(rtrim(cast([name_sg] as varchar(255)))), '')
 as name_sg_raw
    from [lh_bronze].[sharepoint_seguridad].[dic_seg_grupo_sg]

)

select
    id_grupo_quiter_raw as id_grupo_quiter,
    id_sg,
    name_sg_raw as name_sg
from source_data