use pubs
select top 5 fname + ' ' + lname as FullName, hire_date
from employee
where YEAR(hire_date) > 1990
order by hire_date desc