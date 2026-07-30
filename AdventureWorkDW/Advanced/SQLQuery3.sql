WITH MonthlySales AS (
    SELECT 
        dd.CalendarYear,
        dd.MonthNumberOfYear AS MonthNumber,
        dd.EnglishMonthName AS MonthName,
        SUM(f.SalesAmount) AS TotalSales
    FROM FactInternetSales AS f
    INNER JOIN DimDate AS dd 
        ON dd.DateKey = f.OrderDateKey
    GROUP BY 
        dd.CalendarYear,
        dd.MonthNumberOfYear,
        dd.EnglishMonthName
),
SalesWithLag AS (
    SELECT 
        CalendarYear,
        MonthNumber,
        MonthName,
        TotalSales,
        LAG(TotalSales) OVER (
            ORDER BY CalendarYear, MonthNumber
        ) AS PreviousMonthSales
    FROM MonthlySales
)
SELECT 
    CalendarYear,
    MonthNumber,
    MonthName,
    TotalSales,
    PreviousMonthSales,
    CAST(
        (TotalSales - PreviousMonthSales) * 100.0 
        / NULLIF(PreviousMonthSales, 0) 
        AS DECIMAL(10,2)
    ) AS GrowthPercent,
    CASE 
        WHEN PreviousMonthSales IS NULL THEN 'FirstMonth'
        WHEN TotalSales > PreviousMonthSales THEN 'Positive'
        WHEN TotalSales < PreviousMonthSales THEN 'Negative'
        ELSE 'None'
    END AS GrowthStatus
FROM SalesWithLag
ORDER BY 
    CalendarYear ,
    MonthNumber asc