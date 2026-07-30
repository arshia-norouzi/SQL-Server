# Advanced SQL Scenarios – AdventureWorksDW

This folder contains advanced and practical SQL scenarios based on the **AdventureWorksDW** database.

These queries are designed to practice the following skills:
- Common Table Expressions (CTE)
- Window Functions (`ROW_NUMBER`, `RANK`, `LAG`)
- Customer analysis (RFM and Churn)
- Time-series analysis
- Geographic and product analysis

---

## Scenarios

| File | Scenario | Description |
|------|----------|-------------|
| `SQLQuery1.sql` | Best Year per Employee | Finds the best-selling year for each salesperson |
| `SQLQuery2.sql` | High-Value Customers (RFM) | Top 50 customers based on Recency, Frequency, and Monetary value |
| `SQLQuery3.sql` | Monthly Sales Growth | Monthly sales trend with growth percentage compared to the previous month |
| `SQLQuery6.sql` | Churn Risk Customers | Customers who have not made any purchase in the last 12 months |
| `SQLQuery7.sql` | Top Territories Analysis | Top 10 sales territories with the best-selling product in each region |

---

## Skills Covered

- Common Table Expressions (CTE)
- Window Functions
- Aggregate Functions
- Date Functions (`DATEDIFF`, `DATEADD`, `LAG`)
- Ranking and Filtering
- Multi-level JOINs

---

## How to Use

1. Restore and run the AdventureWorksDW database in SQL Server.
2. Open each `.sql` file and execute it.
3. Review the results and modify the queries if needed.
