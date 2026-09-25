
    
    

select
    alias as unique_field,
    count(*) as n_records

from [wh_silver].[stg_qbi].[personasbi]
where alias is not null
group by alias
having count(*) > 1


