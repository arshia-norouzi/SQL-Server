select de.EmployeeKey, FirstName + ' ' + LastName as FullName,
   SUM(SalesAmountQuota) as TotalSaleQuota,
       dd.CalendarYear
from DimEmployee as de
inner join FactSalesQuota as fq on fq.EmployeeKey = de.EmployeeKey
inner join DimDate as dd on dd.DateKey = fq.DateKey

group by de.EmployeeKey, FirstName + ' ' + LastName, dd.CalendarYear
order by TotalSaleQuota desc