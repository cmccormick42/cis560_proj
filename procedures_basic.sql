-- Gets the GPA for a given student
CREATE OR ALTER PROCEDURE GetGpa @StudentId INT
AS
	SELECT S.StudentId, S.[Name], S.Gpa 
	FROM proj4.Student S
	WHERE S.StudentId = @StudentId
GO

-- Gets a list of assignments for given student and course
CREATE OR ALTER PROCEDURE GetStudentAssignmentsForCourse @StudentId INT, @CourseId INT
AS
	SELECT A.AssignmentId, A.PointsPossible, A.AssignmentName, A.DueDate, 
		A.[Description]
	FROM proj4.Assignment A
		INNER JOIN proj4.Course C ON C.CourseId = A.CourseId
		INNER JOIN proj4.CourseAttendee CA ON CA.CourseId = C.CourseId
	WHERE CA.StudentId = @StudentId
		AND CA.CourseId = @CourseId
	ORDER BY A.AssignmentId ASC
GO

-- Gets a student's grades for all classes
CREATE OR ALTER PROCEDURE GetStudentGradesForClasses @StudentId INT
AS
	SELECT C.CourseId, CA.Grade
	FROM proj4.CourseAttendee CA
		INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	WHERE CA.StudentId = @StudentId
	ORDER BY CA.Grade DESC
GO

-- Gets all assignments for a given student due on or before given date
CREATE OR ALTER PROCEDURE GetAssignmentsDueBeforeDay @StudentId INT, @Date DATETIME
AS
	SELECT A.CourseId, A.PointsPossible, A.AssignmentName, A.DueDate, 
		A.[Description]
	FROM proj4.Assignment A
		INNER JOIN proj4.CourseAttendee CA ON CA.StudentId = @StudentId
	WHERE A.DueDate <= @Date
	ORDER BY DueDate DESC
GO

-- Gets all student grades for a given course
CREATE OR ALTER PROCEDURE GetStudentGradesForCourse @CourseId INT
AS
	SELECT C.CourseId, S.[Name], CA.Grade
	FROM proj4.CourseAttendee CA
		INNER JOIN proj4.Student S ON S.StudentId = CA.StudentId
		INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	WHERE CA.CourseId = @CourseId
	ORDER BY S.[Name] ASC
GO

-- Gets a list of students who are missing a given assignment
CREATE OR ALTER PROCEDURE GetMissingSubmissions @AssignmentId INT
AS 
	SELECT A.AssignmentId, S.[Name]
	FROM proj4.CourseAttendee CA
		INNER JOIN proj4.AssignmentSubmission SUB ON SUB.CAID = CA.CAID
		INNER JOIN proj4.Student S ON S.StudentId = CA.StudentId
		INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
	WHERE A.AssignmentId = @AssignmentId 
		AND SUB.Submission IS NULL
	ORDER BY S.[Name]
GO

-- Gets the average grade for a course
CREATE OR ALTER PROCEDURE GetAverageCourseGrade @CourseId INT
AS
	SELECT CA.CourseId, SUM(CA.Grade)/(COUNT(CA.Grade)*100) AS AverageCourseGrade
	FROM proj4.CourseAttendee CA
	WHERE CA.CourseId = @CourseId
	GROUP BY CA.CourseId
GO

-- Gets the average grade for a course assignment
CREATE OR ALTER PROCEDURE GetAverageAssignmentGrade @CourseId INT, @AssignmentName NVARCHAR(50)
AS
	SELECT C.CourseId, A.AssignmentName,
		SUM(SUB.PointsEarned)/(A.PointsPossible*COUNT(SUB.SubmissionId)) AS AverageAssignmentGrade
	FROM proj4.AssignmentSubmission SUB 
		INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
		INNER JOIN proj4.Course C ON A.CourseId = C.CourseId
	WHERE A.AssignmentName = @AssignmentName
		AND C.CourseId = @CourseId
	GROUP BY C.CourseId, A.AssignmentName, A.PointsPossible
GO

-- Gets the average GPA for a given department
CREATE OR ALTER PROCEDURE GetDepartmentGpa @DepartmentName NVARCHAR(50)
AS
	SELECT D.DepartmentId, D.DepartmentName, 
		SUM(S.Gpa)/COUNT(S.Gpa) AS AverageGpa
	FROM proj4.Department D
		INNER JOIN proj4.Student S ON S.DepartmentId = D.DepartmentId
	WHERE D.DepartmentName = @DepartmentName
	GROUP BY D.DepartmentId, D.DepartmentName
	ORDER BY AverageGpa ASC
GO

-- Lists the average grades for each instructor
CREATE OR ALTER PROCEDURE ListInstructorsAverageGrades
AS
	SELECT I.InstructorId, I.InstructorName, D.DepartmentName, 
		SUM(CA.Grade)/COUNT(CA.Grade) AS AverageGrade
	FROM proj4.Instructor I 
		INNER JOIN proj4.Course C ON C.InstructorId = I.InstructorId
		INNER JOIN proj4.CourseAttendee CA ON CA.CourseId = C.CourseId
		INNER JOIN proj4.Department D ON D.DepartmentId = I.DepartmentId
	GROUP BY I.InstructorId, I.InstructorName, D.DepartmentName
	ORDER BY InstructorName ASC
GO

