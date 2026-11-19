-- 02. England month by month
-- Turns the long table (one row per measure) into one row per month.
SELECT
    period_start AS month,
    CAST(MAX(CASE WHEN measure_name = 'Count_ReferralsReceived' THEN value END) AS INT) AS referrals,
    CAST(MAX(CASE WHEN measure_name = 'Count_AccessingServices' THEN value END) AS INT) AS started_treatment,
    CAST(MAX(CASE WHEN measure_name = 'Count_FinishedCourseTreatment' THEN value END) AS INT) AS finished_treatment,
    MAX(CASE WHEN measure_name = 'Percentage_Recovery'           THEN value END) AS recovery_pct,
    MAX(CASE WHEN measure_name = 'Percentage_ReliableImprovement' THEN value END) AS improvement_pct,
    MAX(CASE WHEN measure_name = 'Percentage_ReliableDeterioration' THEN value END) AS deterioration_pct
FROM tt_monthly
WHERE group_type = 'England'
GROUP BY period_start
ORDER BY period_start
