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
    class CourseRepository
    {
        // This is usually loaded from configuration.
        const string connectionString = @"Server=(localdb)\MSSQLLocalDb;Database=johnkeller;Integrated Security=SSPI;";

        public Course CreateCourse(int departmentId, int instructorId, string time, string location, string description, int hours)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    using (var command = new SqlCommand("Demo.CreateCourse", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("DepartmentId", departmentId);
                        command.Parameters.AddWithValue("InstructorId", instructorId);
                        command.Parameters.AddWithValue("Time", time);
                        command.Parameters.AddWithValue("Location", location);
                        command.Parameters.AddWithValue("Description", description);
                        command.Parameters.AddWithValue("Hours", hours);


                        var param = command.Parameters.Add("CourseId", SqlDbType.Int);
                        param.Direction = ParameterDirection.Output;

                        connection.Open();

                        command.ExecuteNonQuery();

                        transaction.Complete();

                        return new Course((int)param.Value, departmentId, instructorId, time, location, description, hours);
                    }
                }
            }
        }
    }
}
