


WITH dimension_master AS (

    SELECT DISTINCT
        id_concesionario
    FROM [wh_silver].[stg_qbi].[concesionarios]
    WHERE id_concesionario IS NOT NULL

),

dimension_master_by_company AS (

    SELECT DISTINCT
        id_empresa,
        id_concesionario
    FROM [wh_silver].[stg_qbi].[concesionarios]
    WHERE id_empresa IS NOT NULL
      AND id_concesionario IS NOT NULL

),

base_attributes AS (

    SELECT
        id_usuario,
        id_valor_rls AS id_concesionario
    FROM [wh_silver].[int_seguridad].[atributos_usuarios_rls]
    WHERE cat_fichero_objeto = 'FMCONCPT'

),

explicit_attributes AS (

    SELECT DISTINCT
        p.id_usuario,
        m.id_concesionario
    FROM base_attributes AS p
    INNER JOIN dimension_master AS m
        ON p.id_concesionario = m.id_concesionario

),

company_scope AS (

    SELECT DISTINCT
        id_usuario,
        id_empresa
    FROM [wh_gold].[seguridad].[rls_empresa]
    WHERE id_empresa IS NOT NULL

),

company_attributes AS (

    SELECT DISTINCT
        c.id_usuario,
        m.id_concesionario
    FROM company_scope AS c
    INNER JOIN dimension_master_by_company AS m
        ON c.id_empresa = m.id_empresa
    WHERE NOT EXISTS (
        SELECT 1
        FROM explicit_attributes AS e
        WHERE e.id_usuario = c.id_usuario
    )

),

unrestricted_attributes AS (

    SELECT DISTINCT
        u.id_usuario,
        m.id_concesionario
    FROM [wh_gold].[general].[users_info] AS u
    CROSS JOIN dimension_master AS m
    WHERE u.id_usuario IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM company_scope AS c
          WHERE c.id_usuario = u.id_usuario
      )
      AND NOT EXISTS (
          SELECT 1
          FROM explicit_attributes AS e
          WHERE e.id_usuario = u.id_usuario
      )

),

rls_attributes AS (

    SELECT
        e.id_usuario,
        e.id_concesionario
    FROM explicit_attributes AS e

    UNION ALL

    SELECT
        f.id_usuario,
        f.id_concesionario
    FROM company_attributes AS f

    UNION ALL

    SELECT
        a.id_usuario,
        a.id_concesionario
    FROM unrestricted_attributes AS a

),

users AS (

    SELECT DISTINCT
        id_usuario,
        eml_persona AS correo,
        alias
    FROM [wh_gold].[general].[users_info]

)

SELECT DISTINCT
    e.id_usuario,
    u.correo,
    u.alias,
    e.id_concesionario AS id_concesionario
FROM rls_attributes AS e
LEFT JOIN users AS u
    ON e.id_usuario = u.id_usuario
