use MetroAlt
--1
Select PositionName Position, Count(PositionName) [Count]
from
(select PositionName from Position p
inner join EmployeePosition e
on p.PositionKey = e.PositionKey) as PositionCount
group by PositionName


--2
Select Year(EmployeeHireDate) [Assigned Date], count(EmployeeHireDate) [Count]
from 
(select EmployeeHireDate from Employee e
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey) as HireDate
group by year(EmployeeHireDate);


--3
with PositionCount as
(
	Select PositionName from Position p
	inner join EmployeePosition ep
	on p.PositionKey = ep.PositionKey
)
Select PositionName, Count(PositionName) [Count]
From PositionCount
Group by PositionName


--4
go
with HireDate as
(
	Select EmployeeHireDate from Employee e
	inner join EmployeePosition ep
	on e.EmployeeKey = ep.EmployeeKey
)
Select Year(EmployeeHireDate) [Assigned Date], count(EmployeeHireDate) [Count]
From HireDate
Group by year(EmployeeHireDate)

--5
Declare @BusBarn int
set @BusBarn = 3

Select BusTypeKey, BusTypeDescription, [Count], BarnKey from 
(Select bt.BusTypeKey, BusTypeDescription, count(BusTypeDescription) [Count], BusBarnKey BarnKey
from Bustype bt
inner join Bus b
on bt.BusTypeKey = b.BusTypekey
group by bt.BusTypeKey, BusTypeDescription, BusBarnKey) as BusTypes
where BarnKey = @BusBarn

--6Create a View of Employees for Human Resources 
--it should contain all the information in the Employee table plus 
--their position and hourly pay rate
Create view vw_Employees

As
Select EmployeeLastName LastName,
EmployeeFirstName FirstName,
EmployeeAddress [Address],
EmployeeCity City,
EmployeeZipCode ZipCode,
EmployeePhone Phone,
EmployeeEmail Email,
EmployeeHireDate HireDate,
EmployeeHourlyPayRate [PayRate],
PositionName [Position]
From Employee e
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position p
on p.PositionKey = ep.PositionKey

go
Select * from vw_Employees


--7
Alter view vw_Employees with schemabinding

As
Select EmployeeLastName LastName, EmployeeFirstName FirstName, EmployeeAddress [Address],
EmployeeCity City, EmployeeZipCode ZipCode, EmployeePhone Phone, EmployeeEmail Email,
EmployeeHireDate HireDate, EmployeeHourlyPayRate [PayRate], PositionName [Position]
From dbo.Employee e
inner join dbo.EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join dbo.Position p
on p.PositionKey = ep.PositionKey

go


--8
Alter view Schedules

As
Select BusDriverShiftName ShiftName, BusScheduleAssignmentDate ShiftDate, 
EmployeeFirstName FirstName, EmployeeLastName LastName, BusRouteKey, BusKey
From Employee e
inner join BusScheduleAssignment bs
on e.EmployeeKey = bs.EmployeeKey
inner join BusDriverShift bss
on bs.BusDriverShiftKey = bss.BusDriverShiftKey

Select * from Schedules where LastName = 'Pangle' and FirstName = 'Neil'
and Year(ShiftDate) = '2014' and Month(ShiftDate) = '10'


--9
create function fx_EmployeeCity
(@EmployeeCity nvarchar(255)) 
returns table
as
Return
Select EmployeeKey, EmployeeLastName LastName, EmployeeFirstName FirstName, EmployeeAddress [Address],
EmployeeCity City, EmployeeZipCode ZipCode, EmployeePhone Phone, EmployeeEmail Email,
EmployeeHireDate HireDate
From Employee e

Select LastName, FirstName, ZipCode from dbo.fx_EmployeeCity('Seattle')


--10
Select distinct e.EmployeeKey, e.EmployeeLastName, e.EmployeeFirstName, c.BusScheduleAssignmentDate
from Employee as e
cross apply
(Select EmployeeKey, EmployeeLastName, EmployeeFirstName, BusScheduleAssignmentDate
from BusScheduleAssignment bs
where e.EmployeeKey = bs.EmployeeKey
order by EmployeeKey desc, BusScheduleAssignmentDate desc
offset 0 rows fetch first 4 rows only) as c
 