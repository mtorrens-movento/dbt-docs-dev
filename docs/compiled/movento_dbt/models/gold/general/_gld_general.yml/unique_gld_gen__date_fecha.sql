
    
    

select
    fecha as unique_field,
    count(*) as n_records

from [wh_gold].[general].[dim_date]
where fecha is not null
group by fecha
having count(*) > 1


