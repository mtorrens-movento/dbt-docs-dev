

-- Tabla de hechos de taller a nivel de OR (7 digitos), para el ciclo de reparacion.
-- Solo entran las OR con todos los cargos cerrados, y se asignan al mes de cierre.
--
-- Cada fase se mide en dias laborables de 11 horas, de lunes a viernes sin festivos
-- nacionales (macro dias_laborables), y queda a nulo si falta alguno de sus dos
-- instantes, si el fin es anterior al inicio o si dura mas de 60 dias naturales. Asi
-- cada fase se promedia por separado sobre las OR en que es valida. El tiempo de ciclo
-- no se guarda: es la suma de los promedios de las fases I, II y III, y se calcula
-- como medida en el modelo semantico. La fase IV se muestra aparte.
--
-- cat_seccion_or agrupa la OR segun la seccion de sus cargos: MECANICA si todos son de
-- mecanica, CARROCERIA si todos son de carroceria y MIXTA si tiene de las dos. Los
-- cargos de otras secciones no cuentan para decidirla.





WITH calendario AS (
    SELECT
        fecha,
        CASE WHEN es_fin_semana = 0 AND es_festivo = 0 THEN 1 ELSE 0 END AS ind_laborable,
        SUM(CASE WHEN es_fin_semana = 0 AND es_festivo = 0 THEN 1 ELSE 0 END)
            OVER (ORDER BY fecha ROWS UNBOUNDED PRECEDING) AS num_laborables_acum
    FROM [wh_gold].[general].[dim_fecha]
),

seccion_or AS (
    SELECT
        c.id_orden_reparacion,
        CASE
            WHEN MAX(CASE WHEN t.nom_seccion = 'MECANICA' THEN 1 ELSE 0 END) = 1
             AND MAX(CASE WHEN t.nom_seccion = 'CARROCERIA' THEN 1 ELSE 0 END) = 1
                THEN 'MIXTA'
            WHEN MAX(CASE WHEN t.nom_seccion = 'MECANICA' THEN 1 ELSE 0 END) = 1
                THEN 'MECANICA'
            WHEN MAX(CASE WHEN t.nom_seccion = 'CARROCERIA' THEN 1 ELSE 0 END) = 1
                THEN 'CARROCERIA'
        END AS cat_seccion_or
    FROM [wh_silver].[int_posventa].[pasos_cargo_collapsed] c
    LEFT JOIN [wh_gold].[posventa].[dim_tipos_or] t
        ON t.tpo_or = c.tpo_or
    GROUP BY c.id_orden_reparacion
)

