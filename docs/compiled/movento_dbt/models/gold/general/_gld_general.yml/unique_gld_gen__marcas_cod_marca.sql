
    
    

select
    cod_marca as unique_field,
    count(*) as n_records

from [wh_gold].[general].[dim_marcas]
where cod_marca is not null
group by cod_marca
having count(*) > 1


