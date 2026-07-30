WITH TerritorySales AS (
    SELECT 
        dst.SalesTerritoryRegion AS Region,
        dst.SalesTerritoryCountry AS Country,
        SUM(f.SalesAmount) AS TotalSales,
        RANK() OVER (ORDER BY SUM(f.SalesAmount) DESC) AS TerritoryRank
    FROM FactInternetSales AS f
    INNER JOIN DimSalesTerritory AS dst 
        ON dst.SalesTerritoryKey = f.SalesTerritoryKey
    GROUP BY 
        dst.SalesTerritoryRegion,
        dst.SalesTerritoryCountry
),
TopProducts AS (
    SELECT 
        dst.SalesTerritoryRegion AS Region,
        dp.EnglishProductName AS TopProduct,
        SUM(f.SalesAmount) AS ProductSales,
        ROW_NUMBER() OVER (
            PARTITION BY dst.SalesTerritoryRegion 
            ORDER BY SUM(f.SalesAmount) DESC
        ) AS rn
    FROM FactInternetSales AS f
    INNER JOIN DimSalesTerritory AS dst 
        ON dst.SalesTerritoryKey = f.SalesTerritoryKey
    INNER JOIN DimProduct AS dp 
        ON dp.ProductKey = f.ProductKey
    GROUP BY 
        dst.SalesTerritoryRegion,
        dp.EnglishProductName
)
SELECT 
    t.Region,
    t.Country,
    t.TotalSales,
    t.TerritoryRank,
    p.TopProduct
FROM TerritorySales AS t
LEFT JOIN TopProducts AS p 
    ON t.Region = p.Region AND p.rn = 1
WHERE t.TerritoryRank <= 10
ORDER BY t.TerritoryRank;