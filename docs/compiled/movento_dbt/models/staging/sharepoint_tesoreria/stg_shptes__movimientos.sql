

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([Estado] as varchar(100)))), '')
 as estado_raw,
		
    nullif(ltrim(rtrim(cast([Cuenta Código] as varchar(100)))), '')
 as cuenta_codigo_raw,
		
    nullif(ltrim(rtrim(cast([Flujo Código] as varchar(100)))), '')
 as flujo_codigo_raw,
		
    nullif(ltrim(rtrim(cast([C. Presupuestario] as varchar(100)))), '')
 as centro_presupuestario_raw,
		
    nullif(ltrim(rtrim(cast([Fecha de operación] as varchar(100)))), '')
 as fecha_operacion_raw,
		
    nullif(ltrim(rtrim(cast([Fecha valor] as varchar(100)))), '')
 as fecha_valor_raw,
		[Importe de contravalor] as importe_contravalor_raw,
		
    nullif(ltrim(rtrim(cast([Divisa Código] as varchar(20)))), '')
 as divisa_codigo_raw,
		
    nullif(ltrim(rtrim(cast([Sentido] as varchar(10)))), '')
 as sentido_raw,
		
    nullif(ltrim(rtrim(cast([Descripción] as varchar(500)))), '')
 as descripcion_raw,
		
    nullif(ltrim(rtrim(cast([info adicional 1] as varchar(500)))), '')
 as info_adicional_1_raw,
		
    nullif(ltrim(rtrim(cast([info adicional 2] as varchar(500)))), '')
 as info_adicional_2_raw,
		
    nullif(ltrim(rtrim(cast([Info] as varchar(500)))), '')
 as info_raw,
		
    nullif(ltrim(rtrim(cast([Referencia] as varchar(255)))), '')
 as referencia_raw
	from [lh_bronze].[sharepoint_tesoreria].[movimientos]
),

typed as (
	select
		estado_raw as est_movimiento,
		cuenta_codigo_raw as id_cuenta,
		flujo_codigo_raw as id_flujo,
		centro_presupuestario_raw as id_centro_presupuestario,
		
    coalesce(
        try_cast(fecha_operacion_raw as date),
        try_convert(date, fecha_operacion_raw, 103),
        try_convert(date, fecha_operacion_raw, 101)
    )
 as fec_operacion,
		
    coalesce(
        try_cast(fecha_valor_raw as date),
        try_convert(date, fecha_valor_raw, 103),
        try_convert(date, fecha_valor_raw, 101)
    )
 as fec_valor,
		
    try_cast(importe_contravalor_raw as decimal(18, 2))
 as imp_contravalor,
		divisa_codigo_raw as id_divisa,
		sentido_raw as id_sentido,
		
    case
        when 
    try_cast(importe_contravalor_raw as decimal(18, 2))
 is null then null
        when sentido_raw = '-'
            then -1 * 
    try_cast(importe_contravalor_raw as decimal(18, 2))

        else 
    try_cast(importe_contravalor_raw as decimal(18, 2))

    end
 as imp_contravalor_firmado,
		descripcion_raw as des_movimiento,
		info_adicional_1_raw as des_info_adicional_1,
		info_adicional_2_raw as des_info_adicional_2,
		info_raw as des_info,
		referencia_raw as id_referencia
	from source_data
)

select
	*
from typed