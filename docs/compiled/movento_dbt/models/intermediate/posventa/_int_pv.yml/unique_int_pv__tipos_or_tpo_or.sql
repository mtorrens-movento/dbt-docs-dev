
    
    

select
    tpo_or as unique_field,
    count(*) as n_records

from [wh_silver].[int_posventa].[tipos_or]
where tpo_or is not null
group by tpo_or
having count(*) > 1


