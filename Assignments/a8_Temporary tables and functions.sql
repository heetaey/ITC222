use MetroAlt
--assignment8

--1
 Create table #TempStops
 (
	BusRouteKey int,
	BusRouteStopKey int
 )
insert into #TempStops (BusRouteKey, BusRouteStopKey)
select BusRouteKey, BusRouteStopKey
from BusRouteStops

select * from #TempStops

--2
Create table ##GlobalTempStops
(
	BusRouteKey int,
	BusRouteStopKey int
)

insert into ##GlobalTempStops (BusRouteKey, BusRouteStopKey)
select BusRouteKey, BusRouteStopKey
from BusRouteStops

select * from ##GlobalTempStops

--3
Go
Create function fx_EmployeeEmail
(
	@First nvarchar(255),
	@Last nvarchar(255)
)
returns nvarchar(255) as
Begin
Declare @email nvarchar(255)
	begin
		set @email = @First + '.' + @Last + '@metroalt.com'
	end
return @email
End

Select EmployeeFirstName, EmployeeLastName, 
dbo.fx_EmployeeEmail(EmployeeFirstName, EmployeeLastName) as Email
from Employee

--4
create function fx_checkcalc
(
	@day money,
	@week money
)
returns money
as
Begin
return @week * 2
End

Select EmployeeKey, PositionName, EmployeeHourlyPayRate, 
dbo.fx_checkcalc(EmployeeHourlyPayRate * 10, EmployeeHourlyPayRate * 50) as [2 Weeks Payrate]
From EmployeePosition ep
inner join Position p
on ep.PositionKey = p.PositionKey

--5
create function fx_newEmployeePayRate
(
	@High money,
	@Low money,
)
returns money
as
Begin
return @High - @Low
End

Select Max(EmployeeHourlyPayRate) as [Max Rate], Min(EmployeeHourlyPayRate) as [Min Rate],
dbo.fx_newEmployeePayRate(Max(EmployeeHourlyPayRate), MIN(EmployeeHourlyPayRate)) as [New Employee Wage]
from EmployeePosition ep
inner join Position p
on ep.PositionKey = p.PositionKey
where PositionName = 'Driver'