-- 07. Bradford District and Craven (Sub-ICB 36J) compared with England
-- I live in Bradford, so I wanted to see how my local service compares.
SELECT
    b.period_start AS month,
    b.value        AS bradford_recovery_pct,
    e.value        AS england_recovery_pct,
    ROUND(b.value - e.value, 1) AS difference
FROM tt_monthly b
JOIN tt_monthly e
  ON  e.period_start = b.period_start
  AND e.measure_name = b.measure_name
  AND e.group_type   = 'England'
WHERE b.group_type   = 'SubICB'
  AND b.org_code1    = '36J'
  AND b.measure_name = 'Percentage_Recovery'
ORDER BY b.period_start
