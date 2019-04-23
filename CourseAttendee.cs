using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinalProject
{
    class CourseAttendee
    {
        public int CourseId { get; }
        public int StudentId { get; }
        public int CaId { get; }
        public float Grade { get; }


        public CourseAttendee(int caid, int courseId, int studentId, float grade)
        {
            CourseId = courseId;
            StudentId = studentId;
            CaId = caid;
            Grade = grade;
        }
    }
}
