-- 04. Recovery rate by NHS region (average of the 13 months)
-- The NHS ambition is that at least 50% of people who finish treatment recover.
SELECT
    REPLACE(org_name1, ' COMMISSIONING REGION', '') AS region,
    ROUND(AVG(CASE WHEN measure_name = 'Percentage_Recovery' THEN value END), 1)              AS avg_recovery_pct,
    ROUND(AVG(CASE WHEN measure_name = 'Percentage_ReliableImprovement' THEN value END), 1)   AS avg_improvement_pct,
    CAST(SUM(CASE WHEN measure_name = 'Count_FinishedCourseTreatment' THEN value END) AS INT) AS total_finished_treatment,
    CASE WHEN AVG(CASE WHEN measure_name = 'Percentage_Recovery' THEN value END) >= 50
         THEN 'Meets 50%' ELSE 'Below 50%' END AS vs_ambition
FROM tt_monthly
WHERE group_type = 'CommissioningRegion'
  AND org_name1 <> 'Unknown'
GROUP BY org_name1
ORDER BY avg_recovery_pct DESC
