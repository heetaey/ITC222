use Community_Assist
--stored Procedures
--register a new person
--check to see if person exists
--pass in all the info we need
--insert to person
	-- created seed
	-- hash the password
--insert into personAddress
--insert into person Contact 
--all or none happpens

--or 1 = 1; Drop table Student--

--version 1
Create procedure usp_Registration 
@PersonLastName nvarchar(255),
@PersonFirstName nvarchar(255),
@PersonEmail nvarchar(255),
@PersonPassWord nvarchar(20),
@PersonAddressApt nvarchar(255)=null,
@PersonAddressStreet nvarchar(255),
@PersonAddressCity nvarchar(255) = 'Seattle',
@PersonAddressState nchar(2) = 'WA',
@PersonAddressZip nchar(9),
@HomePhone nvarchar(255)=null,
@WorkPhone nvarchar(255)=null

As
Declare @seed int
Set @seed = dbo.fx_GetSeed()
Declare @pass varbinary(500)
Set @pass = dbo.fx_HashPassword(@seed, @PersonPassWord)

Insert into Person(PersonLastName, PersonFirstName,
					PersonEmail, PersonPassWord, 
					PersonEntryDate, PersonPassWordSeed)
Values(@PersonLastName, @PersonFirstName,
		@PersonEmail, @pass,
		GETDATE(), @seed)

Declare @PersonKey int
Set @PersonKey = IDENT_CURRENT('Person')

Insert into PersonAddress(PersonAddressApt, PersonAddressStreet, 
							PersonAddressCity, PersonAddressState,
							 PersonAddressZip, PersonKey)
Values (@PersonAddressApt, @PersonAddressStreet,
		@PersonAddressCity, @PersonAddressState,
		@PersonAddressZip, @PersonKey)

IF not @HomePhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values (@HomePhone, 1, @PersonKey)
End

IF not @WorkPhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values (@WorkPhone, 2, @PersonKey)
End

go
exec usp_Registration
@PersonLastName = 'Rezenor', @PersonFirstName = 'Trent', @PersonEmail = 'tresernor@gmail.com', 
@PersonPassWord = 'rPass', @PersonAddressStreet = '10010 NIN South', @PersonAddressCity = 'Renton', 
@PersonAddressZip = '98010', @HomePhone = '2062062066'

go--version 2
Alter procedure usp_Registration 
@PersonLastName nvarchar(255),
@PersonFirstName nvarchar(255),
@PersonEmail nvarchar(255),
@PersonPassWord nvarchar(20),
@PersonAddressApt nvarchar(255)=null,
@PersonAddressStreet nvarchar(255),
@PersonAddressCity nvarchar(255) = 'Seattle',
@PersonAddressState nchar(2) = 'WA',
@PersonAddressZip nchar(9),
@HomePhone nvarchar(255)=null,
@WorkPhone nvarchar(255)=null

As
Declare @seed int
Set @seed = dbo.fx_GetSeed()
Declare @pass varbinary(500)
Set @pass = dbo.fx_HashPassword(@seed, @PersonPassWord)

--Alters this part on ver.2
Begin try--
Begin tran

Insert into Person(PersonLastName, PersonFirstName,
					PersonEmail, PersonPassWord, 
					PersonEntryDate, PersonPassWordSeed)
Values(@PersonLastName, @PersonFirstName,
		@PersonEmail, @pass,
		GETDATE(), @seed)

Declare @PersonKey int
Set @PersonKey = IDENT_CURRENT('Person')

Insert into PersonAddress(PersonAddressApt, PersonAddressStreet, 
							PersonAddressCity, PersonAddressState,
							 PersonAddressZip, PersonKey)
Values (@PersonAddressApt, @PersonAddressStreet,
		@PersonAddressCity, @PersonAddressState,
		@PersonAddressZip, @PersonKey)

IF not @HomePhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values (@HomePhone, 1, @PersonKey)
End

IF not @WorkPhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values (@WorkPhone, 2, @PersonKey)
End

--Adds this part on ver.2
Commit tran
End try
Begin catch
Rollback tran
print Error_Message()
return -1
End catch

