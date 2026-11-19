-- 05. Local areas (Sub-ICBs) furthest below the 50% recovery ambition
-- Only areas with all 13 months reported, so one bad month cannot skew the result.
WITH area AS (
    SELECT
        org_code1,
        org_name1,
        COUNT(value)          AS months_reported,
        ROUND(AVG(value), 1)  AS avg_recovery_pct
    FROM tt_monthly
    WHERE group_type = 'SubICB'
      AND measure_name = 'Percentage_Recovery'
    GROUP BY org_code1, org_name1
)
SELECT
    org_code1 AS subicb_code,
    org_name1 AS subicb_name,
    avg_recovery_pct,
    ROUND(avg_recovery_pct - 50, 1) AS gap_to_50pct
FROM area
WHERE months_reported = 13
ORDER BY avg_recovery_pct ASC
LIMIT 10
