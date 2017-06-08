--assignment11
use MetroAlt

--1
--Create a Schema called "ManagementSchema."
go
Create Schema ManagementSchema

--2
--Create a view owned by the schema that shows the annual ridership.
Create view ManagementSchema.AnnualRidership
as
select RidershipKey, BusScheduleAssigmentKey, Riders from Ridership

--3
--Create a view owned by the schema that shows the employee information including their position and pay rate.
go
Create view ManagementSchema.EmployeeInfo as
select EmployeeLastName, EmployeeFirstName, EmployeeAddress, 
		EmployeeCity, EmployeeZipCode, EmployeePhone, 
		EmployeeEmail, EmployeeHireDate, ep.EmployeeKey, 
		PositionKey, EmployeeHourlyPayRate, EmployeePositionDateAssigned
from Employee e 
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey

--4
--Create a role ManagementRole.
Create role ManagementRole

--5
--Give the ManagementRole select permissions on the ManagementSchema and Exec permissions 
--on the new employee stored procedure we created earlier.
go
Grant select on schema:: ManagementSchema to ManagementRole
Grant select on AnnualRidership to ManagementRole
Grant select on EmployeeInfo to ManagementRole

--6
--Create a new login for one of the employees who holds the manager position.
Create Login ManagersLogin with password = 'P@ssw0rd1', default_database = MetroAlt

--7
--Create a new user for that login.
Create user ManagerLogin for login ManagersLogin

--8
--Add that user to the Role.
Alter role ManagerRole add member ManagerLogin
alter user ManagerRole with default_schema = ManagerSchema

--9
--Login to the database as the new User, 
--(Remember that SQL server authentication must be enabled for this to work.) 

--10, 11
--#10 and #11 doesnt work by executing the lines. I had to manually go into the MetroAlt security
--and gave the membership to ManagementRole. After doing that, 10 and 11 worked totally fine.
--I'm not sure why they arent automatically giving the permission for that.

--12
--Back up the database MetroAlt.
Backup database MetroAlt
to disk = 'C:\Backups\MetroAlt.bak'
