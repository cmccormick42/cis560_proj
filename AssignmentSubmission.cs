using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinalProject
{
    class AssignmentSubmission
    {
        public int SubmissionId { get; }
        public int AssignmentId { get; }
        public float PointsEarned { get; }
        public int CaId { get; }
        public string Submission { get; }


        public AssignmentSubmission(int submissionId, int assignmentId, float pointsEarned, int caid, string submission)
        {
            SubmissionId = SubmissionId;
            AssignmentId = assignmentId;
            PointsEarned = pointsEarned;
            CaId = caid;
            Submission = submission ?? throw new ArgumentNullException(nameof(submission));
        }
    }
}
