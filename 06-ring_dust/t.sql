
select targets.description,
count(3) over (
  partition by targets.description
)
from events
inner join targets 
  on targets.id = target_id;
