

with source_data as (
    select
        
    nullif(ltrim(rtrim(cast([Bank Code] as varchar(100)))), '')
 as bank_code_raw,
        
    nullif(ltrim(rtrim(cast([Bank Desc] as varchar(255)))), '')
 as bank_desc_raw,
        
    nullif(ltrim(rtrim(cast([Company Code] as varchar(100)))), '')
 as empresa_code_raw,
        
    nullif(ltrim(rtrim(cast([Company Desc] as varchar(255)))), '')
 as empresa_desc_raw,
        
    nullif(ltrim(rtrim(cast([Flow Code] as varchar(100)))), '')
 as flow_code_raw,
        
    nullif(ltrim(rtrim(cast([Date] as varchar(100)))), '')
 as operation_date_raw,
        
    nullif(ltrim(rtrim(cast([Book Date] as varchar(100)))), '')
 as book_date_raw,
        [Signed Amount] as signed_amount_raw,
        [Importe Signo Div Cuenta] as account_amount_raw,
        
    nullif(ltrim(rtrim(cast([Descripción] as varchar(500)))), '')
 as description_raw,
        
    nullif(ltrim(rtrim(cast([Referencia] as varchar(255)))), '')
 as reference_raw,
        
    nullif(ltrim(rtrim(cast([ADD_INFO_1] as varchar(500)))), '')
 as add_info_1_raw,
        
    nullif(ltrim(rtrim(cast([ADD_INFO_2] as varchar(500)))), '')
 as add_info_2_raw,
        
    nullif(ltrim(rtrim(cast([ADD_INFO_3] as varchar(500)))), '')
 as add_info_3_raw,
        
    nullif(ltrim(rtrim(cast([ADD_INFO_4] as varchar(500)))), '')
 as add_info_4_raw
    from [lh_bronze].[sharepoint_tesoreria].[movimientos_pre_07_2026]
),

typed as (
    select
        try_cast(bank_code_raw as int) as id_banco,
        bank_desc_raw as des_banco,
        
    

    
        try_cast((
    case
        when empresa_code_raw is null then null
        when upper(left(empresa_code_raw, 1)) = upper('Q')
            then nullif(substring(empresa_code_raw, 2, len(empresa_code_raw)), '')
        else empresa_code_raw
    end
    ) as int)
    
 as id_empresa,
        empresa_desc_raw as des_empresa,
        flow_code_raw as id_flujo,
        
    coalesce(
        try_cast(operation_date_raw as date),
        try_convert(date, operation_date_raw, 103),
        try_convert(date, operation_date_raw, 101)
    )
 as fec_operacion,
        
    coalesce(
        try_cast(book_date_raw as date),
        try_convert(date, book_date_raw, 103),
        try_convert(date, book_date_raw, 101)
    )
 as fec_valor,
        
    try_cast(signed_amount_raw as decimal(18, 2))
 as imp_movimiento_firmado,
        
    try_cast(account_amount_raw as decimal(18, 2))
 as imp_signo_div_cuenta,
        description_raw as des_movimiento,
        reference_raw as id_referencia,
        add_info_1_raw as des_info_adicional_1,
        add_info_2_raw as des_info_adicional_2,
        add_info_3_raw as des_info_adicional_3,
        add_info_4_raw as des_info_adicional_4
    from source_data
)

select
    *
from typed