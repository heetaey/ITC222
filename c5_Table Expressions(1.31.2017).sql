--table Expressions
--a sub query in the from clause -- querying a result set

use Community_Assist

Select PersonKey, [Last], [First], City
from
(Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City from Person p
inner join PersonAddress pa
on p.PersonKey = pa.PersonKey
where PersonAddressCity = 'Bellevue') as BellevueResidents

Select PersonKey, [Last], [First], City from
(Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City 
from Person p
inner join PersonAddress pa 
on p.PersonKey = pa.PersonKey) as Residents
where City = 'Bellevue'


Select RequestMonth [Request Month], GrantTypeName, Count(GrantTypeName) as [Count]
from
(Select Month(GrantRequestDate) RequestMonth, GrantTypeName
	From GrantRequest gr
	inner join GrantType gt
	on gt.GrantTypeKey = gr.GrantTypeKey) as GrantTypeCount
group by RequestMonth, GrantTypeName


--CTE (Common Table Expression)
go
with Residents as
(
	Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City 
	from Person p
	inner join PersonAddress pa 
	on p.PersonKey = pa.PersonKey
)
Select PersonKey, [Last], [First], City From Residents Where City = 'Kent' 


with GrantCount as
(
	Select Month(GrantRequestDate) RequestMonth, GrantTypeName
	From GrantRequest gr
	inner join GrantType gt
	on gt.GrantTypeKey = gr.GrantTypeKey
)
Select RequestMonth, GrantTypeName, Count(GrantTypeName) [Count]
From GrantCount
Group by RequestMonth, GrantTypeName


Declare @City nvarchar(255) -- variable starts with @
set @City = 'Kent'

Select PersonKey, [Last], [First], City from
(Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City 
from Person p
inner join PersonAddress pa 
on p.PersonKey = pa.PersonKey) as Residents
where City = @City

--views
go
Alter view vw_Employees

As
Select PersonLastName LastName, PersonFirstName FirstName, EmployeeHireDate HireDate, EmployeeAnnualSalary Salary, PositionName [Position]
From Person p
inner join Employee e
on p.PersonKey = e.PersonKey
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position po
on po.PositionKey = ep.PositionKey

go
Select LastName, FirstName, Position from vw_Employees

/*
Insert or update through view if no column is aliased
no joins
*/

Alter view vw_Employees with schemabinding

As
Select PersonLastName LastName, PersonFirstName FirstName, EmployeeHireDate HireDate, EmployeeAnnualSalary Salary, PositionName [Position]
From dbo.Person p
inner join dbo.Employee e
on p.PersonKey = e.PersonKey
inner join dbo.EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join dbo.Position po
on po.PositionKey = ep.PositionKey

go
Create schema Donor

--limit audiences to see the DonorInfo
Create view Donor.vw_DonorInfo
as
Select PersonLastName, PersonFirstName, PersonEmail, DonationDate, DonationAmount
from Person p 
inner join Donation d
on p.PersonKey = d.PersonKey
go

--table valued function
create function fx_EmployeeGrants
(@EmployeeKey int)
returns table
as
Return
Select gr.GrantRequestKey, GrantRequestDate, 
	GrantReviewDate, PersonKey, GrantRequestExplanation,
	GrantRequestAmount, GrantAllocationAmount
from GrantRequest gr
inner join GrantReview gv
on gr.GrantRequestKey = gv.GrantRequestKey
Where EmployeeKey = @EmployeeKey

Select sum(GrantRequestAmount) Request, Sum(GrantAllocationAmount) allocation 
from dbo.fx_EmployeeGrants(2)

Select distinct employeeKey from GrantReview

--cross apply
Select distinct g.GrantTypeKey, c.GrantRequestAmount
From dbo.GrantRequest as g
Cross apply 
(Select GrantTypeKey, GrantRequestAmount, GrantRequestKey
from GrantRequest r
where g.GrantTypeKey = r.GrantTypeKey
order by GrantRequestAmount desc, GrantTypeKey desc
offset 0 rows fetch first 3 rows only) as c