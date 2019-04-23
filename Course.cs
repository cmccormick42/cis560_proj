using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinalProject
{
    class Course
    {
        public int CourseId { get; }
        public int DepartmentId { get; }
        public int InstructorId { get; }
        public string Time { get; }
        public string Location { get; }
        public string Description { get; }
        public int Hours { get; }


        public Course(int courseId, int departmentId, int instructorId, string time, string location, string description, int hours)
        {
            CourseId = courseId;
            DepartmentId = departmentId;
            InstructorId = instructorId;
            Time = time ?? throw new ArgumentNullException(nameof(time));
            Location = location ?? throw new ArgumentNullException(nameof(location));
            Description = description ?? throw new ArgumentNullException(nameof(description));
            Hours = hours;
        }
    }
}
