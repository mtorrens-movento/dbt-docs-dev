
    
    

select
    bank_code as unique_field,
    count(*) as n_records

from [wh_gold].[tesoreria].[dim_bancos]
where bank_code is not null
group by bank_code
having count(*) > 1


