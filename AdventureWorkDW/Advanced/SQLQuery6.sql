WITH CustomerLastPurchase AS (
    SELECT 
        dc.CustomerKey,
        dc.FirstName + ' ' + dc.LastName AS FullName,
        COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders,
        SUM(f.SalesAmount) AS TotalSpent,
        MAX(dd.FullDateAlternateKey) AS LastPurchaseDate
    FROM DimCustomer AS dc
    INNER JOIN FactInternetSales AS f 
        ON f.CustomerKey = dc.CustomerKey
    INNER JOIN DimDate AS dd 
        ON dd.DateKey = f.OrderDateKey
    GROUP BY 
        dc.CustomerKey,
        dc.FirstName + ' ' + dc.LastName
)
SELECT 
    CustomerKey,
    FullName,
    TotalOrders,
    TotalSpent,
    LastPurchaseDate,
    DATEDIFF(DAY, LastPurchaseDate, GETDATE()) AS DaysSinceLastPurchase
FROM CustomerLastPurchase
WHERE LastPurchaseDate < DATEADD(MONTH, -12, GETDATE())
ORDER BY DaysSinceLastPurchase DESC;