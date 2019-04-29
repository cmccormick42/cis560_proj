USE justinm1
GO
-- Gets the GPA for a given student
CREATE OR ALTER PROCEDURE proj4.GetGpa @StudentId INT
AS
	SELECT S.StudentId, S.[Name], S.Gpa 
	FROM proj4.Student S
	WHERE S.StudentId = @StudentId
GO

-- Gets a list of assignments for given student and course
CREATE OR ALTER PROCEDURE proj4.GetStudentAssignmentsForCourse @StudentId INT, @CourseId INT
AS
	SELECT DISTINCT A.AssignmentId, A.PointsPossible, A.AssignmentName, A.DueDate, 
		A.[Description]
	FROM proj4.Assignment A
		INNER JOIN proj4.Course C ON C.CourseId = A.CourseId
		INNER JOIN proj4.CourseAttendee CA ON CA.CourseId = C.CourseId
	WHERE CA.StudentId = @StudentId
		AND CA.CourseId = @CourseId
	ORDER BY A.AssignmentId ASC
GO

-- Gets a student's grades for all classes
CREATE OR ALTER PROCEDURE proj4.GetStudentGradesForClasses @StudentId INT
AS
	SELECT C.CourseId, CA.Grade
	FROM proj4.CourseAttendee CA
		INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	WHERE CA.StudentId = @StudentId
	ORDER BY CA.Grade DESC
GO

-- Gets all assignments for a given student due on or before given date
CREATE OR ALTER PROCEDURE proj4.GetAssignmentsDueBeforeDay @StudentId INT, @Date DATETIME
AS
	SELECT DISTINCT A.CourseId, A.PointsPossible, A.AssignmentName, A.DueDate, 
		A.[Description]
	FROM proj4.Assignment A
		INNER JOIN proj4.CourseAttendee CA ON CA.StudentId = @StudentId
	WHERE A.DueDate <= @Date
	ORDER BY DueDate DESC
GO

-- Gets all student grades for a given course
CREATE OR ALTER PROCEDURE proj4.GetStudentsGradesForCourse 
	@CourseId INT,
	@InstructorId INT
AS
	SELECT C.CourseId, S.[Name], CA.Grade
	FROM proj4.CourseAttendee CA
		INNER JOIN proj4.Student S ON S.StudentId = CA.StudentId
		INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	WHERE CA.CourseId = @CourseId
		AND C.InstructorId = @InstructorId
	ORDER BY S.[Name] ASC
GO

-- Gets a student's grades for a class
CREATE OR ALTER PROCEDURE proj4.GetStudentGradeForCourse @StudentId INT, @CourseId INT
AS
	SELECT CA.StudentId, CA.CAID, CA.CourseId, CA.Grade
	FROM proj4.CourseAttendee CA
	WHERE CA.StudentId = @StudentId
		AND CA.CourseId = @CourseId
	ORDER BY CA.Grade DESC
GO

-- Gets a list of students who are missing a given assignment
CREATE OR ALTER PROCEDURE proj4.GetMissingSubmissions @AssignmentId INT
AS 
	SELECT S.[Name]
	FROM proj4.CourseAttendee CA
		INNER JOIN proj4.AssignmentSubmission SUB ON SUB.CAID = CA.CAID
		INNER JOIN proj4.Student S ON S.StudentId = CA.StudentId
		INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
	WHERE A.AssignmentId = @AssignmentId 
		AND SUB.Submission IS NULL
	ORDER BY S.[Name]
GO

-- Gets the average grade for a course
CREATE OR ALTER PROCEDURE proj4.GetAverageCourseGrade 
	@CourseId INT,
	@InstructorId INT
AS
	SELECT CA.CourseId, SUM(CA.Grade)/(COUNT(CA.Grade)*100) AS AverageCourseGrade
	FROM proj4.CourseAttendee CA
		INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	WHERE CA.CourseId = @CourseId
		AND C.InstructorId = InstructorId
	GROUP BY CA.CourseId
GO

-- Gets the average grade for a course assignment
CREATE OR ALTER PROCEDURE proj4.GetAverageAssignmentGrade 
	@CourseId INT, 
	@InstructorId INT,
	@AssignmentId Int
AS
	SELECT --SUB.PointsEarned, A.PointsPossible
		SUM(SUB.PointsEarned)/SUM(A.PointsPossible)*100 AS AverageAssignmentGrade
	FROM proj4.AssignmentSubmission SUB 
		INNER JOIN proj4.CourseAttendee CA ON CA.CAID = SUB.CAID
		INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
		INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
	WHERE SUB.AssignmentId = @AssignmentId
		AND C.CourseId = @CourseId
		AND C.InstructorId = @InstructorId
