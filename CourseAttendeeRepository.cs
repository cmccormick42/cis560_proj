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
    class CourseAttendeeRepository
    {
        // This is usually loaded from configuration.
        const string connectionString = @"Server=(localdb)\MSSQLLocalDb;Database=johnkeller;Integrated Security=SSPI;";

        public CourseAttendee CreateCourseAttendee(int courseId, int studentId, float grade)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    using (var command = new SqlCommand("Demo.CreateStudent", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("CourseId", courseId);
                        command.Parameters.AddWithValue("StudentId", studentId);
                        command.Parameters.AddWithValue("Grade", grade);


                        var param = command.Parameters.Add("CaId", SqlDbType.Int);
                        param.Direction = ParameterDirection.Output;

                        connection.Open();

                        command.ExecuteNonQuery();

                        transaction.Complete();

                        return new CourseAttendee((int)param.Value, courseId, studentId, grade);
                    }
                }
            }
        }
    }
}
