



with validation_errors as (

    select
        id_empresa,id_banco,id_flujo,fec_saldo,
        count(*) as [n_records]
    from [wh_silver].[int_tesoreria].[saldos]
    where
        1=1
        and 
    not (
        id_empresa is null and 
        id_banco is null and 
        id_flujo is null and 
        fec_saldo is null
        
    )


    
    group by
        id_empresa,id_banco,id_flujo,fec_saldo
    having count(*) > 1

)
select * from validation_errors
