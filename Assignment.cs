using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinalProject
{
    class Assignment
    {
        public int AssignmentId { get; }
        public int CourseId { get; }
        public float PointsPossible { get; }
        public string AssignmentName { get; }
        public string DueDate { get; }
        public string Description { get; }


        public Assignment(int assignmentId, int courseId, float pointsPossible, string assignmentName, string dueDate, string description)
        {
            AssignmentId = assignmentId;
            CourseId = courseId;
            PointsPossible = pointsPossible;
            AssignmentName = assignmentName ?? throw new ArgumentNullException(nameof(assignmentName));
            DueDate = dueDate ?? throw new ArgumentNullException(nameof(dueDate));
            Description = description ?? throw new ArgumentNullException(nameof(description));
        }
    }
}
