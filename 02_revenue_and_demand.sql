-- Query 4: income share by tier (CTE + NTILE)

WITH revenue AS (
    SELECT id, neighbourhood_cleansed, room_type, price,
           365 - availability_365 AS booked_nights,
           price * (365 - availability_365) AS est_revenue
    FROM listings
),
ranked AS (
    SELECT *, NTILE(10) OVER (ORDER BY est_revenue DESC) AS tier
    FROM revenue
)
SELECT tier,
       COUNT(*) AS listings,
       ROUND(AVG(price), 2) AS avg_price,
       ROUND(AVG(booked_nights)) AS avg_booked_nights,
       ROUND(SUM(est_revenue)) AS total_revenue,
       ROUND(100.0 * SUM(est_revenue) / (SELECT SUM(est_revenue) FROM revenue), 1) AS pct_of_all_revenue
FROM ranked
GROUP BY tier
ORDER BY tier;

-- Query 5: neighborhoods in the top 10%

WITH revenue AS (
    SELECT id, neighbourhood_cleansed, room_type, price,
           price * (365 - availability_365) AS est_revenue
    FROM listings
),
ranked AS (
    SELECT *, NTILE(10) OVER (ORDER BY est_revenue DESC) AS tier
    FROM revenue
)
SELECT neighbourhood_cleansed AS neighbourhood,
       COUNT(*) AS top_listings,
       ROUND(AVG(est_revenue)) AS avg_revenue
FROM ranked
WHERE tier = 1
GROUP BY neighbourhood_cleansed
HAVING COUNT(*) >= 10
ORDER BY top_listings DESC
LIMIT 10;

-- Query 6: unavailable days by month

SELECT strftime('%Y-%m', date) AS month,
       COUNT(*) AS listing_days,
       ROUND(100.0 * SUM(CASE WHEN available = 'f' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_unavailable
FROM calendar
GROUP BY month
ORDER BY month;

