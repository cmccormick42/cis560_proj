CREATE PROCEDURE proj4.Get_Lowest_Grade @SID INT, @Threshold INT
AS
SELECT A.AssignmentName
FROM proj4.Assignment A
WHERE A.AssignmentId IN
(SELECT ASub.AssignmentId
FROM proj4.AssignmentSubmission ASub
	INNER JOIN 
(
	SELECT CA.CAID ,MIN(ASub.PointsEarned) AS MinScore
	FROM proj4.Student S
		INNER JOIN proj4.CourseAttendee CA ON CA.StudentId = S.StudentId
		INNER JOIN proj4.AssignmentSubmission ASub ON ASub.CAID = CA.CAID
		INNER JOIN proj4.Assignment A ON A.AssignmentId = ASub.AssignmentId
	WHERE S.StudentId = @SID AND CA.Grade < @Threshold
	GROUP BY CA.CAID
) T ON t.CAID = ASub.CAID AND ASub.PointsEarned = t.MinScore
)
