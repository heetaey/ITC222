--trigger
--events insert update and delete

use Community_Assist

go
Create trigger tr_OneTimeMaximum on GrantRequest
Instead of insert
as
--declare variables
Declare @OneTimeMax money
Declare @GrantType int
Declare @RequestAmount money

--assign values from inserted and GrantType
Select @GrantType = GrantTypeKey from inserted
Select @OneTimeMax = GrantTypeMaximum from GrantType where GrantTypeKey = @GrantType
Select @RequestAmount = GrantRequestAmount from inserted

if @RequestAmount <= @OneTimeMax
begin
Insert into GrantRequest(GrantRequestDate, PersonKey, GrantTypeKey, 
					GrantRequestExplanation, GrantRequestAmount)
select GrantRequestDate, PersonKey, GrantTypeKey, 
					GrantRequestExplanation, GrantRequestAmount
from inserted
end

Else
begin
if not exists
	(Select name from sys.tables where name = 'DumpTable')
	begin
	create table Dumptable
	(
		GrantRequestDate Datetime,
		PersonKey int,
		GrantTypeKey int,
		GrantRequestExplanation nvarchar(255),
		GrantRequestAmount money
	)
	end

insert into Dumptable (GrantRequestDate, PersonKey, GrantTypeKey, 
					GrantRequestExplanation, GrantRequestAmount)
	select GrantRequestDate, PersonKey, GrantTypeKey, 
					GrantRequestExplanation, GrantRequestAmount from inserted
end

Go
insert into GrantRequest(GrantRequestDate, PersonKey, GrantTypeKey, 
					GrantRequestExplanation, GrantRequestAmount)
values (GetDate(), 1, 1, 'Hungry', 250)

select * from GrantRequest
select * from DumpTable

Create table #TempTable
	(
		GrantRequestDate Datetime,
		PersonKey int,
		GrantTypeKey int,
		GrantRequestExplanation nvarchar(255),
		GrantRequestAmount money
	)

Begin tran
insert into GrantRequest(GrantRequestDate, PersonKey, GrantTypeKey, 
					GrantRequestExplanation, GrantRequestAmount)
values (GetDate(), 4, 1, 'Hungry', 250)
RollBack tran

go
Create trigger tr_testInsert on Donation
after insert
As
Declare @Confirm UniqueIdentifier = newId()
Declare @Amount money
Select @Amount = DonationAmount from inserted
if @Amount < 1000
begin
Declare @Id int = ident_current('Donation')
update Donation
set DonationConfirmation = @Confirm
where DonationKey = @Id
end

insert into Donation(PersonKey, DonationDate, DonationAmount)
values (2, getdate(), 900)
select * from Donation

drop trigger tr_testInsert