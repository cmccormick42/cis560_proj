using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinalProject
{
    class Department
    {
        public int DepartmentId { get; }
        public string DepartmentName { get; }
        public string Head { get; }
        public string Location { get; }
        public string Description { get; }

        public Department(int departmentId, string departmentName, string head, string location, string description)
        {
            DepartmentId = departmentId;
            DepartmentName = departmentName ?? throw new ArgumentNullException(nameof(departmentName));
            Head = head ?? throw new ArgumentNullException(nameof(head));
            Location = location ?? throw new ArgumentNullException(nameof(location));
            Description = description ?? throw new ArgumentNullException(nameof(description));
        }
    }
}
