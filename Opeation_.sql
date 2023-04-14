/*SELECT * FROM operation.job_data;
SELECT * FROM operation.email_events;
SELECT * FROM operation.events;
SELECT * FROM operation.users;


Calculate the number of jobs reviewed per hour per day for November 2020?*/
SELECT ds AS Dates, ROUND((COUNT(job_id) / SUM(time_spent)) * 3600) AS `Jobs Reviewed per Hour per Day`
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY ds;


/*Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7*/

SELECT ROUND(COUNT(event)/SUM(time_spent), 2) AS `Weekly Throughput`
FROM job_data;

SELECT ds AS Dates, ROUND(COUNT(event)/SUM(time_spent),2) AS "Daily Throughput"
FROM job_data
GROUP BY ds
ORDER BY ds;

/*Calculate the percentage share of each language in the last 30 days?
SELECT language AS Languages,ROUND(100*COUNT(*)/total,2) AS Percentage
FROM job_data
CROSS JOIN (SELECT COUNT(*)AS total FROM job_data) sub
GROUP BY language;*/

/*Display duplicates from the Table*/
SELECT actor_id, COUNT(*) AS Duplicates
FROM job_data
GROUP BY actor_id
HAVING COUNT(*) > 1;

/*Calculating the weekly user engagement?*/
SELECT DATE_FORMAT(e.occurred_at, '%Y-%U-1') AS week_start_date,
       COUNT(DISTINCT e.user_id) AS weekly_active_users
FROM events e 
WHERE e.event_type = 'engagement' AND e.event_name = 'login'
GROUP BY week_start_date
ORDER BY week_start_date;

/*Calculating the user growth for product?*/

SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(DISTINCT user_id) AS user_count
FROM users
GROUP BY month
ORDER BY month ASC;

/* Calculate the weekly engagement per device? */

SELECT 
  device,
  DATE_FORMAT(occurred_at, '%x-%v') AS week,
  COUNT(DISTINCT user_id) AS weekly_engagement
FROM 
  events
GROUP BY 
  device, week;
  

/* Calculate the email engagement metrics? */
SELECT 
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(CASE WHEN action = 'email_open' THEN user_id END) AS email_opens,
    COUNT(CASE WHEN action = 'email_clickthrough' THEN user_id END) AS email_clickthroughs,
    COUNT(CASE WHEN action IN ('email_open', 'email_clickthrough', 'conversion', 'unsubscribe') THEN user_id END) AS engaged_users,
    COUNT(CASE WHEN action IN ('email_open', 'email_clickthrough', 'conversion') THEN user_id END) AS converted_users,
    COUNT(CASE WHEN action IN ('email_open', 'email_clickthrough') THEN user_id END) AS clicked_users,
    COUNT(CASE WHEN action = 'sent_weekly_digest' THEN user_id END) AS sent_weekly_digests
FROM email_events;

/*Most commonly performed events by users in the events table? */

SELECT event_name, COUNT(*) AS event_count
FROM operation.events
GROUP BY event_name
ORDER BY event_count DESC;

/*Average time spent on jobs by language in the job_data table?*/
SELECT language, AVG(time_spent) AS avg_time_spent
FROM operation.job_data
GROUP BY language;


/*How many users in the users table have activated their account?*/

SELECT COUNT(*) AS activated_users
FROM operation.users
WHERE activated_at IS NOT NULL;

/*Most common user action in the email_events table?*/

SELECT action, COUNT(*) AS action_count
FROM operation.email_events
GROUP BY action
ORDER BY action_count DESC;

 /*Unique users have performed an event in the events table?*/
 SELECT COUNT(DISTINCT user_id) AS unique_users
FROM operation.events;



