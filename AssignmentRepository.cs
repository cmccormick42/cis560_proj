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
    class AssignmentRepository
    {
        // This is usually loaded from configuration.
        const string connectionString = @"Server=(localdb)\MSSQLLocalDb;Database=johnkeller;Integrated Security=SSPI;";

        public Assignment CreateAssignement(int courseId, float pointsPossible, string assignmentName, string dueDate, string description)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    using (var command = new SqlCommand("Demo.CreateStudent", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("CourseId", courseId);
                        command.Parameters.AddWithValue("PointsPossible", pointsPossible);
                        command.Parameters.AddWithValue("AssignmentName", assignmentName);
                        command.Parameters.AddWithValue("DueDate", dueDate);
                        command.Parameters.AddWithValue("Description", description);


                        var param = command.Parameters.Add("AssignmentId", SqlDbType.Int);
                        param.Direction = ParameterDirection.Output;

                        connection.Open();

                        command.ExecuteNonQuery();

                        transaction.Complete();

                        return new Assignment((int)param.Value, courseId, pointsPossible, assignmentName, dueDate, description);
                    }
                }
            }
        }
    }
}
