# SQL Queries — AdventureWorks Analysis

## Overview

This collection contains **6 SQL queries** written against the AdventureWorks data warehouse schema. The queries cover employee sales performance, quota tracking, customer tax analysis, and top-N reporting using a mix of aggregations, joins, CTEs, and window functions.

---

## Query Files

### Q1 — Top Customer Sale per Year (`SQLQuery4-q1.sql`)

Retrieves each customer's best sales year using a CTE and `ROW_NUMBER()` window function.

**Tables used:** `DimDate`, `FactInternetSales`, `FactResellerSales`, `DimEmployee`

**Logic:**
- Joins internet sales and reseller sales on `DueDateKey`
- Partitions by customer full name, ordered by `SalesAmount DESC`
- Returns only the row ranked `1` per customer — their single highest-sales year

**Output columns:** `CustomerKey`, `FullName`, `TotalSale`, `CalendarYear`

```sql
with mycte as (
    select
        ROW_NUMBER() over (partition by firstname + ' ' + lastname order by sum(f.salesamount) desc) as rank1,
        CustomerKey, FirstName + ' ' + LastName as FullName,
        SUM(f.SalesAmount) as TotalSale, CalendarYear
    from DimDate as dd
    inner join FactInternetSales as f on f.DueDateKey = dd.DateKey
    inner join FactResellerSales as fr on fr.DueDateKey = dd.DateKey
    inner join DimEmployee as de on fr.EmployeeKey = de.EmployeeKey
    group by CustomerKey, FirstName + ' ' + LastName, CalendarYear
)
select CustomerKey, FullName, TotalSale, CalendarYear from mycte where rank1 = 1
```

---

### Q2 — Employee Sales vs. Quota by Year (`SQLQuery1-q2.sql`)

Compares each employee's actual internet sales against their assigned sales quota, broken down by calendar year.

**Tables used:** `DimEmployee`, `FactSalesQuota`, `DimDate`, `FactInternetSales`

**Logic:**
- Joins quota and sales facts through the shared date key (`DueDateKey`)
- Calculates the gap between quota and actual sales (`subtract`)

**Output columns:** `EmployeeKey`, `FullName`, `TotalSale`, `TotalSaleQuota`, `subtract`, `CalendarYear`

> ⚠️ **Note:** The join between `FactInternetSales` and `DimDate` on `DueDateKey` may inflate results if multiple sales records share the same due date. Consider verifying the intended join key.

```sql
select de.EmployeeKey, FirstName + ' ' + LastName as FullName,
       sum(SalesAmount) as TotalSale, SUM(SalesAmountQuota) as TotalSaleQuota,
       sum(SalesAmountQuota) - sum(SalesAmount) as subtract, dd.CalendarYear
from DimEmployee as de
inner join FactSalesQuota as fq on fq.EmployeeKey = de.EmployeeKey
inner join DimDate as dd on dd.DateKey = fq.DateKey
inner join FactInternetSales as f on f.DueDateKey = dd.DateKey
group by de.EmployeeKey, FirstName + ' ' + LastName, dd.CalendarYear
```

---

### Q3 — Employee Sales vs. Quota by Year (Duplicate) (`SQLQuery2-q3.sql`)

Identical in logic to Q2. Both files produce the same result set.

**Tables used:** `DimEmployee`, `FactSalesQuota`, `DimDate`, `FactInternetSales`

**Output columns:** `EmployeeKey`, `FullName`, `TotalSale`, `TotalSaleQuota`, `subtract`, `CalendarYear`

> ⚠️ **Note:** This query is a duplicate of Q2 (`SQLQuery1-q2.sql`). Consider removing or differentiating it.

---

### Q4 — Customer Average Tax by Country (`SQLQuery1-q4.sql`)

Returns customers with above-average tax amounts, grouped by name, age, and country — excluding US and Australian customers.

**Tables used:** `FactInternetSales`, `DimCustomer`, `DimGeography`

**Logic:**
- Calculates customer age dynamically using `DATEDIFF(year, BirthDate, GETDATE())`
- Filters by country and applies a `HAVING AVG(TaxAmt) > 50` threshold

**Output columns:** `FullName`, `Age`, `EnglishCountryRegionName`, `AvgTax`

