using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinalProject
{
    class Instructor
    {
        public int InstructorId { get; }
        public string InstructorName { get; }
        public string Office { get; }
        public string OfficeHours { get; }
        public int DepartmentId { get; }

        public Instructor(int instructorId, string name, string office, string officeHours, int departmentId)
        {
            InstructorId = instructorId;
            InstructorName = name ?? throw new ArgumentNullException(nameof(name));
            Office = office ?? throw new ArgumentNullException(nameof(office));
            OfficeHours = officeHours ?? throw new ArgumentNullException(nameof(officeHours));
            DepartmentId = departmentId;
        }
    }
}
