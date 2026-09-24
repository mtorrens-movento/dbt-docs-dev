

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
    END AS es_fin_semana
FROM calendar