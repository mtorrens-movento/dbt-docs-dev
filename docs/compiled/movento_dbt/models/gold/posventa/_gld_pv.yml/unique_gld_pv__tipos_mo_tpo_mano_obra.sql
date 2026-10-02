
    
    

select
    tpo_mano_obra as unique_field,
    count(*) as n_records

from [wh_gold].[posventa].[dim_tipos_mo]
where tpo_mano_obra is not null
group by tpo_mano_obra
having count(*) > 1


