/* job reviewed per hour per day */
select ds as date, round(3600/a.time_spend_per) as num_job_reviewed
from (
select ds,
case
when count(ds) > 1 then sum(time_spent)/2
when count(ds) = 1 then sum(time_spent) end as time_spend_per
from inbound-guru-354704.operation_analysis.table_operation
group by ds
order by ds) as a

/* percentage share of each language */
select language, (count(language)/8)*100 as percentage_share
from `inbound-guru-354704.operation_analysis.table_operation`
group by language
order by language desc

/* to display if any duplicate row is present */
select job_id, actor_id, count(*)
from `inbound-guru-354704.operation_analysis.table_operation`
group by job_id, actor_id
having count(*) > 1
