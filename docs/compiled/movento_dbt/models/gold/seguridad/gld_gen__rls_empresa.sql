

WITH users AS (

    SELECT DISTINCT
        id_usuario,
        eml_persona AS correo,
        alias
    FROM [wh_gold].[general].[users_info]
    WHERE id_usuario IS NOT NULL

),

company_master AS (

    SELECT DISTINCT
        id_empresa
    FROM [wh_gold].[general].[dim_empresas]
    WHERE id_empresa IS NOT NULL

),

base_attributes AS (

    SELECT DISTINCT
        id_usuario,
        try_cast(id_valor_rls AS int) AS id_empresa
    FROM [wh_silver].[int_seguridad].[atributos_usuarios_rls]
    WHERE cat_fichero_objeto = 'FMEMPCG'

),

explicit_company_scope AS (

    SELECT DISTINCT
        a.id_usuario,
        m.id_empresa
    FROM base_attributes AS a
    INNER JOIN company_master AS m
        ON a.id_empresa = m.id_empresa

),

expanded_company_scope AS (

    SELECT DISTINCT
        u.id_usuario,
        u.correo,
        u.alias,
        m.id_empresa
    FROM users AS u
    CROSS JOIN company_master AS m
    WHERE NOT EXISTS (
        SELECT 1
        FROM explicit_company_scope AS e
        WHERE e.id_usuario = u.id_usuario
    )

),

company_attributes AS (

    SELECT
        u.id_usuario,
        u.correo,
        u.alias,
        e.id_empresa
    FROM users AS u
    INNER JOIN explicit_company_scope AS e
        ON u.id_usuario = e.id_usuario

    UNION ALL

    SELECT
        e.id_usuario,
        e.correo,
        e.alias,
        e.id_empresa
    FROM expanded_company_scope AS e

)

SELECT DISTINCT
    c.id_usuario,
    c.correo,
    c.alias,
    c.id_empresa
FROM company_attributes AS c