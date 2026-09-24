
    
    

select
    flow_code as unique_field,
    count(*) as n_records

from [wh_gold].[tesoreria].[dim_flujos]
where flow_code is not null
group by flow_code
having count(*) > 1


