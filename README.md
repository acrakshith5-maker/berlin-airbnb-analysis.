# Berlin Airbnb Market Analysis

**Question:** What drives Airbnb prices and demand in Berlin, and where should a new host list a property?

**Dashboard:** ?

## Key findings

1. **Income is concentrated.** The top 10% of listings earn 39.1% of all estimated income. The bottom half earns 10.4%.
2. **Top earners win on price and bookings.** They charge almost twice the average price (297 vs 157 per night) and are booked or blocked about 300 nights a year.
3. **Size drives price, ratings do not.** Guests (correlation 0.59) and bedrooms (0.45) are most linked to price. Guest ratings are not (0.02).
4. **Large hosts do not dominate the top.** Hosts with 5+ listings own 35.9% of listings and 33.7% of the top tier.
5. **Location matters.** The median price per night ranges from 77 (Ost 2) to 189 (Regierungsviertel), about 2.5 times higher.
6. **Winter is quiet.** About 27% of days are unavailable in January and February, against about 43% in July and August.

## Recommendations for a new host

?

## Data

- Source: (https://insideairbnb.com/get-the-data/), Berlin (listings, calendar, reviews), downloaded [date].
- The raw data is not included in this repository. Download it from Inside Airbnb, following their data policy.
- Host IDs and names are not published.

## Method

1. **Cleaning (Python, pandas):** the listings file had 12,376 rows. I removed 4,219 listings with no price (34%), then 85 outliers (prices under 15 and the top 1%, above 691). Missing bedrooms and minimum nights were filled with the median. The clean file has 8,072 listings.
2. **SQL analysis (SQLite):** CTEs, window functions (NTILE, RANK) and joins to compare income tiers, neighborhoods, hosts, ratings and calendar demand.
3. **Statistics and charts (Python, matplotlib):** median prices, Spearman correlations and charts.
4. **Dashboard (Tableau Public):** built from a small summary file without host data.

Estimated income = price x unavailable days (365 minus availability).

## Limits

- Income is an estimate. Unavailable days include days that hosts block, so this is not exact earnings or occupancy.
- 34% of listings had no price and were removed. They may differ from the rest.
- The calendar shows one snapshot. Near dates are more booked than far dates, so monthly numbers show a rough pattern only.
- Correlation does not show cause. Guests and bedrooms are linked with each other.
- Ratings cluster between 4.55 and 4.86 across neighborhoods, so they separate areas poorly.

## Project structure

- `notebooks/`: cleaning and insights notebooks
- `sql/`: all SQL queries
- `images/`: charts

## Tools

Python (pandas, matplotlib), SQL (SQLite), Tableau Public

## Author

Rakshith Reddy | Data Analyst | [LinkedIn](https://linkedin.com/in/rakshi17)
