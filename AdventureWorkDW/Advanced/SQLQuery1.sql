With mycte AS (
select 
DE.EmployeeKey , de.FirstName + ' '  + de.LastName as FullName ,  dd.CalendarYear , sum(SalesAmount) as TotalSale,
ROW_NUMBER() over (partition by de.employeekey order by Sum(SalesAmount) desc) as RN

from DimEmployee as DE 
inner join FactResellerSales as FR 
on fr.EmployeeKey = de.EmployeeKey
inner join DimDate as DD
on fr.OrderDateKey = dd.DateKey
group by de.EmployeeKey,
        de.FirstName + ' ' + de.LastName,
        dd.CalendarYear
)
SELECT 
    EmployeeKey,
    FullName,
    CalendarYear,
    TotalSale
FROM mycte
WHERE rn = 1
ORDER BY TotalSale DESC;