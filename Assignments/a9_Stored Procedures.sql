use MetroAlt

--1
go
Create procedure usp_Employee
@EmployeeLastName nvarchar(255), 
@EmployeeFirstName nvarchar(255), 
@EmployeeAddress nvarchar(255), 
@EmployeeCity nvarchar(255), 
@EmployeeZipCode nchar(9),
@EmployeePhone nvarchar(255)=null, 
@EmployeeEmail nvarchar(255), 
@EmployeeHourlyRate decimal(5,2)

As
If not exists (Select EmployeeKey from Employee
				where EmployeeEmail = @EmployeeEmail)

begin 
Declare @email nvarchar(255)
Set @email = dbo.fx_EmployeeEMail(@EmployeeFirstName, @EmployeeLastName)
Declare @payrate decimal(5,2)
set @payrate = dbo.fx_newEmployeePayRate(max(@EmployeeHourlyRate), min(@EmployeeHourlyRate))

Begin try
Begin tran

Insert into Employee(EmployeeLastName, EmployeeFirstName, 
						EmployeeAddress, EmployeeCity,
						EmployeeZipCode, EmployeePhone, EmployeeEmail,
						EmployeeHireDate)
values (@EmployeeLastName, @EmployeeFirstName, @EmployeeAddress, 
		@EmployeeCity, @EmployeeZipCode,
			@EmployeePhone, @email, Getdate())

Insert into EmployeePosition(EmployeeHourlyPayRate)
values (@payrate)
 
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

--2 
go
Create procedure usp_UpdateEmployeeInfo
@EmployeeKey int,
@EmployeeLastName nvarchar(255), 
@EmployeeFirstName nvarchar(255), 
@EmployeeAddress nvarchar(255), 
@EmployeeCity nvarchar(255), 
@EmployeeZipCode nchar(9),
@EmployeePhone nvarchar(255)=null

As
begin try
begin tran
Update Employee
Set EmployeeLastName = @EmployeeLastName,
	EmployeeFirstName = @EmployeeFirstName,
	EmployeeAddress = @EmployeeAddress,
	EmployeeCity = @EmployeeCity,
	EmployeeZipCode = @EmployeeZipCode,
	EmployeePhone = @EmployeePhone
Where EmployeeKey = @EmployeeKey

Commit Tran
End try
Begin Catch
Rollback Tran
Print error_message()
end catch

Select * from Employee

exec usp_UpdateEmployeeInfo
@EmployeeKey = 500,
@EmployeeLastName = 'Carmel',
@EmployeeFirstName = 'Bob',
@EmployeeAddress = '213 Walnut Street',
@EmployeeCity = 'Bellevue',
@EmployeeZipCode = '98002'

Select * from Employee where EmployeeKey = 500