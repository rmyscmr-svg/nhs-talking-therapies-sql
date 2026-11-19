-- 01. What is in the data?
-- How many rows per level of detail, and how many values are hidden ('*')?
-- NHS hides small numbers to protect patient privacy, so I need to know
-- how much data is missing before I trust any average.
SELECT
    group_type,
    COUNT(*)                                          AS total_rows,
    SUM(CASE WHEN value IS NULL THEN 1 ELSE 0 END)    AS suppressed_rows,
    ROUND(100.0 * SUM(CASE WHEN value IS NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_suppressed
FROM tt_monthly
GROUP BY group_type
ORDER BY total_rows DESC
