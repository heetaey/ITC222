use MetroAlt

select * from Employee

select EmployeeLastName, EmployeeFirstName,EmployeeEmail from Employee

select EmployeeLastName from Employee
Order by EmployeeLastName asc

select * from Employee
order by EmployeeHireDate asc

select * from Employee
where EmployeeCity = 'Seattle'

select * from Employee
where EmployeeCity != 'Seattle'

select * from Employee
where EmployeePhone is null

select * from Employee
where EmployeePhone is not null

select * from Employee
where EmployeeLastName like 'C%'


Select EmployeeKey, EmployeeHourlyPayRate from EmployeePosition
order by EmployeeHourlyPayRate desc

select EmployeeKey, EmployeeHourlyPayRate from EmployeePosition
where PositionKey = 2

select top 10 EmployeeKey, EmployeeHourlyPayRate from EmployeePosition
order by EmployeeHourlyPayRate desc

select EmployeeKey, EmployeeHourlyPayRate from EmployeePosition
order by EmployeeHourlyPayRate desc
Offset 20 rows Fetch next 10 rows only

Select distinct BusDriverShiftKey, BusRouteKey from BusScheduleAssignment
