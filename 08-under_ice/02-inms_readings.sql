-- load up a new schema for instrument data
DROP SCHEMA IF EXISTS inms CASCADE;

CREATE SCHEMA inms;

-- move chem data in there
ALTER TABLE chem_data SET SCHEMA inms;

-- create the inms. readings table
SELECT
sclk::timestamp AS time_stamp,
source::text,
mass_table,
alt_t::numeric(9, 2) AS altitude,
mass_per_charge::numeric(6, 3),
p_energy::numeric(7, 3),
pythag (sc_vel_t_scx::numeric, sc_vel_t_scy::numeric, sc_vel_t_scz::numeric) AS relative_speed,
c1counts::integer AS high_counts,
c2counts::integer AS low_counts INTO inms.readings
FROM
  import.inms
ORDER BY
  time_stamp;

ALTER TABLE inms.readings
  ADD id serial PRIMARY KEY;

-- add an FK to the flybys
ALTER TABLE inms.readings
  ADD flyby_id int REFERENCES flybys (id);

UPDATE
  inms.readings
SET
  flyby_id = flybys.id
FROM
  flybys
WHERE
  flybys.date = inms.readings.time_stamp::date;

