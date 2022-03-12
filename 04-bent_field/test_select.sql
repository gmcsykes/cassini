select title, description, event
from enceladus_events where date = '2005-03-09'::DATE
and event LIKE '%closest%';

select date_part('year',date),
to_char(time_stamp, 'DDD')
from enceladus_events
where event like '%closest%';

SELECT 
    (sclk::timestamp) as time_stamp,
    alt_t::numeric(10,3) as altitude
from import.inms
where target='ENCELADUS'
and alt_t is not NULL ;
