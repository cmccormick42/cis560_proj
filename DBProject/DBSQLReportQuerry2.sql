CREATE PROCEDURE proj4.GetAssignmentTimeframe @IID INT, @Start DATETIME, @End DATETIME, @Threshold INT
AS
SELECT ASub.SubmissionId
FROM proj4.AssignmentSubmission Asub
	INNER JOIN proj4.Assignment A ON A.AssignmentId = Asub.AssignmentId
	INNER JOIN proj4.Course C ON C.CourseId = A.CourseId
WHERE (A.DueDate BETWEEN @Start AND @End) AND (Asub.PointsEarned / A.PointsPossible)*100 > @Threshold AND C.InstructorId = @IID