> ⚠️ **Bug:** The `WHERE` clause uses `OR` instead of `AND`, which causes the condition to always be true and returns all countries. It should be:
> ```sql
> WHERE EnglishCountryRegionName != 'united states' AND EnglishCountryRegionName != 'australia'
> ```
> Also note that country name comparisons are case-sensitive depending on the database collation — `'United States'` (title case) is the standard value in AdventureWorks.

```sql
select FirstName + ' ' + LastName as FullName, DATEDIFF(year, BirthDate, GETDATE()) as Age,
       EnglishCountryRegionName, AVG(TaxAmt) as AvgTax
from FactInternetSales as f
inner join DimCustomer as dc on dc.CustomerKey = f.CustomerKey
inner join DimGeography as dg on dg.GeographyKey = dc.GeographyKey
where EnglishCountryRegionName != 'united states' or EnglishCountryRegionName != 'australia'
group by FirstName + ' ' + LastName, DATEDIFF(YEAR, BirthDate, GETDATE()), EnglishCountryRegionName
having AVG(TaxAmt) > 50
```

---

### Q5 — Top 5 Employees Hired After 1990 (`SQLQuery4-q5.sql`)

Retrieves the top 5 employees hired after 1990 from a custom `employee` table.

**Tables used:** `employee`

**Output columns:** `FullName`, `hire_date`

> ℹ️ **Note:** Uses a non-AdventureWorks `employee` table with columns `fname`, `lname`, and `hire_date`. No `ORDER BY` is specified, so the "top 5" result is non-deterministic. Add an `ORDER BY hire_date` (or another column) for consistent results.

```sql
select top 5 fname + ' ' + lname as FullName, hire_date
from employee
where YEAR(hire_date) > 1990
```

---

### Q6 — Top 5 Employees Hired After 1990 (Duplicate) (`SQLQuery5-q6.sql`)

Identical to Q5. Both files produce the same result set.

**Tables used:** `employee`

**Output columns:** `FullName`, `hire_date`

> ⚠️ **Note:** This query is a duplicate of Q5 (`SQLQuery4-q5.sql`). Consider removing or differentiating it.

---

## Schema Reference

| Table | Type | Description |
|---|---|---|
| `DimEmployee` | Dimension | Employee master data (`EmployeeKey`, `FirstName`, `LastName`) |
| `DimCustomer` | Dimension | Customer master data (`CustomerKey`, `FirstName`, `LastName`, `BirthDate`) |
| `DimGeography` | Dimension | Geographic lookup (`GeographyKey`, `EnglishCountryRegionName`) |
| `DimDate` | Dimension | Date dimension (`DateKey`, `CalendarYear`) |
| `FactInternetSales` | Fact | Internet sales transactions (`SalesAmount`, `TaxAmt`, `DueDateKey`, `CustomerKey`) |
| `FactResellerSales` | Fact | Reseller sales transactions (`DueDateKey`, `EmployeeKey`) |
| `FactSalesQuota` | Fact | Employee sales quotas (`EmployeeKey`, `DateKey`, `SalesAmountQuota`) |
| `employee` | Custom | Non-DW employee table (`fname`, `lname`, `hire_date`) |

---

## Known Issues

| # | File | Issue | Recommended Fix |
|---|---|---|---|
| 1 | `SQLQuery1-q4.sql` | `OR` in WHERE clause negates the country filter | Replace `OR` with `AND` |
| 2 | `SQLQuery1-q4.sql` | Country names in lowercase may not match collation | Use title case: `'United States'`, `'Australia'` |
| 3 | `SQLQuery4-q5.sql` / `SQLQuery5-q6.sql` | `TOP 5` without `ORDER BY` is non-deterministic | Add `ORDER BY hire_date DESC` or similar |
| 4 | `SQLQuery2-q3.sql` | Exact duplicate of `SQLQuery1-q2.sql` | Remove or differentiate |
| 5 | `SQLQuery5-q6.sql` | Exact duplicate of `SQLQuery4-q5.sql` | Remove or differentiate |

---

## Requirements

- **SQL Server** (T-SQL syntax — `TOP`, `DATEDIFF`, `GETDATE()`, `ROW_NUMBER() OVER`)
- **AdventureWorks DW** database for Q1–Q4
- A custom `employee` table for Q5–Q6
