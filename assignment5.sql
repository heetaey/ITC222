use MetroAlt

--1
Select e.EmployeeKey, EmployeeLastName, EmployeeFirstName, PositionName, EmployeeHourlyPayRate
from Employee e
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position p
on ep.PositionKey = p.PositionKey
Where EmployeeHourlyPayRate = (Select Max(EmployeeHourlyPayRate) from EmployeePosition)

--2
Select EmployeeKey, EmployeeLastName, EmployeeFirstName
from Employee
where EmployeeKey in (Select EmployeeKey from EmployeePosition
						where PositionKey in (Select PositionKey from Position
						where PositionName = 'Manager'))

--3
--User Ridership totals for the numbers. 
--The Total is the grand total for all the years. The Percent is Annual Total / Grand Total * 100


Select YEAR(BusScheduleAssignmentDate) as [Year], Sum(Riders) as AnnualTotal, Avg(Riders) as AnnualAverage, 
(Select Sum(Riders) from Ridership) as Total, Cast(Sum(Riders) as decimal(10,2)) / (Select Sum(Riders) from Ridership) * 100 as Percentage

from Ridership r
inner join BusScheduleAssignment b
on r.BusScheduleAssigmentKey = b.BusScheduleAssignmentKey
group by YEAR(BusScheduleAssignmentDate)

--4
create table EmployeeZ
(
EmployeeKey int,
EmployeeLastName nvarchar(255),
EmployeeFirstName nvarchar(255),
EmployeeEmail nvarchar(255)
)

Insert into EmployeeZ (EmployeeKey, EmployeeLastName, EmployeeFirstName, EmployeeEmail)
Select EmployeeKey, EmployeeLastName, EmployeeFirstName, EmployeeEmail 
from Employee Where EmployeeLastName like 'Z%'
group by EmployeeKey

--5
Select PositionKey, EmployeeKey, EmployeeHourlyPayRate 
from EmployeePosition ep1
where EmployeeHourlyPayRate = (Select Max(EmployeeHourlyPayRate) from EmployeePosition ep2
Where ep1.PositionKey = ep2.PositionKey)
Order by PositionKey
