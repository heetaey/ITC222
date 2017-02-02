Use MetroAlt

Create database Assignment1

use Assignment1

create table BusService
(
	BusServiceKey int identity(1,1) primary key,
	BusServiceName nvarchar(255) not null,
	BusServiceDescription nvarchar(255),
)

create table Maintenance
(
	MaintenanceKey int identity(1,1) primary key,
	MaintenanceDate date not null,
	Buskey int not null foreign key references BusService(BusServiceKey),
)

create table MaintenanceDetail
(
	MaintenanceDetailKey int identity(1,1),
	MaintenanceKey int not null,
	EmployeeKey int not null,
	BusServiceKey int not null,
	MaintenanceNotes nvarchar(255)
)

alter table MaintenanceDetail
Add constraint Pk_MaintenanceDetail primary key (MaintenanceDetailKey)

alter table MaintenanceDetail
add constraint Fk_MaintenanceKey foreign key (MaintenanceKey) references Maintenance(MaintenanceKey)

alter table MaintenanceDetail
add constraint Fk_EmployeeKey foreign key (EmployeeKey) references Maintenance(MaintenanceKey)

alter table MaintenanceDetail
add constraint Fk_BusServiceKey foreign key (BusServiceKey) references Bus(Buskey)

alter table BusType
add BusTypeAccessible BIT

alter table Employee
Add constraint unique_email unique (EmployeeEmail)