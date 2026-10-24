-- SQL dialect: MySQL 8.0+
-- Assumption: leads.lead_id identifies a lead. Duplicate lead rows are deduplicated by lead_id.

-- SQL 1: For every day in September 2025, report unique leads attempted,
-- total outbound calls, and connected outbound calls. Calls for IDs absent
-- from the leads table are excluded.
WITH RECURSIVE calendar AS (
    SELECT DATE('2025-09-01') AS report_date
    UNION ALL
    SELECT DATE_ADD(report_date, INTERVAL 1 DAY)
    FROM calendar
    WHERE report_date < DATE('2025-09-30')
), valid_leads AS (
    SELECT DISTINCT lead_id
    FROM leads
), daily_calls AS (
    SELECT
        DATE(c.dialled_at) AS report_date,
        COUNT(DISTINCT c.lead_id) AS leads_attempted,
        COUNT(*) AS total_outbound_calls,
        SUM(CASE WHEN c.call_duration_ms > 0 THEN 1 ELSE 0 END) AS connected_calls
    FROM call_logs c
    INNER JOIN valid_leads l ON l.lead_id = c.lead_id
    WHERE c.dialled_at >= '2025-09-01'
      AND c.dialled_at <  '2025-10-01'
      AND c.call_type LIKE 'outbound%'
    GROUP BY DATE(c.dialled_at)
)
SELECT
    cal.report_date,
    COALESCE(dc.leads_attempted, 0) AS leads_attempted,
    COALESCE(dc.total_outbound_calls, 0) AS total_outbound_calls,
    COALESCE(dc.connected_calls, 0) AS connected_calls
FROM calendar cal
LEFT JOIN daily_calls dc ON dc.report_date = cal.report_date
ORDER BY cal.report_date;


-- SQL 2: For every day in September 2025, count agents with more than
-- 10 outbound calls that day. Agents are identified by agent_email.
WITH RECURSIVE calendar AS (
    SELECT DATE('2025-09-01') AS report_date
    UNION ALL
    SELECT DATE_ADD(report_date, INTERVAL 1 DAY)
    FROM calendar
    WHERE report_date < DATE('2025-09-30')
), qualifying_agents AS (
    SELECT
        DATE(dialled_at) AS report_date,
        agent_email
    FROM call_logs
    WHERE dialled_at >= '2025-09-01'
      AND dialled_at <  '2025-10-01'
      AND call_type LIKE 'outbound%'
      AND agent_email IS NOT NULL
    GROUP BY DATE(dialled_at), agent_email
    HAVING COUNT(*) > 10
)
SELECT
    cal.report_date,
    COUNT(qa.agent_email) AS agents_over_10_outbound_calls
FROM calendar cal
LEFT JOIN qualifying_agents qa ON qa.report_date = cal.report_date
GROUP BY cal.report_date
ORDER BY cal.report_date;


-- SQL 3: By lead-created month and CD Bucket, count unique leads and how
-- many have a qualified_date, login_date, and disbursal_date.
-- Stage dates may fall in later months; this query is a created-lead cohort.
WITH deduplicated_leads AS (
    SELECT
        lead_id,
        created_at,
        cd_bucket,
        qualified_date,
        login_date,
        disbursal_date,
        ROW_NUMBER() OVER (
            PARTITION BY lead_id
            ORDER BY created_at, lead_id
        ) AS rn
    FROM leads
)
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS lead_created_month,
    cd_bucket,
    COUNT(*) AS lead_count,
    SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END) AS qualified_leads,
    SUM(CASE WHEN login_date IS NOT NULL THEN 1 ELSE 0 END) AS logged_in_leads,
    SUM(CASE WHEN disbursal_date IS NOT NULL THEN 1 ELSE 0 END) AS disbursed_leads
FROM deduplicated_leads
WHERE rn = 1
GROUP BY DATE_FORMAT(created_at, '%Y-%m'), cd_bucket
ORDER BY lead_created_month, cd_bucket;
