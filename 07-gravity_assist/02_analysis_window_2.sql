-- the hard way
UPDATE
      flybys
SET
      start_time = (
            SELECT
                  min(time_stamp)
            FROM
                  flyby_altitudes
            WHERE
                  flybys.time_stamp::date = flyby_altitudes.time_stamp::date
                  AND altitude < flybys.target_altitude + 0.75
                  AND altitude > flybys.target_altitude - 0.75);

UPDATE
      flybys
SET
      end_time = (
            SELECT
                  max(time_stamp)
            FROM
                  flyby_altitudes
            WHERE
                  flybys.time_stamp::date = flyby_altitudes.time_stamp::date
                  AND altitude < flybys.target_altitude + 0.75
                  AND altitude > flybys.target_altitude - 0.75);

-- BOOM. Trouble...
SELECT
      *
FROM
      flyby_altitudes
WHERE
      time_stamp::date = '2005-02-17'
      AND altitude BETWEEN 1200 AND 1500
ORDER BY
      time_stamp;

