use Community_Assist

--temp table

Create table #TempPerson --temporary table 
						 --(used when to make change in a table structure...while it already has data)
(
	PersonKey int,
	PersonLastName nvarchar(255),
	PersonFirstName nvarchar(255),
	PersonEmail nvarchar(255)
)

insert into #TempPerson (PersonKey, PersonLastName, PersonFirstName, PersonEmail)
select PersonKey, PersonLastName, PersonFirstName, PersonEmail
from Person

Select * from #TempPerson
-----------------------------------------------------------------------------------------------
create table ##GlobalTempPerson --Other people can see when they are logged in (when it exists)
(
	PersonKey int,
	PersonLastName nvarchar(255),
	PersonFirstName nvarchar(255),
	PersonEmail nvarchar(255)
)
insert  ##GlobalTempPerson (PersonKey, PersonLastName, PersonFirstName, PersonEmail)
select PersonKey, PersonLastName, PersonFirstName, PersonEmail
from Person

Select * from ##GlobalTempPerson
------------------------------------------------------------------------------------------------
--scalar function (only returns one value)
go
create function fx_cube
(@number int)
returns int
As
begin
Declare @cube int
Set @cube = @number * @number * @number
return @cube
End

Select dbo.fx_cube(7) as [cube]
---------------------------------------------------------------
go
create function fx_OneLineAddress
(
	@Apartment nvarchar(255),
	@Street nvarchar(255),
	@City nvarchar(255),
	@State nchar(2),
	@Zip nchar(9)
)
returns nvarchar(255)
as
Begin
Declare @address nvarchar(255)
if @Apartment is null
	Begin
		set @address = @Street + ', ' + @City + ', ' + @State + ' ' + @Zip
	End
else
	begin
		set @address = @Street + ' ' + @Apartment + ' ' + @street + ', ' + @City + ', ' + @State + ' ' + @Zip
	end
return @address

End

Select PersonLastName, dbo.fx_OneLineAddress 
(PersonAddressApt, PersonAddressStreet, PersonAddressCity, PersonAddressState, PersonAddressZip) as [Address]
From Person P
inner join PersonAddress pa
on p.Personkey = pa.personKey
---------------------------------------------------------------------------
Create Function fx_RequestVsAllocationAmounts
(
	@Request money,
	@Allocation money
)
returns money
as
Begin
return @Request-@Allocation
End

select gr.GrantRequestKey, GrantRequestDate, 
GrantRequestAmount, GrantAllocationAmount,
dbo.fx_RequestVsAllocationAmounts(GrantRequestAmount, GrantAllocationAmount) as [difference]
From GrantRequest gr
inner join GrantReview grv
on gr.GrantRequestKey = grv.GrantRequestKey

select GrantTypeKey, year(GrantRequestDate) as [Year], 
sum(GrantRequestAmount) as [Request], sum(GrantAllocationAmount) as Allocated,
sum(dbo.fx_RequestVsAllocationAmounts(GrantRequestAmount, GrantAllocationAmount)) as [difference]
From GrantRequest gr
inner join GrantReview grv
on gr.GrantRequestKey = grv.GrantRequestKey
group by GrantTypeKey, Year(GrantRequestDate)