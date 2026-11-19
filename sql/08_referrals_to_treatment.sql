-- 08. Of all referrals in the year, how many people started treatment? (by region)
-- A low ratio can mean long waits, people dropping out, or referrals that were not suitable.
SELECT
    REPLACE(org_name1, ' COMMISSIONING REGION', '') AS region,
    CAST(SUM(CASE WHEN measure_name = 'Count_ReferralsReceived' THEN value END) AS INT) AS referrals,
    CAST(SUM(CASE WHEN measure_name = 'Count_AccessingServices' THEN value END) AS INT) AS started_treatment,
    ROUND(100.0 * SUM(CASE WHEN measure_name = 'Count_AccessingServices' THEN value END)
                / SUM(CASE WHEN measure_name = 'Count_ReferralsReceived' THEN value END), 1) AS started_per_100_referrals
FROM tt_monthly
WHERE group_type = 'CommissioningRegion'
  AND org_name1 <> 'Unknown'
GROUP BY org_name1
ORDER BY started_per_100_referrals DESC
