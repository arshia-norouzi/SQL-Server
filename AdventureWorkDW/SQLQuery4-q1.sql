WITH RankedSales AS (
    SELECT 
        de.EmployeeKey,
        de.FirstName + ' ' + de.LastName AS FullName,
        dd.CalendarYear,
        SUM(fr.SalesAmount) AS TotalSalesAmount,
        ROW_NUMBER() OVER (
            PARTITION BY de.EmployeeKey 
            ORDER BY SUM(fr.SalesAmount) DESC
        ) AS rn
    FROM DimEmployee AS de
    INNER JOIN FactResellerSales AS fr 
        ON fr.EmployeeKey = de.EmployeeKey
    INNER JOIN DimDate AS dd 
        ON dd.DateKey = fr.OrderDateKey  
    GROUP BY 
        de.EmployeeKey,
        de.FirstName + ' ' + de.LastName,
        dd.CalendarYear
)
SELECT 
    EmployeeKey,
    FullName,
    CalendarYear,
    TotalSalesAmount
FROM RankedSales
WHERE rn = 1
ORDER BY TotalSalesAmount DESC;