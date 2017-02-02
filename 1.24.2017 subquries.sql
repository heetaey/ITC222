--subquries
use Community_Assist


Select PersonLastName, PersonFirstName, EmployeeHireDate, PositionName 
from Person p
inner join Employee e
on p.PersonKey = e.PersonKey
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position ps
on ps.PositionKey = ep.PositionKey


Select DonationKey, DonationDate, PersonKey, DonationAmount
from Donation
Where DonationAmount = (Select Max(DonationAmount) from Donation) -- this clause cannot return more than a single value

Select GrantTypeName from GrantType
Where GrantTypeKey not in (Select GrantTypeKey from GrantRequest) -- outter join kind of line.

Select GrantTypeName from GrantType
Where GrantTypeKey not in (Select Personkey from GrantRequest) -- meaningless

Select PersonLastName, PersonFirstName, PersonEmail
from Person
Where PersonKey in (Select PersonKey from Employee)

Select PersonLastName, PersonFirstName, PersonEmail
from Person
inner join Employee
On Person.PersonKey = Employee.PersonKey

Select PersonFirstName, PersonLastName
from Person
Where PersonKey in (Select PersonKey from Employee 
						Where EmployeeKey in (Select EmployeeKey from GrantReview
						where GrantRequestStatus = 'Denied'))


Select GrantTypeName, Format(Sum(GrantRequestAmount), '$ #,##0.00') as SubTotal,
Format((Select Sum(GrantRequestAmount) from GrantRequest), '$ #,##.00') as Total, --subquries always have prenticies
Format(Sum(GrantRequestAmount) / (Select Sum(GrantRequestAmount) from GrantRequest), '#0.00') as Percentage

from GrantRequest gr
inner join GrantType gt
on gr.GrantTypeKey = gt.GrantTypeKey
group by GrantTypeName

Select GrantTypeKey, Avg(GrantRequestAmount)
From GrantRequest
Group by GrantTypeKey

--compare above for the result

--correlated subquery (inner query references outter query - cant run independently)
Select GrantTypeKey, GrantRequestAmount
From GrantRequest gr1
Where GrantRequestAmount > (Select Avg(GrantRequestAmount) from GrantRequest gr2 
Where gr1.GrantTypeKey = gr2.GrantTypeKey)
