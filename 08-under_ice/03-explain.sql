-- how bad will this update be?
EXPLAIN UPDATE
  inms.readings
SET
  flyby_id = flybys.id
FROM
  flybys
WHERE
  flybys.date = inms.readings.time_stamp::date;

-- how about this one?
EXPLAIN UPDATE
  inms.readings
SET
  flyby_id = (
    SELECT
      id
    FROM
      flybys
    WHERE
      date = inms.readings.time_stamp::date
    LIMIT 1);

-- a junction table
DROP TABLE IF EXISTS flyby_readings;

CREATE TABLE flyby_readings (
  reading_id int NOT NULL UNIQUE REFERENCES inms.readings (id),
  flyby_id int NOT NULL REFERENCES flybys (id),
  PRIMARY KEY (reading_id, flyby_id)
);

-- fill it
INSERT INTO flyby_readings (flyby_id, reading_id)
SELECT
  flybys.id,
  inms.readings.id
FROM
  flybys
  INNER JOIN inms.readings ON date_part('year', time_stamp) = flybys.year
    AND date_part('week', time_stamp) = flybys.week;

-- just use an index!
DROP TABLE flyby_readings CASCADE;

CREATE INDEX idx_stamps ON inms.readings (time_stamp)
WHERE
  altitude IS NOT NULL;

