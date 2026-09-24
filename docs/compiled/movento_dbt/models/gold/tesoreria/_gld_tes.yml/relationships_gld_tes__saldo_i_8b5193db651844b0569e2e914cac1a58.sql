
    
    

with child as (
    select company_code as from_field
    from [wh_gold].[tesoreria].[facts_saldo_inicial]
    where company_code is not null
),

parent as (
    select id_empresa as to_field
    from [wh_gold].[general].[dim_empresas]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


