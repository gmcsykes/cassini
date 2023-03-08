-- restricting by day
SELECT
    targets.description AS target,
    events.time_stamp,
    event_types.description AS event
FROM
    events
    INNER JOIN event_types ON event_types.id = events.event_type_id
    INNER JOIN targets ON targets.id = events.target_id
WHERE
    events.time_stamp::date = '2005-02-17'
ORDER BY
    events.time_stamp;

-- constrict by Enceladus target
SELECT
    targets.description AS target,
    events.time_stamp,
    event_types.description AS event
FROM
    events
    INNER JOIN event_types ON event_types.id = events.event_type_id
    INNER JOIN targets ON targets.id = events.target_id
WHERE
    events.time_stamp::date = '2005-02-17'
    AND targets.description = 'enceladus'
ORDER BY
    events.time_stamp;

--using the id as filter instead
SELECT
    targets.description AS target,
    events.time_stamp,
    event_types.description AS event
FROM
    events
    INNER JOIN event_types ON event_types.id = events.event_type_id
    INNER JOIN targets ON targets.id = events.target_id
WHERE
    events.time_stamp::date = '2005-02-17'
    AND targets.id = 46
ORDER BY
    events.time_stamp;

