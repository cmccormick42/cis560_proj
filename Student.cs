using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinalProject
{
    class Student
    {
        public int StudentId { get; }
        public int DepartmentId { get; }
        public string Name { get; }
        public float Gpa { get; }
        public int Hours { get; }
  

        public Student(int studentId, int departmentId, string name, float gpa, int hours)
        {
            StudentId = studentId;
            DepartmentId = departmentId;
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Gpa = gpa;
            Hours = hours;
        }
    }
}