exec usp_Registration
@PersonLastName = 'Rogers', @PersonFirstName = 'Tina', @PersonEmail = 'tresernor@gmail.com', 
@PersonPassWord = 'rPass', @PersonAddressStreet = '10010 NIN South', @PersonAddressCity = 'Renton', 
@PersonAddressZip = '98010', @HomePhone = '2062062066'

--------------------------------------------------ver3
go
Alter procedure usp_Registration 
@PersonLastName nvarchar(255),
@PersonFirstName nvarchar(255),
@PersonEmail nvarchar(255),
@PersonPassWord nvarchar(20),
@PersonAddressApt nvarchar(255)=null,
@PersonAddressStreet nvarchar(255),
@PersonAddressCity nvarchar(255) = 'Seattle',
@PersonAddressState nchar(2) = 'WA',
@PersonAddressZip nchar(9),
@HomePhone nvarchar(255)=null,
@WorkPhone nvarchar(255)=null

As
--ver,3 here
IF not exists (Select PersonKey from Person
				where PersonEmail = @PersonEmail)

--if dont exist, go this process
Begin
Declare @seed int
Set @seed = dbo.fx_GetSeed()
Declare @pass varbinary(500)
Set @pass = dbo.fx_HashPassword(@seed, @PersonPassWord)

---------------------------------------------------ver.3
Begin try
Begin tran

Insert into Person(PersonLastName, PersonFirstName,
					PersonEmail, PersonPassWord, 
					PersonEntryDate, PersonPassWordSeed)
Values(@PersonLastName, @PersonFirstName,
		@PersonEmail, @pass,
		GETDATE(), @seed)

Declare @PersonKey int
Set @PersonKey = IDENT_CURRENT('Person')

Insert into PersonAddress(PersonAddressApt, PersonAddressStreet, 
							PersonAddressCity, PersonAddressState,
							 PersonAddressZip, PersonKey)
Values (@PersonAddressApt, @PersonAddressStreet,
		@PersonAddressCity, @PersonAddressState,
		@PersonAddressZip, @PersonKey)

IF not @HomePhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values (@HomePhone, 1, @PersonKey)
End

IF not @WorkPhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values (@WorkPhone, 2, @PersonKey)
End

--Adds this part on ver.2
Commit tran
End try
Begin catch
Rollback tran
print Error_Message()
return -1
End catch
End

Else 
Begin print 'Person already exists'
End

go
--update Procedure
Create proc usp_UpdatePersonInfo
@PersonKey int, @PersonLastName nvarchar(255), 
@PersonFirstName nvarchar(255), @PersonEmail nvarchar(255),
@PersonAddressApt nvarchar(255)=null, @PersonAddressStreet nvarchar(255), 
@PersonAddressCity nvarchar(255) = 'Seattle', @PersonAddressState nchar(2) = 'WA',
@PersonAddressZip nchar(9)

as
Begin try
Begin tran
update Person
Set PersonLastName = @PersonLastName,
	PersonFirstName = @PersonFirstName,
	PersonEmail = @PersonEmail
Where PersonKey = @PersonKey

update PersonAddress
set	PersonAddressApt = @PersonAddressApt,
	PersonAddressStreet = @PersonAddressStreet,
	PersonAddressCity = @PersonAddressCity,
	PersonAddressState = @PersonAddressState,
	PersonAddressZip = @PersonAddressZip
where PersonKey = @PersonKey
Commit Tran
End Try
Begin Catch
Rollback tran
print error_Message()
end catch

Select * from Person

exec usp_UpdatePersonInfo
@PersonKey = 4,
@PersonLastName = 'Carmel',
@PersonFirstName = 'Bob',
@PersonEmail = 'BobCarmel@gmail.com',
@PersonAddressStreet = '213 Walnut Street',
@PersonAddressCity = 'Bellevue',
@PersonAddressZip = '98002'

select * from PersonAddress where PersonKey = 4

Declare @PersonKeyb int
Select @PersonKeyb = PersonKey from Person
	where PersonEmail = 'BobCarmel@gmail.com'
print @PersonKeyb