
    
    

with all_values as (

    select
        nom_columna_usada as value_field,
        count(*) as n_records

    from [wh_silver].[int_posventa].[cargos_tipo_intervencion]
    group by nom_columna_usada

)

select *
from all_values
where value_field not in (
    'ARTICULO','FAM_APRO','FAMILIA_ART','GRUPO'
)


