--assignment12
use MetroAlt

--1
--Alter the table MaintenanceDetail. Drop the column MaintenanceNotes.
Alter table MaintenanceDetail
drop column MaintenanceNote

--2
--Create a new xml schema collection called "MaintenanceNoteSchemaCollection" 
--using the following schema:
Create xml Schema collection MaintenanceNoteSchemaCollection
as
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified" 
           targetNamespace="http://www.metroalt.com/maintenancenote" 
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="maintenancenote">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="title" />
        <xs:element name="note">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="p" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="followup" />
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'

--3
--Now alter the table MaintenanceDetail. 
--Add the column MaintenanceNotes as XML using the Schema "MaintenanceNoteSchemaCollection". 
Alter table MaintenanceDetail
Add MaintenanceNote xml (MaintenanceNoteSchemaCollection)

--4
--Insert a record using the xml above and then add two more records.
Insert into Maintenance(MaintenanceDate, BusKey)
Values (GETDATE(), 2)

Insert into MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNote)
values (IDENT_CURRENT('Maintenance'), 74, 2,
'<?xml version="1.0" encoding="utf-8"?>
<maintenancenote xmlns="http://www.metroalt.com/maintenancenote">
  <title>Hydralic units; Wear and Tear found on hydralic units</title>
<note>
  <p>The hydralic units are showing signs of stress</p>
  <p>I recommend the replacement of the units</p>
</note>
  <followup>Schedule replacement for June 2016</followup>
</maintenancenote>')

Insert into Maintenance(MaintenanceDate, BusKey)
Values (GETDATE(), 3)

Insert into MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNote)
values (IDENT_CURRENT('Maintenance'), 71, 3,
'<?xml version="1.0" encoding="utf-8"?>
<maintenancenote xmlns="http://www.metroalt.com/maintenancenote">
	<title>Tire replacement</title>
<note>
  <p>Tire replacement is required for the bus.</p>
  <p>Overall maintenance of bus is also asked.</p>
</note>
  <followup>Schedule replacement for March 2017</followup>
</maintenancenote>')

--5
--Set up an xquery that searches for one of the titles
Select MaintenanceKey, EmployeeKey, BusServiceKey, 
MaintenanceNote.query('declare namespace mn="http://www.metroalt.com/maintenancenote";
//mn:maintenancenote/mn:title') as Title from MaintenanceDetail