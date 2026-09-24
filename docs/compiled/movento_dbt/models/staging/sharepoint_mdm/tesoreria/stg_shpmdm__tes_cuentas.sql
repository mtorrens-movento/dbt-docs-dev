

with source_data as (
	select
		
    nullif(ltrim(rtrim(cast([Cuenta Código] as varchar(100)))), '')
 as cuenta_codigo_raw,
		
    nullif(ltrim(rtrim(cast([Compañía] as varchar(100)))), '')
 as empresa_raw,
		
    nullif(ltrim(rtrim(cast([Banco] as varchar(100)))), '')
 as banco_raw
	from [lh_bronze].[sharepoint_mdm].[m_tes_cuentas]
),

typed as (
	select
		cuenta_codigo_raw as id_cuenta,
		
    

    
        try_cast((
    case
        when empresa_raw is null then null
        when upper(left(empresa_raw, 1)) = upper('Q')
            then nullif(substring(empresa_raw, 2, len(empresa_raw)), '')
        else empresa_raw
    end
    ) as int)
    
 as id_empresa,
		try_cast(banco_raw as int) as id_banco
	from source_data
)

select
    -- El maestro llega con 45.952 filas para 140 cuentas: la hoja del Excel
    -- acumula un extracto en vez de la lista de cuentas. Cada cuenta repite
    -- siempre la misma empresa y el mismo banco (cero combinaciones en
    -- conflicto), asi que el distinct devuelve las 140 sin decidir nada. Sin
    -- el, dim_cuentas queda con la clave duplicada y no admite una relacion
    -- uno a muchos en el modelo semantico.
    distinct *
from typed