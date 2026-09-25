

with base_attributes as (
    select
        id_usuario,
        cat_fichero_objeto,
        des_valor_atributo,
        aud_dte_snapshot,
        aud_tst_ingestion,
        aud_tst_ultima_actualizacion
    from [wh_silver].[stg_qbi].[atributos_usuarios]
    where cat_atributo = '13'
      and cat_fichero_objeto in ('FMEMPCG', 'FMTAPT', 'FMCONCPT', 'FMALPT')
),

exploded_attributes as (
    select
        b.id_usuario,
        b.cat_fichero_objeto,
        nullif(ltrim(rtrim(s.value)), '') as id_valor_rls,
        b.aud_dte_snapshot,
        b.aud_tst_ingestion,
        b.aud_tst_ultima_actualizacion
    from base_attributes as b
    cross apply string_split(b.des_valor_atributo, ',') as s
)

select
    id_usuario,
    cat_fichero_objeto,
    id_valor_rls,
    aud_dte_snapshot,
    aud_tst_ingestion,
    aud_tst_ultima_actualizacion
from exploded_attributes
where id_valor_rls is not null