

-- Tabla de hechos de taller a nivel de OR (7 digitos), para el ciclo de reparacion.
-- Solo entran las OR con todos los cargos cerrados.
--
-- Cada fase se mide en dias laborables de 11 horas (macro dias_laborables) y queda a
-- nulo si falta alguno de sus dos instantes, si el fin es anterior al inicio o si dura
-- mas de 60 dias naturales. Asi cada fase se promedia por separado sobre las OR en que
-- es valida. El tiempo de ciclo no se guarda: es la suma de los promedios de las
-- fases I, II y III, y se calcula como medida en el modelo semantico.



SELECT
    id_orden_reparacion,

    CAST(CONVERT(CHAR(8), fec_apertura_or, 112) AS INT) AS id_fecha_apertura,
    CAST(CONVERT(CHAR(8), fec_entrega_vehiculo, 112) AS INT) AS id_fecha_entrega,
    CAST(CONVERT(CHAR(8), max_fecha_cierre, 112) AS INT) AS id_fecha_cierre,

    id_taller,
    id_vehiculo,
    cod_marca,
    num_cargos,

    tst_apertura,
    tst_primer_fichaje,
    tst_ultimo_fichaje,
    tst_entrega,
    tst_cierre,

    
    CASE
        WHEN tst_apertura IS NOT NULL
         AND tst_primer_fichaje IS NOT NULL
         AND tst_primer_fichaje >= tst_apertura
         AND DATEDIFF(day, tst_apertura, tst_primer_fichaje) <= 60
        THEN CAST(case
        when tst_apertura is null or tst_primer_fichaje is null then null
        when cast(tst_apertura as date) = cast(tst_primer_fichaje as date) then
            case when datediff(day, cast('1900-01-01' as date), cast(tst_apertura as date)) % 7 < 5 then
                case
                    when (case when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) < 1140 then datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_apertura as date) as datetime2(0)), tst_apertura) > 480 then datediff(minute, cast(cast(tst_apertura as date) as datetime2(0)), tst_apertura) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) < 1140 then datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_apertura as date) as datetime2(0)), tst_apertura) > 480 then datediff(minute, cast(cast(tst_apertura as date) as datetime2(0)), tst_apertura) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when datediff(day, cast('1900-01-01' as date), cast(tst_apertura as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_apertura as date) as datetime2(0)), tst_apertura) <= 480 then 660
                    when datediff(minute, cast(cast(tst_apertura as date) as datetime2(0)), tst_apertura) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(tst_apertura as date) as datetime2(0)), tst_apertura)
                end
            else 0 end
            -- dias laborables intermedios: los de [inicio + 1, fin - 1]
            + 660 * (
                ((datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date)) - 1) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date)) - 1) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date)) - 1) % 7 + 1 else 5 end
                - (((datediff(day, cast('1900-01-01' as date), cast(tst_apertura as date))) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_apertura as date))) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_apertura as date))) % 7 + 1 else 5 end)
            )
            -- ultimo dia
            + case when datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) >= 1140 then 660
                    when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) <= 480 then 0
                    else datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_preparacion,
    
    CASE
        WHEN tst_primer_fichaje IS NOT NULL
         AND tst_ultimo_fichaje IS NOT NULL
         AND tst_ultimo_fichaje >= tst_primer_fichaje
         AND DATEDIFF(day, tst_primer_fichaje, tst_ultimo_fichaje) <= 60
        THEN CAST(case
        when tst_primer_fichaje is null or tst_ultimo_fichaje is null then null
        when cast(tst_primer_fichaje as date) = cast(tst_ultimo_fichaje as date) then
            case when datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date)) % 7 < 5 then
                case
                    when (case when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) < 1140 then datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) > 480 then datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) < 1140 then datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) > 480 then datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) <= 480 then 660
                    when datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(tst_primer_fichaje as date) as datetime2(0)), tst_primer_fichaje)
                end
            else 0 end
            -- dias laborables intermedios: los de [inicio + 1, fin - 1]
            + 660 * (
                ((datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date)) - 1) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date)) - 1) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date)) - 1) % 7 + 1 else 5 end
                - (((datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date))) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date))) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_primer_fichaje as date))) % 7 + 1 else 5 end)
            )
            -- ultimo dia
            + case when datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) >= 1140 then 660
                    when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) <= 480 then 0
                    else datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_reparacion,
    
    CASE
        WHEN tst_ultimo_fichaje IS NOT NULL
         AND tst_entrega IS NOT NULL
         AND tst_entrega >= tst_ultimo_fichaje
         AND DATEDIFF(day, tst_ultimo_fichaje, tst_entrega) <= 60
        THEN CAST(case
        when tst_ultimo_fichaje is null or tst_entrega is null then null
        when cast(tst_ultimo_fichaje as date) = cast(tst_entrega as date) then
            case when datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date)) % 7 < 5 then
                case
                    when (case when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) < 1140 then datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) > 480 then datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) < 1140 then datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) > 480 then datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) <= 480 then 660
                    when datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(tst_ultimo_fichaje as date) as datetime2(0)), tst_ultimo_fichaje)
                end
            else 0 end
            -- dias laborables intermedios: los de [inicio + 1, fin - 1]
            + 660 * (
                ((datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date)) - 1) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date)) - 1) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date)) - 1) % 7 + 1 else 5 end
                - (((datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date))) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date))) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_ultimo_fichaje as date))) % 7 + 1 else 5 end)
            )
            -- ultimo dia
            + case when datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) >= 1140 then 660
                    when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) <= 480 then 0
                    else datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_entrega,
    
    CASE
        WHEN tst_entrega IS NOT NULL
         AND tst_cierre IS NOT NULL
         AND tst_cierre >= tst_entrega
         AND DATEDIFF(day, tst_entrega, tst_cierre) <= 60
        THEN CAST(case
        when tst_entrega is null or tst_cierre is null then null
        when cast(tst_entrega as date) = cast(tst_cierre as date) then
            case when datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date)) % 7 < 5 then
                case
                    when (case when datediff(minute, cast(cast(tst_cierre as date) as datetime2(0)), tst_cierre) < 1140 then datediff(minute, cast(cast(tst_cierre as date) as datetime2(0)), tst_cierre) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) > 480 then datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) else 480 end) > 0
                    then (case when datediff(minute, cast(cast(tst_cierre as date) as datetime2(0)), tst_cierre) < 1140 then datediff(minute, cast(cast(tst_cierre as date) as datetime2(0)), tst_cierre) else 1140 end)
                       - (case when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) > 480 then datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) else 480 end)
                    else 0
                end
            else 0 end / 660.0
        else (
            -- primer dia
            case when datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) <= 480 then 660
                    when datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega) >= 1140 then 0
                    else 1140 - datediff(minute, cast(cast(tst_entrega as date) as datetime2(0)), tst_entrega)
                end
            else 0 end
            -- dias laborables intermedios: los de [inicio + 1, fin - 1]
            + 660 * (
                ((datediff(day, cast('1900-01-01' as date), cast(tst_cierre as date)) - 1) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_cierre as date)) - 1) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_cierre as date)) - 1) % 7 + 1 else 5 end
                - (((datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date))) / 7) * 5 + case when (datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date))) % 7 < 5 then (datediff(day, cast('1900-01-01' as date), cast(tst_entrega as date))) % 7 + 1 else 5 end)
            )
            -- ultimo dia
            + case when datediff(day, cast('1900-01-01' as date), cast(tst_cierre as date)) % 7 < 5 then
                case
                    when datediff(minute, cast(cast(tst_cierre as date) as datetime2(0)), tst_cierre) >= 1140 then 660
                    when datediff(minute, cast(cast(tst_cierre as date) as datetime2(0)), tst_cierre) <= 480 then 0
                    else datediff(minute, cast(cast(tst_cierre as date) as datetime2(0)), tst_cierre) - 480
                end
            else 0 end
        ) / 660.0
    end
 AS DECIMAL(10, 4))
    END AS ud_dias_facturacion,
    

    CAST(
        '2026-09-30 18:04:18'
        AS DATETIME2(0)
    ) AS _gold_load_ts
FROM [wh_silver].[int_posventa].[pasos_referencia_collapsed]
WHERE ind_or_cerrada = 1