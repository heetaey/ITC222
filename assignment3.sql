use MetroAlt

--1
select Year(EmployeeHireDate) as [Year], EmployeeLastName from Employee
order by Year(EmployeeHireDate)

--2
Select Datediff(Month, '09/04/1995', '12/07/2014') [Month Difference]

--3
Select
'(' + SUBSTRING(EmployeePhone, 1, 3) + ')' + SUBSTRING(EmployeePhone, 4, 3) + '-' + SUBSTRING(EmployeePhone, 6 ,4)
As EmployeePhone from Employee;

--4
Select format(EmployeeHourlyPayRate, '$ #,##.00') as EmployeePosition from EmployeePosition

--5
Select * 
from Employee 
where EmployeeHireDate between '1/1/2013' and '1/1/2015'
Order by EmployeeHireDate

--6
Select PositionKey, EmployeeHourlyPayRate, cast(EmployeeHourlyPayRate as decimal (10,2)) * 40 Total from EmployeePosition


--7, 8, 9
Select Max(EmployeeHourlyPayRate) as HighestRate from EmployeePosition
Select Min(EmployeeHourlyPayRate) as LowestRate from EmployeePosition
Select format(Avg(EmployeeHourlyPayRate), '$ #,##.00') as AverageRate from EmployeePosition

--10
Select PositionKey, format(Avg(EmployeeHourlyPayRate), '$ #,##.00') as AverageRate from EmployeePosition
Group by PositionKey

--11
Select Year(EmployeeHireDate) as [Year], Count(EmployeeHireDate) as [Count] from Employee
Group by Year(EmployeeHireDate) 
Select Month(EmployeeHireDate) as [Month], Count(EmployeeHireDate) as [Count] from Employee
Group by Month(EmployeeHireDate) 

--12
Select Datename(Month, EmployeeHireDate) [Month], Count(EmployeeHireDate) [Count] from employee
Group by Datename(Month, EmployeeHireDate)
Order by [Count]

--13
Select PositionKey, format(Avg(EmployeeHourlyPayRate), '$ #,##.00') as AverageRate from EmployeePosition
Group by PositionKey
Having Avg(EmployeeHourlyPayRate) > 50

--14
Select count(Riders) as TotalRiders from Ridership

--15
Select * from sys.Tables

--16
select * from sys.databases