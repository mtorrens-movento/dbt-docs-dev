
    
    

with child as (
    select id_ven_org as from_field
    from [wh_silver].[stg_shp_mdm].[dic_com_vendedores_quiter_org]
    where id_ven_org is not null
),

parent as (
    select id_vendedor as to_field
    from [wh_silver].[stg_shp_mdm].[com_vendedores]
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


