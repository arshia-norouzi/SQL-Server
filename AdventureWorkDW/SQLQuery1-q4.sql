SELECT TOP 5
    FirstName + ' ' + LastName AS FullName,
    Gender,
    count(*) AS TotalOrder,
    EnglishEducation,
    YearlyIncome
FROM DimCustomer AS Dc
INNER JOIN FactInternetSales AS F
    ON F.CustomerKey = Dc.CustomerKey
WHERE 
    (EnglishEducation = 'Bachelors' OR EnglishEducation = 'Master')
    AND (FirstName LIKE 'A%' OR FirstName LIKE 'M%')
    AND YearlyIncome BETWEEN 50000 AND 70000
GROUP BY 
    FirstName + ' ' + LastName,
    Gender,
    EnglishEducation,
    YearlyIncome
ORDER BY TotalOrder DESC;