select FirstName + ' ' + LastName as FullName, DATEDIFF(year, BirthDate, GETDATE()) as Age, Gender ,
       EnglishCountryRegionName, AVG(TaxAmt) as AvgTax
from FactInternetSales as f
inner join DimCustomer as dc on dc.CustomerKey = f.CustomerKey
inner join DimGeography as dg on dg.GeographyKey = dc.GeographyKey
where EnglishCountryRegionName != 'united states' and EnglishCountryRegionName != 'australia' and dc.Gender = 'f'
group by FirstName + ' ' + LastName, DATEDIFF(YEAR, BirthDate, GETDATE()), EnglishCountryRegionName , Gender
having AVG(TaxAmt) > 50