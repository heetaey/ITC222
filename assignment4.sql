Use MetroAlt

--1
Select distinct EmployeeFirstName, BusRouteZone from Employee, BusRoute
cross Join EmployeePosition
where PositionKey = 1

--2
Select BusTypeDescription, BusTypeCapacity, BusTypeEstimatedMPG, BusTypeAccessible, BusTypePurchasePrice
from Bustype
inner join BusBarn 
on BusBarnKey = 3

--3
Select format(sum(BusTypePurchasePrice), '$ #,##.00') as Total 

From Bus b
inner join BusType bt
on b.BusTypeKey = bt.BusTypeKey
inner join BusBarn bn
on b.BusBarnKey = bn.BusBarnKey
where bn.BusBarnKey = '3'

--4
Select BusTypeDescription as BusType, format(sum(BusTypePurchasePrice), '$ #,##.00') as Total 

From Bus b
inner join BusType bt
on b.BusTypeKey = bt.BusTypeKey
inner join BusBarn bn
on b.BusBarnKey = bn.BusBarnKey
where bn.BusBarnKey = '3'

Group by BusTypeDescription

--5
Select EmployeeLastName, EmployeeFirstName, EmployeeEmail, 
PositionName, EmployeeHourlyPayRate 

from Employee e
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position p 
on e.EmployeeKey = p.PositionKey

--6
Select distinct EmployeeLastName LastName, BusDriverShiftStartTime Start, 
BusDriverShiftStopTime [End], BusKey, BusTypeDescription BusType

from BusRoute br
inner join BusScheduleAssignment bsa
on br.BusRouteKey = bsa.BusRouteKey 
inner join BusDriverShift bs
on bsa.BusDriverShiftKey = bs.BusDriverShiftKey
inner join BusType bt
on bsa.BusKey = bt.BusTypeKey
inner join Employee e
on bsa.EmployeeKey = e.EmployeeKey 


--7
Select PositionName from Position p
left outer join EmployeePosition e
on p.PositionKey = e.PositionKey
where e.PositionKey is null

--8
Select e.EmployeeKey, EmployeeFirstName FirstName, EmployeeLastName LastName, PositionKey
from Employee e

inner join EmployeePosition ep 
on e.EmployeeKey = ep.EmployeeKey

left outer join BusScheduleAssignment bsa
on bsa.EmployeeKey = e.EmployeeKey
where ep.PositionKey = '1' and BusScheduleAssignmentKey is null
