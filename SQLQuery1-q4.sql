select FirstName + ' ' + LastName as FullName , DATEDIFF(year , BirthDate , GETDATE()) as Age,
EnglishCountryRegionName , AVG(TaxAmt) as AvgTax  
from FactInternetSales as f
inner join DimCustomer as dc
on dc.CustomerKey  = f.CustomerKey
inner join DimGeography as dg
on dg.GeographyKey = dc.GeographyKey
where EnglishCountryRegionName != 'united states' or EnglishCountryRegionName != 'australia' 
group by FirstName + ' ' + LastName , DATEDIFF(YEAR , BirthDate , GETDATE())
, EnglishCountryRegionName
having AVG(TaxAmt) > 50 