
    
    

with child as (
    select movement_date_key as from_field
    from [wh_gold].[tesoreria].[facts_saldo_inicial]
    where movement_date_key is not null
),

parent as (
    select id_fecha as to_field
    from [wh_gold].[general].[dim_date]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


