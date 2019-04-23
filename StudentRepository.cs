using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Transactions;

namespace FinalProject
{
    class StudentRepository
    {
        // This is usually loaded from configuration.
        const string connectionString = @"Server=(localdb)\MSSQLLocalDb;Database=johnkeller;Integrated Security=SSPI;";

        public Student CreateStudent(int departmentId, string name, float gpa, int hours)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    using (var command = new SqlCommand("Demo.CreateStudent", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("DepartmentId", departmentId);
                        command.Parameters.AddWithValue("Name", name);
                        command.Parameters.AddWithValue("GPA", gpa);
                        command.Parameters.AddWithValue("Hours", hours);


                        var param = command.Parameters.Add("StudentId", SqlDbType.Int);
                        param.Direction = ParameterDirection.Output;

                        connection.Open();

                        command.ExecuteNonQuery();

                        transaction.Complete();

                        return new Student((int)param.Value, departmentId, name, gpa, hours);
                    }
                }
            }
        }
    }
}
