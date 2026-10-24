# Customer Segmentation and Churn Analysis (RFM) | SQL Server, Python, Power BI

An end-to-end customer analytics project: two years of online retail transactions are cleaned in SQL Server, scored with RFM analysis in Python, and presented in an interactive two-page Power BI dashboard (IKEA-themed for presentation).

## Business Problem

Which customers generate most of the revenue, which ones are at risk of leaving, and where should retention effort go? This project segments customers by purchase behavior and tracks churn, revenue and retention across segments, countries and time periods.

## Dataset

- **Source:** IKEA Gifting Dataset, provided by [add source / link]
- **Content:** Online retail transactions across two periods (2009-2010 and 2010-2011)
- **Fields:** Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer ID, Country
- The raw data is not included in this repository. See the source link above.

## Tools Used

| Stage | Tool |
|---|---|
| Data merging and cleaning | SQL Server |
| RFM scoring and segmentation | Python (pandas), Jupyter Notebook |
| Dashboard and reporting | Power BI |

## Workflow

1. **SQL Server:** merged the two yearly tables with `UNION ALL`, converted date and price columns safely with `TRY_CONVERT`, and validated the conversion.
2. **Data quality checks:** counted missing customer IDs, zero or negative quantities, missing descriptions and exact duplicate rows.
3. **Deduplication:** removed exact duplicates using `ROW_NUMBER()` and produced a final cleaned table.
4. **Python:** removed rows without a customer ID and rows with non-positive quantity, then calculated Recency, Frequency and Monetary values per customer.
5. **Scoring and segmentation:** assigned 1 to 5 quintile scores for each metric and grouped customers into 6 segments.
6. **Power BI:** merged the RFM results back onto the transactions and built the dashboard.

## RFM Methodology

- **Snapshot date:** 2011-12-10 (the day after the last transaction in the data)
- **Recency:** days since the customer's last purchase
- **Frequency:** number of unique invoices
- **Monetary:** total of Quantity x Price
- **Churn definition:** a customer is churned if Recency is more than 90 days (an assumption that can be changed)

| Segment | Rule |
|---|---|
| Champions | R >= 4, F >= 4, M >= 4 |
| Loyal | R >= 3, F >= 3 |
| At Risk | R <= 2, F >= 3 |
| New | R >= 4, F <= 2 |
| Needs Attention | R = 3, F <= 2 |
| Lost | All remaining customers |

Segment rules are applied in the order shown above.

## Key Findings

- **5,881 customers** generated **$17M** in revenue, with an average customer value of $2,954.
- **50.9%** of customers are classified as churned (no purchase in the last 90 days).
- **Champions** are 1,291 customers (about 22%) but bring in about **$11.8M, roughly 68% of total revenue**, with an average customer value of $9,169.
- **Lost** is the largest segment (1,524 customers) but has the lowest average customer value ($429).
- **Loyal** (1,416 customers) is the second largest revenue source at about $2.7M.
- **At Risk** customers (821) have good purchase frequency but low recency, making them a clear retention target.
- The **United Kingdom** accounts for 5,353 of the 5,881 customers.

## Dashboard Pages

**Business Overview (Customers):** customer count, retention and churn by segment, with monthly, quarterly and yearly trends.


<img width="805" height="504" alt="Screenshot 2026-10-24 114600" src="https://github.com/user-attachments/assets/d67dceed-2a1b-4d55-8fe7-7e931a6b36be" />


**Business Overview (Revenue):** revenue by segment and each segment's share of total revenue, with monthly, quarterly and yearly trends.


<img width="801" height="499" alt="Screenshot 2026-10-24 114620" src="https://github.com/user-attachments/assets/6e6f6751-6bd4-400f-bfdd-a8bad8044456" />


**RFM Analysis (Segment):** segment performance summary with average R, F and M scores, average customer value, and churn % trends.


<img width="813" height="523" alt="Screenshot 2026-10-24 164000" src="https://github.com/user-attachments/assets/ef4a2d40-8024-487c-8f0f-cd638a04ef3e" />


**RFM Analysis (Country):** country-level customers, revenue and RFM scores, top 5 countries by average customer value, and churn % trends.


<img width="785" height="487" alt="Screenshot 2026-10-24 114703" src="https://github.com/user-attachments/assets/fa1c9705-0efe-4429-b3b1-8a5e993a22e5" />



## Suggested Business Actions

- Protect and reward **Champions** with early access and loyalty offers.
- Run win-back campaigns for **At Risk** customers before they become Lost.
- Nudge **New** customers toward a second purchase.
- Limit spend on **Lost** customers, since their average value is the lowest.

## Repository Structure

```
ikea-customer-segmentation-rfm/
├── README.md
├── sql/          # data merging, cleaning and quality checks
├── python/       # RFM scoring and segmentation notebook
├── powerbi/      # Power BI report (.pbix)
├── report/       # dashboard PDF
└── images/       # dashboard screenshots
```

## How to Run

1. Run the SQL scripts in `sql/` to merge and clean the two yearly tables.
2. Export the cleaned table to CSV and run the notebook in `python/` to generate the RFM output.
3. Open the `.pbix` file in `powerbi/` with Power BI Desktop and refresh the data source path.

## Assumptions and Limitations

- Churn is defined as 90+ days without a purchase, measured from a fixed snapshot date.
- Rows without a Customer ID and rows with zero or negative quantity (returns and cancellations) are excluded from the RFM analysis.
- Segment rules are business logic I defined and can be tuned.
- Country-level averages for countries with very few customers can be skewed by a single buyer.
- Revenue is shown with a dollar format in the dashboard for presentation.

## Author

**Meenakshi Rajpurohit**
B.Tech in Computer Science Engineering
Government Engineering College, Bikaner

CONNECT: imeenakshii28@gmail.com
