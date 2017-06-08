Use Community_Assist

Select * from Person

Create database TestTables

use TestTables

create table Student
(
	StudentKey int identity(1,1) primary key, 
	StudentLastName nvarchar(255) not null,
	StudentFirstName nvarchar(255),
	StudentEmail nvarchar(255) not null,
)
/* Multiline comment*/
--this is inline comment!

Create table Course
(
	CourseKey int identity(1,1) primary key,
	CourseName nvarchar(255) not null,
	CourseCredits int default 5 --Course credit is default by '5'
)

Create table Section
(
	SectionKey int identity(1,1),
	CourseKey int not null foreign key references Course(CourseKey),
	SectionYear int not null,
	SectionQuarter nvarchar(7), 
	Constraint constraint_quarter check (SectionQuarter in ('Fall', 'Winter', 'Spring', 'Summer')),
	Constraint PK_SectionKey key (SectionKey)
)

Create table Roster
(
	RosterKey int identity(1,1) not null,
	SectionKey int not null,
	StudentKey int not null,
	RosterGrade decimal(2,1) null
)

Alter table Roster
Add Constraint PK_Roster primary key (RosterKey)

Alter table Roster
Add Constraint FK_Section foreign key (SectionKey)
References Section(SectionKey)

Alter table Roster
Add Constraint FK_Student foreign key (StudentKey)
References Student(StudentKey)

Alter table Roster
Add Constraint ck_Grade check (RosterGrade between 0 and 4)

Alter table Student
Add Constraint unique_email unique (StudentEmail) -- Makes all e-mails unique (prevent duplication)

Alter table Student
Add StudentId nvarchar(9)
