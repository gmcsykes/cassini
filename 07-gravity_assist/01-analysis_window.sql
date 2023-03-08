-- make room for new stuff
ALTER TABLE flybys
  ADD speed_kms numeric(10, 3),
  ADD target_altitude numeric(10, 3),
  ADD transit_distance numeric(10, 3);

-- calculate b
SELECT id, altitude,
  (altitude + 252) AS total_altitude --b
FROM
  flybys;

-- calculate b and c
SELECT
  id, altitude,
  (altitude + 252) AS total_altitude,
  --b
  ((altitude + 252) / sind (73)) - 252 AS target_altitude -- c
FROM
  flybys;

-- updating flybys with speed data
UPDATE
  flybys
SET
  target_altitude = ((altitude + 252) / sind (73)) - 252;

UPDATE
  flybys
SET
  transit_distance = ((target_altitude + 252) * sind (17) * 2);

-- getting the timestamps
SELECT
  min(flyby_altitudes.time_stamp)
FROM
  flyby_altitudes
  INNER JOIN flybys ON flybys.time_stamp::date = flyby_altitudes.time_stamp::date
    AND flybys.target_altitude = flyby_altitudes.altitude;
