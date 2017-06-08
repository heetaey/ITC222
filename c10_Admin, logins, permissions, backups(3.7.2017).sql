--adminstrative
--logins and users
--schema
--roles // permissions
--backup database
--authentication, authorization

Create Login EmployeesLogin with password =  'P@ssw0rd1', default_database = Community_Assist
Create User EmployeeLogin for login EmployeesLogin

--schema : collection of objects ownership of objects
go
create schema EmployeeSchema
go
create view EmployeeSchema.EmployeeInfo
as
Select PersonLastName, PersonFirstName, PersonEmail, 
	EmployeeHireDate, EmployeeAnnualSalary, PositionName
from Person p
inner join Employee e
on p.PersonKey = e.PersonKey
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position po
on po.PositionKey = ep.PositionKey

go
create view EmployeeSchema.GrantRequests
as 
select
gr.GrantRequestKey, GrantRequestDate, PersonKey,
	GrantTypeKey, GrantRequestExplanation, GrantRequestAmount,
	GrantReviewKey, GrantReviewDate, GrantRequestStatus, 
	GrantAllocationAmount, EmployeeKey
from GrantRequest gr 
inner join GrantReview r
on gr.GrantRequestKey = r.GrantRequestKey

--giving permissions
Create role EmployeeRole
go
Grant Select on schema :: EmployeeSchema to EmployeeRole 
Grant insert, update on GrantReview to EmployeeRole
Grant select on GrantType to EmployeeRole
--to EmployeeLogin
Alter role EmployeeRole add member EmployeeLogin

Alter user EmployeeLogin with default_schema = EmployeeSchema

--backup database
Backup database Community_Assist 
--file = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Community.Assist.mdb'
to disk = 'C:\Backups\Community.Assist.bak'

Restore database Community_Assist
from disk = 'C:\Backups\Community.Assist.bak'