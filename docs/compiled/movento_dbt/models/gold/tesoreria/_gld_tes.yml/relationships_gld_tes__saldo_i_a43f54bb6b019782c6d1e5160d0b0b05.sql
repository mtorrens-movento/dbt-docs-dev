
    
    

with child as (
    select bank_code as from_field
    from [wh_gold].[tesoreria].[facts_saldo_inicial]
    where bank_code is not null
),

parent as (
    select bank_code as to_field
    from [wh_gold].[tesoreria].[dim_bancos]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


