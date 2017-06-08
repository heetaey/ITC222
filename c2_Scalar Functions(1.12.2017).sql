use Community_Assist

--scalar Functions
Select Year(GrantRequestDate) as [Year], GrantTypeKey, GrantRequestAmount
From GrantRequest;

Select Month(GrantRequestDate) as [Month], GrantTypeKey GrantType, GrantRequestAmount Amount
From GrantRequest;

Select Day(GrantRequestDate) as [Day], GrantTypeKey GrantType, GrantRequestAmount Amount
From GrantRequest

Select DATEPART(second, GrantRequestDate) from GrantRequest;
Select DATEDIFF(Day,GetDate(),'3/23/2017') [Days Left in current Quarter]
Select DonationAmount, cast(DonationAmount as decimal(10,2)) * .10 Operations, DonationAmount * 0.9 Charity From Donation

Select format(DonationAmount, '$ #,##0.00') as Amount from Donation

Declare @SocialSec as nchar(9)
select @SocialSec = '123456789'
Select Substring(@SocialSec, 1, 3) + '-' + SUBSTRING(@SocialSec, 4, 2) + '-' + SUBSTRING(@SocialSec, 6, 4)
As SSNumber

-- Aggregate Functions
Select sum(donationAmount) as total from Donation
Select avg(donationAmount) as total from Donation
Select max(donationAmount) as total from Donation
Select min(donationAmount) as total from Donation
Select Max(PersonLastName) as total from Person -- based on alphabet
--Max date should be the current, min will be the oldest

--Average donation for average types
Select GrantTypeKey, format(Avg(GrantRequestAmount), '$ #,##0.00') as Average,
format(sum(GrantRequestAmount), '$ #,##0.00') as total from GrantRequest
where GrantTypeKey = 5
Group by GrantTypeKey

Select GrantTypeKey, format(Avg(GrantRequestAmount), '$ #,##0.00') as Average,
format(sum(GrantRequestAmount), '$ #,##0.00') as total from GrantRequest
Where not GrantTypeKey = 2 -- or != // <>
Group by GrantTypeKey
Having Avg(GrantRequestAmount) > 400
373576369
select name from sys.Tables
Select * from sys.Tables
Select * from sys.all_columns where Object_id = 373576369
select * from sys.databases