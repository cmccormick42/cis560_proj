CREATE PROCEDURE proj4.GetStudentCount @IID INT
AS
WITH Course_CTE (CourseId, StudentCount)
AS
(
SELECT CA.CourseId, COUNT(*) 
FROM proj4.CourseAttendee CA
GROUP BY CA.CourseId
)
SELECT SUM(CC.StudentCount) AS StudentCount
FROM proj4.Instructor I
	INNER JOIN proj4.Course C ON C.InstructorId = I.InstructorId
	INNER JOIN Course_CTE CC ON CC.CourseId = C.CourseId
WHERE C.InstructorId = @IID
GROUP BY C.InstructorId