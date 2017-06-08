--assignment7

--1
Select PersonLastName, PersonFirstName, PersonEmail, PersonAddressStreet, 
PersonAddressCity, PersonAddressZip
from Person p
inner join PersonAddress pa
on p.PersonKey = pa.PersonKey
union
Select EmployeeLastName, EmployeeFirstName, EmployeeEmail, EmployeeAddress,
EmployeeCity, EmployeeZipCode
from MetroAlt.dbo.Employee

--2
Select PersonAddressCity from PersonAddress
intersect
Select EmployeeCity from MetroAlt.dbo.Employee

--3
Select PersonAddressCity from PersonAddress
except
Select EmployeeCity from MetroAlt.dbo.Employee

--4
Insert into BusService (BusServiceName, BusServiceDescription)
Values ('General Maintenance', 'Checking the overall status of the vehicle'),
('Brake Service', 'Check the status of brakes on buses'),
('Hydraulic Maintenance', ' '),
('Mechanical Repair', 'Repair')
select * from BusService

Insert into Maintenance (MaintenanceDate, BusKey)
Values (GETDATE(), 12), (GETDATE(), 24)

Insert into MaintenanceDetail(BusServiceKey, MaintenanceKey, EmployeeKey, MaintenanceNotes)
Values (1, 3, 60, 'General Maintenance'),
(2, 3, 60, 'Brake Service'),
(1, 4, 69, 'General Maintenance')

--5
use MetroAlt
Select [EmployeeLastName], [EmployeeFirstName],[EmployeeAddress],
[EmployeeCity],[EmployeeZipCode],[EmployeePhone],
[EmployeeEmail],[EmployeeHireDate] into Drivers
from MetroAlt.dbo.Employee e
inner join MetroAlt.dbo.EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
where PositionKey = '1'

--6
--Edit the record for Bob Carpenter (Key 3) so that his first name is Robert and is City is Bellevue
use MetroAlt
begin tran
update Person
Set PersonFirstName = 'Robert', PersonAddressCity = 'Bellevue'
where PersonKey = 3

commit tran
rollback tran

--7
--Give everyone a 3% Cost of Living raise.
begin tran
update EmployeePosition
set EmployeeHourlyPayRate = EmployeeHourlyPayRate * 1.03

--8
--Delete the position Detailer
begin tran
delete Position
where PositionName = 'Detailer'

commit tran
rollback tran