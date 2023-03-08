--using a sort-of temp table
DROP TABLE IF EXISTS time_altitudes;

SELECT
  (sclk::timestamp) AS time_stamp,
  alt_t::numeric(9, 2) AS altitude,
  date_part('year', (sclk::timestamp)) AS year,
  date_part('week', (sclk::timestamp))
  week
  INTO time_altitudes
FROM
  import.inms
WHERE
  target = 'ENCELADUS'
  AND alt_t IS NOT NULL;

WITH mins AS (
  SELECT
    min(altitude) AS nadir,
    year, week
  FROM time_altitudes
  GROUP BY year, week
  ORDER BY
    year, week
),
min_times AS (
  SELECT
    mins.*,
    min(time_stamp) AS low_time,
    min(time_stamp) + interval '20 seconds' AS window_end,
    min(time_stamp) - interval '20 seconds' AS window_start
  FROM
    mins
    INNER JOIN time_altitudes ta 
      ON mins.year = ta.year
      AND mins.week = ta.week
      AND mins.nadir = ta.altitude
  GROUP BY mins.week, mins.year, mins.nadir
),
fixed_flybys AS (SELECT
    f.id,
    f.name,
    f.date,
    f.altitude,
    f.speed,
    mt.nadir,
    mt.year,
    mt.week,
    mt.low_time,
    mt.window_start,
    mt.window_end
  FROM
    flybys f
    INNER JOIN min_times mt ON date_part ('year', f.date) = mt.year and
date_part('week', f.date) = mt.week) 