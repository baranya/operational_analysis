/* active users per week */
select
 extract(isoweek from date) AS week,
 count(distinct user_id) AS users_engaged
from (
 SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 left outer join `inbound-guru-354704.operation_analysis.table_users` as b
 on a.user_id = b.user_id
 union all
 SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 right outer join`inbound-guru-354704.operation_analysis.table_users` as b
 on a.user_id = b.user_id
 where event_type = 'engagement'
 and state = 'active') as c
where '2014-05-01' <= date
 and date < '2014-08-31'
group by week
order by week

/* user growth for product */
select count(distinct user_id) as num_user, state, event_type
from (
SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type,
 event_name,
 location, device, state
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 left outer join `inbound-guru-354704.operation_analysis.table_users` as b
 on a.user_id = b.user_id
 union all
 SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type,
 event_name,
 location, device, state
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 right outer join`inbound-guru-354704.operation_analysis.table_users` as b
 on a.user_id = b.user_id
 
 order by date)
 where state = 'active'
 group by state, event_type

/* weekly retention of users sign-up */
select extract(isoweek from date) AS week,
count(distinct user_id) as num_user, event_type,
event_name
from (
SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type,
 event_name,
 location, device, state
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 left outer join `inbound-guru-354704.operation_analysis.table_users` as b
 on a.user_id = b.user_id
 union all
 SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type,
 event_name,
 location, device, state
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 right outer join`inbound-guru-354704.operation_analysis.table_users` as b
 on a.user_id = b.user_id
 where state = 'active'
 
 order by date) as c
 
 where event_name='complete_signup'
 
 group by week, event_type, event_name
 order by week

/* weekly engagement of users per device */
select extract(isoweek from date) AS week,
count(distinct user_id) as user_engaged, device
from (
SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type,
 event_name,
 location, device, state
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 left outer join `inbound-guru-354704.operation_analysis.table_users` as b
 on a.user_id = b.user_id
 union all
 SELECT
 extract(date from occurred_at) AS date,
 b.user_id,
 event_type,
 event_name,
 location, device, state
 FROM `inbound-guru-354704.operation_analysis.table_event` as a
 right outer join`inbound-guru-354704.operation_analysis.table_users` as b
on a.user_id = b.user_id
 where state = 'active'
 
 order by date) as c
 where device is not null
 group by week, device
 order by week

/* monthly user engagement with email service */
SELECT extract(month from occurred_at) as month,
count(distinct user_id) num_users,
action
FROM `inbound-guru-354704.operation_analysis.table_email`
group by month, action
order by month

/* conversion of the long email service to wide form */
SELECT
 action,
 SUM(IF(month = '5', num_users, NULL)) AS '5',
 SUM(IF(month = '6', num_users, NULL)) AS '6',
 SUM(IF(month = '7', num_users, NULL)) AS '7',
 SUM(IF(month = '8', num_users, NULL)) AS '8'
from email_long
group by action
order by action
