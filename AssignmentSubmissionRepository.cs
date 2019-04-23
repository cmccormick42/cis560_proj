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
    class AssignmentSubmissionRepository
    {
        // This is usually loaded from configuration.
        const string connectionString = @"Server=(localdb)\MSSQLLocalDb;Database=johnkeller;Integrated Security=SSPI;";

        public AssignmentSubmission CreateAssignmentSubmission(int assignmentId, float pointsEarned, int caid, string submission)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    using (var command = new SqlCommand("Demo.CreateStudent", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("AssignmentId", assignmentId);
                        command.Parameters.AddWithValue("PointsEarned", pointsEarned);
                        command.Parameters.AddWithValue("CaId", caid);
                        command.Parameters.AddWithValue("Submission", submission);



                        var param = command.Parameters.Add("SubmissionId", SqlDbType.Int);
                        param.Direction = ParameterDirection.Output;

                        connection.Open();

                        command.ExecuteNonQuery();

                        transaction.Complete();

                        return new AssignmentSubmission((int)param.Value, assignmentId, pointsEarned, caid, submission);
                    }
                }
            }
        }
    }
}
