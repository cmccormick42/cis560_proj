USE justinm1

EXEC proj4.DropStudent @StudentId = 101
GO

EXEC proj4.AddStudent
	@DepartmentId = 2,
	@Name = N'Test Student',
	@Gpa = 3.2,
	@Hours = 20
GO

SELECT *
FROM proj4.Student

SELECT *
FROM proj4.Assignment
GO

DECLARE @ResultLoc INT
EXEC proj4.CheckExistsStudent
	@StudentId = 100,
	@Result = @ResultLoc OUTPUT
SELECT @ResultLoc

USE justinm1
SELECT *
FROM proj4.Course

USE justinm1
EXEC proj4.GetStudentAssignmentsForCourse
	@StudentId = 6,
	@CourseId = 13
GO

EXEC proj4.GetStudentGradeForCourse
	@StudentId = 6,
	@CourseId = 13
GO

SELECT * 
FROM proj4.Student S
	INNER JOIN proj4.CourseAttendee CA ON CA.StudentId = S.StudentId
ORDER BY S.StudentId ASC, CA.CourseId ASC

SELECT *
FROM proj4.Assignment A
	INNER JOIN proj4.CourseAttendee CA ON CA.CourseId = A.CourseId
WHERE CA.StudentId = 6

EXEC proj4.GetAssignmentsDueBeforeDay
	@StudentId = 6,
	@Date = '2019-12-30'

SELECT *
FROM proj4.AssignmentSubmission SUB
	INNER JOIN proj4.CourseAttendee CA ON CA.CAID = SUB.CAID

SELECT *
FROM proj4.Instructor I
--WHERE I.InstructorId = 2

EXEC proj4.GetAverageCourseGrade
	@CourseId = 16

SELECT *
FROM proj4.AssignmentSubmission SUB
	INNER JOIN proj4.CourseAttendee CA ON CA.CAID = SUB.CAID
	INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
	INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
WHERE CA.CourseId = 16

EXEC proj4.GetStudentsGradesForCourse	
	@CourseId = 16,
	@InstructorId = 6

SELECT * 
FROM proj4.AssignmentSubmission SUB
	INNER JOIN proj4.CourseAttendee CA ON CA.CAID = SUB.CAID
	INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
--WHERE ---C.CourseId = 4
	----AND C.InstructorId = 7
	--AND SUB.AssignmentId = 1
ORDER BY SUB.AssignmentId ASC, C.InstructorId ASC, C.CourseId ASC

EXEC proj4.GetAverageAssignmentGrade
	@CourseId = 17,
	@InstructorId = 7,
	@AssignmentId = 52

SELECT
		SUM(SUB.PointsEarned)/(SUM(A.PointsPossible)) AS AverageAssignmentGrade
	FROM proj4.AssignmentSubmission SUB 
		INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
		INNER JOIN proj4.Course C ON A.CourseId = C.CourseId
	WHERE A.AssignmentId = 4
		AND C.CourseId = 7
		AND C.InstructorId = 1

SELECT SUB.AssignmentId, S.[Name], A.CourseId, C.InstructorId
FROM proj4.AssignmentSubmission SUB
	INNER JOIN proj4.CourseAttendee CA ON CA.CAID = SUB.CAID
	INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	INNER JOIN proj4.Student S ON CA.StudentId = S.StudentId
	INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
--WHERE SUB.AssignmentId = 5
	--AND C.CourseId = 7
	--AND C.InstructorId = 8
ORDER BY S.[Name]

SELECT *
FROM proj4.AssignmentSubmission
ORDER BY CAID

SELECT *
FROM proj4.AssignmentSubmission SUB
	INNER JOIN proj4.CourseAttendee CA ON CA.CAID = SUB.CAID
	INNER JOIN proj4.Course C ON C.CourseId = CA.CourseId
	INNER JOIN proj4.Student S ON CA.StudentId = S.StudentId
	INNER JOIN proj4.Assignment A ON A.AssignmentId = SUB.AssignmentId
ORDER BY A.AssignmentId

EXEC proj4.GetAssignmentGrades
	@AssignmentId = 52,
	@CourseId = 17,
	@InstructorId = 7

EXEC proj4.GetDepartmentGpa
	@DepartmentId = 1

EXEC proj4.GetInstructorAverageGrade
	@InstructorId = 1
