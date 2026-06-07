select de.EmployeeKey,FirstName + ' ' + LastName as FullName ,sum(SalesAmount) as TotalSale,
SUM(SalesAmountQuota) as TotalSaleQouta, sum(SalesAmountQuota) - sum(SalesAmount) as subtract
,dd.CalendarYear
from DimEmployee as de
inner join FactSalesQuota as fq
on fq.EmployeeKey = de.EmployeeKey
inner join DimDate as dd
on dd.DateKey = fq.DateKey
inner join FactInternetSales as f
on f.DueDateKey = dd.DateKey
group by de.EmployeeKey , FirstName + ' ' + LastName , dd.CalendarYear
