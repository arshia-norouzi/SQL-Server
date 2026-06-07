with mycte as (
select
ROW_NUMBER() over (partition by firstname + ' ' + lastname order by sum(f.salesamount) desc)
as rank1 , 
CustomerKey , FirstName + ' ' + LastName  as FullName,
SUM(f.SalesAmount) as TotalSale,CalendarYear 
from DimDate as dd
inner join FactInternetSales as f
on f.DueDateKey = dd.DateKey
inner join FactResellerSales as fr
on fr.DueDateKey = dd.DateKey
inner join DimEmployee as de
on fr.EmployeeKey = de.EmployeeKey
group by CustomerKey , FirstName + ' ' + LastName ,CalendarYear
)
select CustomerKey ,FullName, TotalSale,CalendarYear  from mycte
where rank1  = 1
