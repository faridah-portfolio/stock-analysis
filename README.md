# 📈 S&P 500 Stock Market Analysis (2014–2017)

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)


---

## 📌 Project Overview

This project is an end-to-end data analysis of **S&P 500 stock price data from 2014 to 2017**. The S&P 500 is a stock market index tracking the 500 largest publicly traded companies in the United States — including Apple, Amazon, Google, and Nvidia.

The goal of this project was to explore, clean, analyse, and visualize real stock market data to uncover meaningful insights about trading patterns, market events, stock volatility, and investment performance.

The full pipeline covers:
- **Data ingestion** using Python (Pandas + SQLAlchemy)
- **Data cleaning and analysis** using SQL (MySQL)
- **Dashboard creation** using Power BI

---

## 📂 Dataset

| Property | Details |
|---|---|
| **Source** | S&P 500 Stock Prices Dataset |
| **Time Period** | January 2, 2014 — December 29, 2017 |
| **Total Rows** | 497,472 |
| **Total Companies** | 505 |
| **Columns** | symbol, date, open, high, low, close, volume |

### Column Descriptions

| Column | Description |
|---|---|
| `symbol` | Stock ticker symbol (e.g. AAPL = Apple, AMZN = Amazon) |
| `date` | The trading date |
| `open` | Stock price at market open |
| `high` | Highest price reached during the day |
| `low` | Lowest price reached during the day |
| `close` | Stock price at market close |
| `volume` | Total number of shares traded that day |

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Python (Pandas, SQLAlchemy, PyMySQL)** | Loading CSV into MySQL database |
| **MySQL Workbench** | Data cleaning, transformation, and analysis |
| **Power BI Desktop** | Interactive dashboard and data visualization |
| **Jupyter Notebook** | Running Python import script |

---

## 🔄 Project Workflow

```
Raw CSV File (497,472 rows)
        ↓
Python (Jupyter Notebook)
→ Load CSV with Pandas
→ Fix data types
→ Import into MySQL using SQLAlchemy
        ↓
MySQL Workbench (SQL)
→ Data quality checks (nulls, duplicates, illogical values)
→ Create cleaned table (sp500_clean)
→ Add derived columns (day_of_week, intraday_range, daily_return_pct)
→ Run analysis queries
→ Create views for Power BI
        ↓
Power BI Desktop
→ Connect to MySQL database
→ Build relationships between tables
→ Create interactive dashboard with 5 visuals + slicers
```

---

## 🧹 Data Cleaning (SQL)

Before analysis, the following data quality checks were performed:

### Issues Found & Fixed:

| Issue | Finding | Action Taken |
|---|---|---|
| NULL values | 11 nulls in `open`, 8 in `high`, 8 in `low` | Removed affected rows |
| Duplicate records | 0 duplicates found | No action needed |
| Illogical prices | Checked for `low > high` and negative values | None found |
| Data types | Date stored as string | Converted to DATE format |

### New Columns Added:

| Column | Formula | Purpose |
|---|---|---|
| `day_of_week` | DAYNAME(trade_date) | Identify trading patterns by weekday |
| `trade_year` | YEAR(trade_date) | Filter by year |
| `trade_month` | MONTH(trade_date) | Filter by month |
| `intraday_range` | high - low | Measure daily price volatility |
| `daily_return_pct` | ((close - open) / open) × 100 | Measure daily % gain or loss |

### Cleaned Table:
After cleaning, the final table `sp500_clean` contained **497,445 rows** — only 27 rows were removed due to null values.

---

## 🔍 Analysis Questions & Answers

### Q1: Which date had the largest overall trading volume? Which 2 stocks were traded most?



**📌 Answer:**
- **Date: August 24, 2015** — Total volume: **4.6 billion shares**
- **Top stocks: BAC (Bank of America)** with 214M shares and **AAPL (Apple)** with 162M shares
- **Why:** This date is known as **"Black Monday 2015"** — a global stock market crash triggered by China's economic slowdown. Investors panicked and sold massive amounts of shares, causing unprecedented trading volume.

---

### Q2: On which day of the week does volume tend to be highest? Lowest?



**📌 Answer:**
- **Highest volume day: Wednesday**
- **Lowest volume day: Monday**
- **Why:** On Mondays, investors are cautious and still processing weekend news. By Wednesday, the market is fully active — reacting to economic reports, earnings announcements, and institutional trading decisions.

---

### Q3: On which date did Amazon (AMZN) see the most volatility?



**📌 Answer:**
- **Date: June 9, 2017**
- **Intraday range: $85.99** (the difference between Amazon's highest and lowest price that day)
- **Why:** A large single-day price swing like this indicates major uncertainty among investors — possibly triggered by a significant news event or earnings report causing buyers and sellers to strongly disagree on Amazon's value.

---

### Q4: Which stock would have been the best investment from 2014 to 2017?



**📌 Answer:**

| Rank | Stock | Company | Jan 2014 Price | Dec 2017 Price | % Gain |
|---|---|---|---|---|---|
| 🥇 1 | **NVDA** | Nvidia | ~$15 | ~$185 | **+1,120%** |
| 🥈 2 | AVGO | Broadcom | — | — | +388% |
| 🥉 3 | EA | Electronic Arts | — | — | +360% |
| 4 | ALGN | Align Technology | — | — | +290% |
| 5 | NFLX | Netflix | — | — | +270% |

**Why NVDA?** Nvidia makes graphics processing chips (GPUs) that became essential for gaming, data centres, and artificial intelligence between 2014 and 2017. As demand for these industries exploded, so did Nvidia's stock price — turning a $1,000 investment into over $12,000 in just 4 years.

---

## 📊 Power BI Dashboard

The interactive dashboard contains 5 visuals and 3 slicers:

### Visuals:

| # | Visual | Type | Key Insight |
|---|---|---|---|
| 1 | KPI Cards | Cards | Total records, volume, stocks, date range |
| 2 | Daily Market Volume 2014–2017 | Line Chart | Black Monday spike on Aug 24, 2015 |
| 3 | Trading Volume by Day of Week | Bar Chart | Wednesday highest, Monday lowest |
| 4 | Top 10 Best Performing Stocks | Bar Chart | NVDA leads with +1,120% gain |
| 5 | Amazon Daily Volatility 2014–2017 | Line Chart | Peak volatility on June 9, 2017 |

### Slicers (Interactive Filters):
- **Year** — Filter all visuals by 2014, 2015, 2016, or 2017
- **Day of Week** — Filter by trading day
- **Symbol** — Filter by individual stock

---

## 💡 Key Insights

1. **Black Monday (Aug 24, 2015)** was the single most traded day in the dataset — a real-world market event visible directly in the data as a massive volume spike.

2. **Wednesday is the most active trading day** — mid-week sees the highest institutional activity and market reactions to economic data releases.

3. **Amazon's volatility grew significantly** between 2014 and 2017, reflecting its rapid expansion into cloud computing (AWS), advertising, and logistics during this period.

4. **Nvidia was the best performing stock** in the S&P 500 during this period with a +1,120% gain — driven by the explosion of gaming, AI, and data centre demand for its GPU chips.

5. **Monday is consistently the quietest trading day** — investors tend to be cautious at the start of the week, waiting to see how markets develop before making major moves.



-

## 👩‍💻 Author

**Faridah Abubakar**
Data Analyst | Power BI  | SQL | Python |

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/faridah-abubakar)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:farisoiza64@gmail.com)

---
