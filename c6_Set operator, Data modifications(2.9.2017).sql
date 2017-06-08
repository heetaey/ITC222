use Community_Assist

--set operators
--data modifications
--Windows function


--union
Select PersonFirstName, PersonLastName, EmployeeHireDate
from Person p
inner join Employee e
on p.PersonKey = e.PersonKey
union
Select EmployeeFirstName, EmployeeLastName, EmployeeHireDate
from MetroAlt.dbo.Employee

--intersection
Select PersonAddressCity from PersonAddress
intersect
Select distinct EmployeeCity from MetroAlt.dbo.Employee

Select PersonAddressCity from PersonAddress
except
Select EmployeeCity from MetroAlt.dbo.Employee


/*************** 
Not on assignment
***************/
--ranking assignment
Select GrantRequestKey, GrantTypeKey, GrantRequestAmount,
ROW_NUMBER() over (order by GrantRequestAmount desc) as RowNumber,
Rank() over (order by GrantRequestAmount desc) as [Rank],
Dense_rank() over (order by GrantRequestAmount desc) as DenseRank,
Ntile(10) over (order by GrantRequestAmount desc) as [Ntile]
From GrantRequest
order by GrantRequestAmount desc

--windows partition function
Select distinct year(GrantRequestDate) as [Year], GrantTypeKey, 
sum (GrantRequestAmount) over () as TotalRequest,
sum (GrantRequestAmount) over (partition by year(GrantRequestDate)) as [AmountPerYear],
sum (GrantRequestAmount) over (partition by GrantTypeKey) as perGrantType
From GrantRequest
order by year(GrantRequestDate), GrantTypeKey

--Insert update delete
Insert into Person(PersonLastName, PersonFirstName, 
PersonEmail, PersonEntryDate)
Values('Conger', 'Steve', 'steve@gmail.com', getdate())

Insert into PersonAddress(PersonAddressApt, PersonAddressStreet, 
PersonAddressCity, PersonAddressState, PersonAddressZip, PersonKey)
values(null, '1701 Broadway', 'Seattle', 'WA', '98122', IDENT_CURRENT('Person')) 
--ident_current return last identitiy created.

--insert bunch of values
Insert into Person(PersonLastName, PersonFirstName, 
PersonEmail, PersonEntryDate)
values('Simpson', 'Bart', 'bart@fox.com', GETDATE()),
('Simpson', 'Homer', 'Homer@fox.com', GETDATE()),
('Simpson', 'Lisa', 'Lisa@fox.com', GETDATE())

Select * from Person

--update ; for data
Begin tran -- safety stuff..
update Person
Set PersonFirstName = 'Jason',
PersonEmail = 'jasonanderson@gmail.com'
where PersonKey = 1 -- crucial as without this, it will change everything.

commit tran
rollback tran

--create, alter, drop ; for table.