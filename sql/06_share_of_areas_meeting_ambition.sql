-- 06. How many local areas meet the 50% recovery ambition each month?
SELECT
    period_start AS month,
    COUNT(value) AS areas_reporting,
    SUM(CASE WHEN value >= 50 THEN 1 ELSE 0 END) AS areas_meeting_50pct,
    ROUND(100.0 * SUM(CASE WHEN value >= 50 THEN 1 ELSE 0 END) / COUNT(value), 1) AS pct_areas_meeting
FROM tt_monthly
WHERE group_type = 'SubICB'
  AND measure_name = 'Percentage_Recovery'
  AND value IS NOT NULL
GROUP BY period_start
ORDER BY period_start