GO

-- Gets the average GPA for a given department
CREATE OR ALTER PROCEDURE proj4.GetDepartmentGpa 
	@DepartmentId INT
AS
	SELECT D.DepartmentId, D.DepartmentName, 
		SUM(S.Gpa)/COUNT(S.Gpa) AS AverageGpa
	FROM proj4.Department D
		INNER JOIN proj4.Student S ON S.DepartmentId = D.DepartmentId
	WHERE D.DepartmentId = @DepartmentId
	GROUP BY D.DepartmentId, D.DepartmentName
	ORDER BY AverageGpa ASC
GO

-- Lists the average grades for each instructor
CREATE OR ALTER PROCEDURE proj4.GetInstructorAverageGrade
	@InstructorId INT
AS
	SELECT I.InstructorId, I.InstructorName, D.DepartmentName, 
		SUM(CA.Grade)/COUNT(CA.Grade) AS AverageGrade
	FROM proj4.Instructor I 
		INNER JOIN proj4.Course C ON C.InstructorId = I.InstructorId
		INNER JOIN proj4.CourseAttendee CA ON CA.CourseId = C.CourseId
		INNER JOIN proj4.Department D ON D.DepartmentId = I.DepartmentId
	WHERE I.InstructorId = @InstructorId
	GROUP BY I.InstructorId, I.InstructorName, D.DepartmentName
	ORDER BY InstructorName ASC
GO

-- Adds a student with given information to the student table
CREATE OR ALTER PROCEDURE proj4.AddStudent
	@DepartmentId INT,
	@Name NVARCHAR(50),
	@Gpa FLOAT,
	@Hours INT,
	@StudentId INT OUTPUT
AS
	INSERT INTO proj4.Student(DepartmentId, [Name], Gpa, [Hours])
	VALUES (@DepartmentId, @Name, @Gpa, @Hours)
	SET @StudentId = SCOPE_IDENTITY()
GO

-- Removes the student associated with a given studentid from the table
CREATE OR ALTER PROCEDURE proj4.DropStudent
	@StudentId INT
AS
	DELETE FROM proj4.Student
	WHERE StudentId = @StudentId
GO

-- Checks if a student exists, returning 1 if yes, 0 if no
CREATE OR ALTER PROCEDURE proj4.CheckExistsStudent
	@StudentId INT,
	@Result INT OUTPUT
AS
	IF EXISTS 
	( 
		SELECT S.StudentId
		FROM proj4.Student S
		WHERE StudentId = @StudentId
	) SET @Result = 1
	ELSE
		SET @Result = 0
RETURN
GO

-- Checks if an instructor exists, returning 1 if yes, 0 if no
CREATE OR ALTER PROCEDURE proj4.CheckExistsInstructor
	@InstructorId INT,
	@Result INT OUTPUT
AS
	IF EXISTS 
	( 
		SELECT I.InstructorId
		FROM proj4.Instructor I
		WHERE InstructorId = @InstructorId
	) SET @Result = 1
	ELSE
		SET @Result = 0
RETURN
GO

-- Returns all of the information for a given student
CREATE OR ALTER PROCEDURE proj4.ReturnStudent
	@StudentId INT
AS
	SELECT S.StudentId, S.DepartmentId, S.[Name], S.Gpa, S.[Hours]
	FROM proj4.Student S
	WHERE S.StudentId = @StudentId
GO

-- Returns all of the information for given instructor
CREATE OR ALTER PROCEDURE proj4.ReturnInstructor
	@InstructorId INT
AS 
	SELECT *
	FROM proj4.Instructor I
	WHERE I.InstructorId = @InstructorId
GO

-- Gets a list of students who are missing a given assignment
CREATE OR ALTER PROCEDURE proj4.GetMissingSubmissions 
	@InstructorId INT,
	@CourseId INT,
	@AssignmentId INT
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

-- Gets a list of grades for a given assignment in a course
CREATE OR ALTER PROCEDURE proj4.GetAssignmentGrades 
	@AssignmentId INT,
	@CourseId INT,
	@InstructorId INT
AS
	SELECT S.[Name], SUB.PointsEarned/A.PointsPossible*100 AS AssignmentGrade
	FROM proj4.AssignmentSubmission SUB
		INNER JOIN proj4.CourseAttendee CA ON CA.CAID = SUB.CAID
		INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
		INNER JOIN proj4.Student S ON CA.StudentId = S.StudentId
		INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
	WHERE CA.CourseId = @CourseId
		AND A.AssignmentId = @AssignmentId
		AND C.InstructorId = @InstructorId
	ORDER BY S.[Name] ASC
GO