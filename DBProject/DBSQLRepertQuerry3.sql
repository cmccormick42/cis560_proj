CREATE PROCEDURE proj4.GradeLateAssignments @CAID INT, @Threshold INT
AS
SELECT COUNT(*) AS LateAssignments
FROM proj4.CourseAttendee CA
	INNER JOIN proj4.AssignmentSubmission ASub ON Asub.CAID = CA.CAID
	INNER JOIN proj4.Assignment A on A.AssignmentId = Asub.AssignmentId
WHERE (ASub.PointsEarned / A.PointsPossible)*100 < @Threshold AND DueDate < ASub.SubmissionDate AND @CAID = CA.StudentId
GROUP BY CA.StudentId