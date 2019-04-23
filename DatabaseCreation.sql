create schema proj4

DROP TABLE proj4.AssignmentSubmission
DROP TABLE proj4.Assignment
DROP TABLE proj4.CourseAttendee
DROP TABLE proj4.Course
DROP TABLE proj4.Student
DROP TABLE proj4.Instructor
DROP TABLE proj4.Department



CREATE TABLE proj4.Department
(
DepartmentId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
DepartmentName NVARCHAR(64) NOT NULL,
Head NVARCHAR(64) NOT NULL,
[Location] NVARCHAR(64) NOT NULL,
[Description] NVARCHAR(64) NOT NULL

UNIQUE(DepartmentName, Head)
);

CREATE TABLE proj4.Instructor
(
InstructorId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
InstructorName NVARCHAR(64) NOT NULL,
Office NVARCHAR(64) NOT NULL,
OfficeHours NVARCHAR(64) NOT NULL,
DepartmentId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Department(DepartmentId)

UNIQUE(Office, OfficeHours)
);

CREATE TABLE proj4.Student
(
StudentId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
DepartmentId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Department(DepartmentId),
[Name] NVARCHAR(64) NOT NULL,
Gpa FLOAT NOT NULL,
[Hours] INT NOT NULL
);

CREATE TABLE proj4.Course
(
CourseId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
DepartmentId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Department(DepartmentId),
InstructorId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Instructor(InstructorId),
[Time] DATETIME NOT NULL,
[Location] NVARCHAR(64) NOT NULL,
[Description] NVARCHAR(64) NOT NULL,
[Hours] INT NOT NULL

UNIQUE([Time], [Location])
);


CREATE TABLE proj4.CourseAttendee
(
CAID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
CourseId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Course(CourseId),
StudentId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Student(StudentId),
Grade FLOAT NOT NULL

);

CREATE TABLE proj4.Assignment
(
AssignmentId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
CourseId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Course(CourseId),
PointsPossible FLOAT NOT NULL,
AssignmentName NVARCHAR(64) NOT NULL,
DueDate DATETIME NOT NULL,
[Description] NVARCHAR(64) NOT NULL

);

CREATE TABLE proj4.AssignmentSubmission
(
SubmissionId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
AssignmentId INT NOT NULL FOREIGN KEY
	REFERENCES proj4.Assignment(AssignmentId),
PointsEarned FLOAT NOT NULL,
CAID INT NOT NULL FOREIGN KEY
	REFERENCES proj4.CourseAttendee(CAID),
Submission NVARCHAR(1024) NOT NULL,

);