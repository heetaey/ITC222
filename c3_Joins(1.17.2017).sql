--Joins
--Cross Joins
--Inner Joins
--Outer Joins

Use Community_Assist

Select PersonLastName, DonationAmount from Person, Donation

Select PersonLastName, DonationAmount 
From Person Cross Join Donation --preferred method

Select PersonLastName, PersonEmail, ContactNumber, DonationAmount
From Person, Contact, Donation
Where Person.PersonKey = Contact.PersonKey
And Person.PersonKey = Donation.PersonKey
And ContactTypeKey = 1

Select p.personKey, PersonLastName, PersonEmail, ContactNumber, DonationAmount
From Person p
inner Join Contact c
on p.PersonKey = c.PersonKey
inner Join Donation d
on p.PersonKey = d.PersonKey
Where ContactTypeKey = 1

Select * from GrantReview

Select Year(GrantRequestDate) [Year], GrantTypeName, Sum(GrantRequestAmount) as Request,
Sum(GrantAllocationAmount) as Granted, format(sum(GrantAllocationAmount) / sum(GrantRequestAmount), '###.00%') as Percentage

From GrantRequest gr
inner join GrantType gt
on gr.GrantTypeKey = gt.GrantTypeKey
inner join GrantReview gv
on gv.GrantRequestKey = gr. GrantRequestKey
Group by Year(GrantRequestDate), GrantTypeName
Order by Year(GrantRequestDate)

--outer
Select GrantTypeName, GrantRequest.GrantTypeKey From GrantType
Left outer join GrantRequest
on GrantType.GrantTypeKey = GrantRequest.GrantRequestKey
Where GrantRequest.GrantTypeKey is null

Select ContactTypeName, Contact.ContactTypeKey from ContactType
left outer Join Contact
on ContactType.ContactTypeKey = contact.ContactTypeKey
Where Contact.ContactTypeKey is null

Select distinct ContactTypeName, Contact.ContactTypeKey from ContactType
full Join Contact
on ContactType.ContactTypeKey = contact.ContactTypeKey
