--XML

use MetroAlt
Create table Maintenance
(
	MaintenanceKey int identity(1,1) primary key,
	MaintenanceDate date not null,
	BusKey int foreign key references Bus(BusKey)
)

Create table MaintenanceDetail
(
	MaintenanceDetailKey int identity(1,1) primary key,
	MaintenanceKey int foreign key references Maintenance(MaintenanceKey),
	EmployeeKey int foreign key references Employee(EmployeeKey),
	BusServiceKey int,
	MaintenanceNotes nvarchar(255)
)

Create xml schema collection MaintenanceNotesSchema
as
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" targetNamespace="http://www.metroalt.com/maintenanceNotes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="maintenanceNotes">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="comments">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="comment" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="actions">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="action" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'

Alter table MaintenanceDetail
drop column MaintenanceNotes

Alter table MaintenanceDetail
Add MaintenanceNotes xml (MaintenanceNotesSchema)

Insert into Maintenance(MaintenanceDate, BusKey)
Values (getdate(), 1)

Insert into MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNotes)
values (IDENT_CURRENT('Maintenance'), 69, 1,
'<?xml version="1.0" encoding="utf-8"?>
<maintenanceNotes xmlns="http://www.metroalt.com/maintenanceNotes">
  <comments>
    <comment>Bus stinks</comment>
    <comment>Broken back seats.</comment>
  </comments>
  <actions>
    <action>Have bus cleaned and interior repaired</action>
    <action></action>
  </actions>
</maintenanceNotes>')

select top 10 EmployeeLastName, EmployeeFirstName, EmployeeEmail from Employee
for xml raw

--values as elements...preferred by Steve (adds 'Employees' as root)
select top 10 EmployeeLastName, EmployeeFirstName, EmployeeEmail from Employee
for xml raw('Employee'), elements, root('Employees')

select top 10 EmployeeLastName, EmployeeFirstName, EmployeeEmail, PositionName, EmployeeHourlyPayRate 
from Employee inner join EmployeePosition
on Employee.EmployeeKey = EmployeePosition.EmployeeKey
inner join Position 
on Position.PositionKey = EmployeePosition.PositionKey
for xml auto, elements, root('Employees')

--
Select MaintenanceKey, EmployeeKey, BusServiceKey,
MaintenanceNotes.query('declare namespace mn="http://www.metroalt.com/maintenanceNotes";
//mn:maintenanceNotes/mn:comments/*') as comments from MaintenanceDetail