SELECT
    o.id_orden_reparacion,

    CAST(CONVERT(CHAR(8), o.fec_apertura_or, 112) AS INT) AS id_fecha_apertura,
    CAST(CONVERT(CHAR(8), o.fec_entrega_vehiculo, 112) AS INT) AS id_fecha_entrega,
    CAST(CONVERT(CHAR(8), o.max_fecha_cierre, 112) AS INT) AS id_fecha_cierre,

    o.id_taller,
    o.id_vehiculo,
    o.cod_marca,
    o.num_cargos,
    s.cat_seccion_or,

    o.tst_apertura,
    o.tst_primer_fichaje,
    o.tst_ultimo_fichaje,
    o.tst_entrega,
    o.tst_cierre,

    
    CASE
        WHEN o.tst_apertura IS NOT NULL
         AND o.tst_primer_fichaje IS NOT NULL
         AND o.tst_primer_fichaje >= o.tst_apertura
         AND DATEDIFF(day, o.tst_apertura, o.tst_primer_fichaje) <= 60
        THEN CAST(case
        when o.tst_apertura is null or o.tst_primer_fichaje is null then null
        when cal_apertura.num_laborables_acum is null or cal_primer_fichaje.num_laborables_acum is null then null
        when cast(o.tst_apertura as date) = cast(o.tst_primer_fichaje as date) then
            case when cal_apertura.ind_laborable = 1 then
                case
                    when (case when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) < 1140 then datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_apertura as date) as datetime2(0)), o.tst_apertura) > 480 then datediff(minute, cast(cast(o.tst_apertura as date) as datetime2(0)), o.tst_apertura) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) < 1140 then datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_apertura as date) as datetime2(0)), o.tst_apertura) > 480 then datediff(minute, cast(cast(o.tst_apertura as date) as datetime2(0)), o.tst_apertura) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when cal_apertura.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_apertura as date) as datetime2(0)), o.tst_apertura) <= 480 then 660
                    when datediff(minute, cast(cast(o.tst_apertura as date) as datetime2(0)), o.tst_apertura) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(o.tst_apertura as date) as datetime2(0)), o.tst_apertura)
                end
            else 0 end
            -- dias laborables intermedios
            + 660 * (
                cal_primer_fichaje.num_laborables_acum - cal_primer_fichaje.ind_laborable
                - cal_apertura.num_laborables_acum
            )
            -- ultimo dia
            + case when cal_primer_fichaje.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) >= 1140 then 660
                    when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) <= 480 then 0
                    else datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_preparacion,
    
    CASE
        WHEN o.tst_primer_fichaje IS NOT NULL
         AND o.tst_ultimo_fichaje IS NOT NULL
         AND o.tst_ultimo_fichaje >= o.tst_primer_fichaje
         AND DATEDIFF(day, o.tst_primer_fichaje, o.tst_ultimo_fichaje) <= 60
        THEN CAST(case
        when o.tst_primer_fichaje is null or o.tst_ultimo_fichaje is null then null
        when cal_primer_fichaje.num_laborables_acum is null or cal_ultimo_fichaje.num_laborables_acum is null then null
        when cast(o.tst_primer_fichaje as date) = cast(o.tst_ultimo_fichaje as date) then
            case when cal_primer_fichaje.ind_laborable = 1 then
                case
                    when (case when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) < 1140 then datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) > 480 then datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) < 1140 then datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) > 480 then datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when cal_primer_fichaje.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) <= 480 then 660
                    when datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(o.tst_primer_fichaje as date) as datetime2(0)), o.tst_primer_fichaje)
                end
            else 0 end
            -- dias laborables intermedios
            + 660 * (
                cal_ultimo_fichaje.num_laborables_acum - cal_ultimo_fichaje.ind_laborable
                - cal_primer_fichaje.num_laborables_acum
            )
            -- ultimo dia
            + case when cal_ultimo_fichaje.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) >= 1140 then 660
                    when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) <= 480 then 0
                    else datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_reparacion,
    
    CASE
        WHEN o.tst_ultimo_fichaje IS NOT NULL
         AND o.tst_entrega IS NOT NULL
         AND o.tst_entrega >= o.tst_ultimo_fichaje
         AND DATEDIFF(day, o.tst_ultimo_fichaje, o.tst_entrega) <= 60
        THEN CAST(case
        when o.tst_ultimo_fichaje is null or o.tst_entrega is null then null
        when cal_ultimo_fichaje.num_laborables_acum is null or cal_entrega.num_laborables_acum is null then null
        when cast(o.tst_ultimo_fichaje as date) = cast(o.tst_entrega as date) then
            case when cal_ultimo_fichaje.ind_laborable = 1 then
                case
                    when (case when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) < 1140 then datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) > 480 then datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) < 1140 then datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) > 480 then datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when cal_ultimo_fichaje.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) <= 480 then 660
                    when datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(o.tst_ultimo_fichaje as date) as datetime2(0)), o.tst_ultimo_fichaje)
                end
            else 0 end
            -- dias laborables intermedios
            + 660 * (
                cal_entrega.num_laborables_acum - cal_entrega.ind_laborable
                - cal_ultimo_fichaje.num_laborables_acum
            )
            -- ultimo dia
            + case when cal_entrega.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) >= 1140 then 660
                    when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) <= 480 then 0
                    else datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_entrega,
    
    CASE
        WHEN o.tst_entrega IS NOT NULL
         AND o.tst_cierre IS NOT NULL
         AND o.tst_cierre >= o.tst_entrega
         AND DATEDIFF(day, o.tst_entrega, o.tst_cierre) <= 60
        THEN CAST(case
        when o.tst_entrega is null or o.tst_cierre is null then null
        when cal_entrega.num_laborables_acum is null or cal_cierre.num_laborables_acum is null then null
        when cast(o.tst_entrega as date) = cast(o.tst_cierre as date) then
            case when cal_entrega.ind_laborable = 1 then
                case
                    when (case when datediff(minute, cast(cast(o.tst_cierre as date) as datetime2(0)), o.tst_cierre) < 1140 then datediff(minute, cast(cast(o.tst_cierre as date) as datetime2(0)), o.tst_cierre) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) > 480 then datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(o.tst_cierre as date) as datetime2(0)), o.tst_cierre) < 1140 then datediff(minute, cast(cast(o.tst_cierre as date) as datetime2(0)), o.tst_cierre) else 1140 end)
                       - (case when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) > 480 then datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when cal_entrega.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) <= 480 then 660
                    when datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(o.tst_entrega as date) as datetime2(0)), o.tst_entrega)
                end
            else 0 end
            -- dias laborables intermedios
            + 660 * (
                cal_cierre.num_laborables_acum - cal_cierre.ind_laborable
                - cal_entrega.num_laborables_acum
            )
            -- ultimo dia
            + case when cal_cierre.ind_laborable = 1 then
                case
                    when datediff(minute, cast(cast(o.tst_cierre as date) as datetime2(0)), o.tst_cierre) >= 1140 then 660
                    when datediff(minute, cast(cast(o.tst_cierre as date) as datetime2(0)), o.tst_cierre) <= 480 then 0
                    else datediff(minute, cast(cast(o.tst_cierre as date) as datetime2(0)), o.tst_cierre) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_facturacion,
    

    CAST(
        '2026-10-06 18:31:18'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_posventa].[pasos_referencia_collapsed] o
LEFT JOIN seccion_or s
    ON s.id_orden_reparacion = o.id_orden_reparacion

LEFT JOIN calendario cal_apertura
    ON cal_apertura.fecha = CAST(o.tst_apertura AS DATE)

LEFT JOIN calendario cal_primer_fichaje
    ON cal_primer_fichaje.fecha = CAST(o.tst_primer_fichaje AS DATE)

LEFT JOIN calendario cal_ultimo_fichaje
    ON cal_ultimo_fichaje.fecha = CAST(o.tst_ultimo_fichaje AS DATE)

LEFT JOIN calendario cal_entrega
    ON cal_entrega.fecha = CAST(o.tst_entrega AS DATE)

LEFT JOIN calendario cal_cierre
    ON cal_cierre.fecha = CAST(o.tst_cierre AS DATE)

WHERE o.ind_or_cerrada = 1