--assignment10

use MetroAlt

--Create a trigger to fire when an employee is assigned to a second shift in a day. 
--Have it write to an overtime table. 
--the Trigger should create the overtime table if it doesn't exist.
--Add an employee for two shifts to test the trigger.

go
create trigger tr_OverTime on BusScheduleAssignment
Instead of insert

as
Declare @Employee int
Declare @ScheduleDate date
Declare @Count int

select @Employee = EmployeeKey from inserted
select @ScheduleDate = GetDate()
select @Count = count(@Employee) from BusScheduleAssignment
	where BusScheduleAssignmentDate = @ScheduleDate


if @count = 0
Begin
Insert into BusScheduleAssignment (BusDriverShiftKey, EmployeeKey, 
								BusRouteKey, BusScheduleAssignmentDate, BusKey)
select BusDriverShiftKey, EmployeeKey,
	 BusRouteKey, BusScheduleAssignmentDate, BusKey from inserted

End

Else
Begin
if not exists (Select name from sys.tables where name = 'OvertimeTable')
	begin
	create table OvertimeTable
	(
		BusDriverShiftKey int,
		EmployeeKey int,
		BusRouteKey int,
		BusScheduleAssignmentDate date,
		BusKey int
	)
	end

Insert into OvertimeTable(BusDriverShiftKey, EmployeeKey, 
								BusRouteKey, BusScheduleAssignmentDate, BusKey)
select BusDriverShiftKey, EmployeeKey,
	 BusRouteKey, BusScheduleAssignmentDate, BusKey from inserted

End

Go
Insert into BusScheduleAssignment (BusDriverShiftKey, EmployeeKey, 
								BusRouteKey, BusScheduleAssignmentDate, BusKey)
values (1, 1, 49, getdate(), 1)

select * from BusScheduleAssignment
select * from OvertimeTable