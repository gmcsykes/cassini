-- using the index - it's fast!
SELECT
  *
FROM
  inms.readings
WHERE
  time_stamp > '2015-12-19 17:48:55.275'
and time_stamp < '2015-12-19 17:49:35.275';

-- without hardcoded dates
SELECT
  name,
  mass_per_charge,
  time_stamp,
  inms.readings.altitude
FROM
  inms.readings
  INNER JOIN flybys ON time_stamp >= window_start
    AND time_stamp <= window_end
WHERE
  flybys.id = 4;

-- speed comparison
SELECT
  speed,
  avg(relative_speed)::numeric(9, 1)
FROM
  flybys
  INNER JOIN inms.readings ON time_stamp >= flybys.window_start
    AND time_stamp <= flybys.window_end
GROUP BY
  speed;

