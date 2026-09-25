
    
    

select
    id_persona as unique_field,
    count(*) as n_records

from [wh_silver].[stg_qbi].[personasbi]
where id_persona is not null
group by id_persona
having count(*) > 1


