WITH CustomerMetrics AS (
    SELECT 
        dc.CustomerKey,
        dc.FirstName + ' ' + dc.LastName AS FullName,
        COUNT(DISTINCT f.SalesOrderNumber) AS Frequency,
        SUM(f.SalesAmount) AS Monetary,
        MAX(dd.FullDateAlternateKey) AS LastPurchaseDate,
        DATEDIFF(DAY, MAX(dd.FullDateAlternateKey), GETDATE()) AS Recency
    FROM DimCustomer AS dc
    INNER JOIN FactInternetSales AS f 
        ON f.CustomerKey = dc.CustomerKey
    INNER JOIN DimDate AS dd 
        ON dd.DateKey = f.OrderDateKey
    GROUP BY 
        dc.CustomerKey,
        dc.FirstName + ' ' + dc.LastName
),
RankedCustomers AS (
    SELECT 
        CustomerKey,
        FullName,
        Frequency,
        Monetary,
        Recency,
        LastPurchaseDate,
  
        RANK() OVER (ORDER BY Frequency DESC) AS Rank_Frequency,
        RANK() OVER (ORDER BY Monetary DESC) AS Rank_Monetary,
        RANK() OVER (ORDER BY Recency ASC) AS Rank_Recency
    FROM CustomerMetrics
)
SELECT TOP 50
    CustomerKey,
    FullName,
    Frequency,
    Monetary,
    Recency,
    LastPurchaseDate,
    Rank_Frequency,
    Rank_Monetary,
    Rank_Recency,
    (Rank_Frequency + Rank_Monetary + Rank_Recency) AS TotalScore
FROM RankedCustomers
ORDER BY TotalScore asc