

WITH date_bounds AS (

    SELECT
        CAST('2000-01-01' AS DATE) AS start_date,
        CAST('2100-12-31' AS DATE) AS end_date

),

digits AS (

    SELECT n
    FROM (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) AS d(n)

),

numbers AS (

    SELECT
        d0.n
        + (d1.n * 10)
        + (d2.n * 100)
        + (d3.n * 1000)
        + (d4.n * 10000) AS n
    FROM digits AS d0
    CROSS JOIN digits AS d1
    CROSS JOIN digits AS d2
    CROSS JOIN digits AS d3
    CROSS JOIN digits AS d4

),

calendar AS (

    SELECT
        CAST(DATEADD(DAY, n.n, b.start_date) AS DATE) AS calendar_date
    FROM numbers AS n
    CROSS JOIN date_bounds AS b
    WHERE n.n <= DATEDIFF(DAY, b.start_date, b.end_date)

),

-- Viernes Santo de cada año: domingo de Pascua (algoritmo de Meeus/Butcher) menos 2 días
viernes_santo AS (

    SELECT
        y.anio,
        DATEADD(DAY, -2, DATEFROMPARTS(
            y.anio,
            (h + l - 7 * m + 114) / 31,
            (h + l - 7 * m + 114) % 31 + 1
        )) AS fecha_viernes_santo
    FROM (SELECT DISTINCT YEAR(calendar_date) AS anio FROM calendar) AS y
    CROSS APPLY (SELECT y.anio % 19 AS a, y.anio / 100 AS b, y.anio % 100 AS c) AS s1
    CROSS APPLY (SELECT (19 * a + b - b / 4 - (b - (b + 8) / 25 + 1) / 3 + 15) % 30 AS h) AS s2
    CROSS APPLY (SELECT (32 + 2 * (b % 4) + 2 * (c / 4) - h - c % 4) % 7 AS l) AS s3
    CROSS APPLY (SELECT (a + 11 * h + 22 * l) / 451 AS m) AS s4

)

SELECT
    CAST(CONVERT(CHAR(8), calendar_date, 112) AS INT) AS id_fecha,
    calendar_date AS fecha,
    YEAR(calendar_date) AS anio,
    DATEPART(QUARTER, calendar_date) AS numero_trimestre,
    CONCAT('T', DATEPART(QUARTER, calendar_date)) AS trimestre,
    MONTH(calendar_date) AS numero_mes,
    CASE MONTH(calendar_date)
        WHEN 1 THEN 'Enero'
        WHEN 2 THEN 'Febrero'
        WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Mayo'
        WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre'
        WHEN 11 THEN 'Noviembre'
        WHEN 12 THEN 'Diciembre'
    END AS mes,
    (YEAR(calendar_date) * 100) + MONTH(calendar_date) AS id_anio_mes,
    CONCAT(
        YEAR(calendar_date),
        '-',
        RIGHT(CONCAT('0', MONTH(calendar_date)), 2)
    ) AS anio_mes,
    DAY(calendar_date) AS dia_mes,
    (DATEDIFF(DAY, CAST('19000101' AS DATE), calendar_date) % 7) + 1 AS numero_dia_semana,
    CASE (DATEDIFF(DAY, CAST('19000101' AS DATE), calendar_date) % 7) + 1
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END AS dia_semana,
    DATEPART(ISO_WEEK, calendar_date) AS numero_semana_iso,
    CASE
        WHEN (DATEDIFF(DAY, CAST('19000101' AS DATE), calendar_date) % 7) + 1 IN (6, 7)
            THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END AS es_fin_semana,
    -- Festivos nacionales de España (fecha fija + Viernes Santo). Sin autonómicos ni locales.
    CASE
        WHEN MONTH(calendar_date) * 100 + DAY(calendar_date)
             IN (101, 106, 501, 815, 1012, 1101, 1206, 1208, 1225)
          OR calendar_date = vs.fecha_viernes_santo
            THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END AS es_festivo
FROM calendar
INNER JOIN viernes_santo AS vs
    ON vs.anio = YEAR(calendar_date)