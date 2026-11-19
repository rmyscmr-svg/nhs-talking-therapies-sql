-- 03. Waiting times against the NHS standards
-- Of the people who finished a course of treatment that month, what % had
-- started treatment within 6 weeks (and 18 weeks) of being referred?
-- Standard: 75% within 6 weeks, 95% within 18 weeks.
SELECT
    period_start AS month,
    MAX(CASE WHEN measure_name = 'Percentage_AccessingServices6WeeksFinishedCourseTreatment'  THEN value END) AS within_6_weeks_pct,
    MAX(CASE WHEN measure_name = 'Percentage_AccessingServices18WeeksFinishedCourseTreatment' THEN value END) AS within_18_weeks_pct,
    ROUND(MAX(CASE WHEN measure_name = 'Percentage_AccessingServices6WeeksFinishedCourseTreatment' THEN value END) - 75, 1) AS gap_to_6wk_standard
FROM tt_monthly
WHERE group_type = 'England'
GROUP BY period_start
ORDER BY period_start
