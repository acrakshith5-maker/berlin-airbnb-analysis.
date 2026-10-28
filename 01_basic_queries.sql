-- Query 1: listings by room type

SELECT room_type,
       COUNT(*) AS listings,
       ROUND(AVG(price), 2) AS avg_price
FROM listings
GROUP BY room_type
ORDER BY listings DESC;

-- Query 2: price by neighborhood

SELECT neighbourhood_cleansed AS neighbourhood,
       COUNT(*) AS listings,
       ROUND(AVG(price), 2) AS avg_price
FROM listings
GROUP BY neighbourhood_cleansed
HAVING COUNT(*) >= 30
ORDER BY avg_price DESC;

-- Query 3: price by number of guests

SELECT accommodates AS guests,
       COUNT(*) AS listings,
       ROUND(AVG(price), 2) AS avg_price
FROM listings
GROUP BY accommodates
HAVING COUNT(*) >= 30
ORDER BY accommodates;

