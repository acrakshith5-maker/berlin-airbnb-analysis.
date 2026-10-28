-- Query 7: top 3 hosts per neighborhood (window function RANK)

WITH host_rev AS (
    SELECT host_id,
           neighbourhood_cleansed AS neighbourhood,
           COUNT(*) AS listings,
           SUM(price * (365 - availability_365)) AS est_revenue
    FROM listings
    WHERE neighbourhood_cleansed IN (
        SELECT neighbourhood_cleansed FROM listings
        GROUP BY neighbourhood_cleansed HAVING COUNT(*) >= 100
    )
    GROUP BY host_id, neighbourhood_cleansed
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY neighbourhood ORDER BY est_revenue DESC) AS rank_in_area
    FROM host_rev
)
SELECT neighbourhood, rank_in_area, host_id, listings, ROUND(est_revenue) AS est_revenue
FROM ranked
WHERE rank_in_area <= 3
ORDER BY neighbourhood, rank_in_area;

-- Query 8: ratings and recent reviews by neighborhood (join)

WITH review_counts AS (
    SELECT listing_id,
           COUNT(*) AS total_reviews,
           SUM(CASE WHEN date >= date((SELECT MAX(date) FROM reviews), '-12 months')
                    THEN 1 ELSE 0 END) AS recent_reviews
    FROM reviews
    GROUP BY listing_id
)
SELECT l.neighbourhood_cleansed AS neighbourhood,
       COUNT(*) AS listings,
       ROUND(AVG(l.review_scores_rating), 2) AS avg_rating,
       ROUND(AVG(rc.recent_reviews), 1) AS recent_reviews_per_listing
FROM listings l
JOIN review_counts rc ON rc.listing_id = l.id
WHERE l.review_scores_rating IS NOT NULL
GROUP BY l.neighbourhood_cleansed
HAVING COUNT(*) >= 30
ORDER BY avg_rating DESC;


-- Query 9: share of top tier by host size

WITH revenue AS (
    SELECT id, host_id,
           price * (365 - availability_365) AS est_revenue
    FROM listings
),
ranked AS (
    SELECT *, NTILE(10) OVER (ORDER BY est_revenue DESC) AS tier
    FROM revenue
),
host_size AS (
    SELECT host_id, COUNT(*) AS host_listings
    FROM listings
    GROUP BY host_id
)
SELECT CASE WHEN h.host_listings >= 5 THEN '5+ listings' ELSE '1-4 listings' END AS host_type,
       COUNT(*) AS top_listings,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM ranked WHERE tier = 1), 1) AS pct_of_top_tier
FROM ranked r
JOIN host_size h ON h.host_id = r.host_id
WHERE r.tier = 1
GROUP BY host_type;


-- Query 10: share of all listings by host size

WITH host_size AS (
    SELECT host_id, COUNT(*) AS host_listings
    FROM listings
    GROUP BY host_id
)
SELECT CASE WHEN h.host_listings >= 5 THEN '5+ listings' ELSE '1-4 listings' END AS host_type,
       COUNT(*) AS all_listings,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM listings), 1) AS pct_of_all
FROM listings l
JOIN host_size h ON h.host_id = l.host_id
GROUP BY host_type;

