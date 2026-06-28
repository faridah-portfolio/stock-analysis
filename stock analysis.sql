CREATE DATABASE IF NOT EXISTS sp500_db;
USE sp500_db;
SELECT COUNT(*) FROM sp500_raw;
USE sp500_db;

SELECT
    SUM(CASE WHEN open   IS NULL THEN 1 ELSE 0 END) AS null_open,
    SUM(CASE WHEN high   IS NULL THEN 1 ELSE 0 END) AS null_high,
    SUM(CASE WHEN low    IS NULL THEN 1 ELSE 0 END) AS null_low,
    SUM(CASE WHEN close  IS NULL THEN 1 ELSE 0 END) AS null_close,
    SUM(CASE WHEN volume IS NULL THEN 1 ELSE 0 END) AS null_volume
FROM sp500_raw;

SELECT symbol, trade_date, COUNT(*) AS duplicate_count
FROM sp500_raw
GROUP BY symbol, trade_date
HAVING COUNT(*) > 1;

SELECT * FROM sp500_raw
WHERE low > high OR open < 0 OR volume < 0;

USE sp500_db;

CREATE TABLE sp500_clean AS
SELECT
    UPPER(TRIM(symbol))                                           AS symbol,
    trade_date,
    open,
    high,
    low,
    close,
    volume,
    DAYNAME(trade_date)                                           AS day_of_week,
    YEAR(trade_date)                                              AS trade_year,
    MONTH(trade_date)                                             AS trade_month,
    ROUND(high - low, 4)                                          AS intraday_range,
    ROUND(((close - open) / NULLIF(open, 0)) * 100, 4)           AS daily_return_pct
FROM sp500_raw
WHERE open   IS NOT NULL
  AND high   IS NOT NULL
  AND low    IS NOT NULL
  AND close  IS NOT NULL
  AND volume IS NOT NULL
  AND low    <= high
  AND volume >= 0;

-- Verify clean table
SELECT COUNT(*) AS cleaned_rows FROM sp500_clean;


-- Q1: Date with largest trading volume
SELECT trade_date, SUM(volume) AS total_volume
FROM sp500_clean
GROUP BY trade_date
ORDER BY total_volume DESC
LIMIT 1;
-- Answer: 2015-08-24

-- Top 2 stocks on that date
SELECT symbol, volume
FROM sp500_clean
WHERE trade_date = '2015-08-24'
ORDER BY volume DESC
LIMIT 2;
-- Answer: BAC and AAPL

-- Q2: Volume by day of week
SELECT
    day_of_week,
    SUM(volume) AS total_volume
FROM sp500_clean
GROUP BY day_of_week
ORDER BY total_volume DESC;
-- Highest: Wednesday | Lowest: Monday

-- Q3: AMZN most volatile date
SELECT
    trade_date,
    high,
    low,
    ROUND(high - low, 2) AS intraday_range
FROM sp500_clean
WHERE symbol = 'AMZN'
ORDER BY intraday_range DESC
LIMIT 1;
-- Answer: 2017-06-09 | Range: $85.99

-- Q4: Best stock to invest in
WITH first_price AS (
    SELECT symbol, close AS start_price
    FROM sp500_clean
    WHERE trade_date = '2014-01-02'
),
last_price AS (
    SELECT symbol, close AS end_price
    FROM sp500_clean
    WHERE trade_date = '2017-12-29'
)
SELECT
    f.symbol,
    ROUND(f.start_price, 2)                                             AS price_jan2014,
    ROUND(l.end_price, 2)                                               AS price_dec2017,
    ROUND(((l.end_price - f.start_price) / f.start_price) * 100, 2)    AS pct_gain
FROM first_price f
JOIN last_price l ON f.symbol = l.symbol
WHERE f.start_price > 0
ORDER BY pct_gain DESC
LIMIT 10;


-- View 1: Daily Market Summary
CREATE VIEW vw_daily_market AS
SELECT
    trade_date,
    day_of_week,
    trade_year,
    trade_month,
    SUM(volume)             AS total_daily_volume,
    AVG(close)              AS avg_close_price,
    COUNT(DISTINCT symbol)  AS stocks_traded
FROM sp500_clean
GROUP BY trade_date, day_of_week, trade_year, trade_month;

-- View 2: Stock Performance
CREATE VIEW vw_stock_performance AS
WITH first_price AS (
    SELECT symbol, close AS start_price
    FROM sp500_clean
    WHERE trade_date = '2014-01-02'
),
last_price AS (
    SELECT symbol, close AS end_price
    FROM sp500_clean
    WHERE trade_date = '2017-12-29'
)
SELECT
    f.symbol,
    ROUND(f.start_price, 2)                                             AS price_jan2014,
    ROUND(l.end_price, 2)                                               AS price_dec2017,
    ROUND(((l.end_price - f.start_price) / f.start_price) * 100, 2)    AS pct_gain
FROM first_price f
JOIN last_price l ON f.symbol = l.symbol
WHERE f.start_price > 0;

-- View 3: AMZN Time Series
CREATE VIEW vw_amzn_timeseries AS
SELECT
    trade_date,
    open, high, low, close,
    volume,
    intraday_range,
    daily_return_pct
FROM sp500_clean
WHERE symbol = 'AMZN';

-- View 4: Volume by Day of Week
CREATE VIEW vw_dow_volume AS
SELECT
    day_of_week,
    SUM(volume)  AS total_volume,
    AVG(volume)  AS avg_volume
FROM sp500_clean
GROUP BY day_of_week;