

select *
from [wh_silver].[stg_qbi].[vehiculos]
where (
    num_bastidor is null
    or 

    len( num_bastidor ) <> 17
)

