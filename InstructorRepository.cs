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
    class InstructorRepository
    {
        // This is usually loaded from configuration.
        const string connectionString = @"Server=(localdb)\MSSQLLocalDb;Database=johnkeller;Integrated Security=SSPI;";

        public Instructor CreateInstructor(string instructorName, string office, string officeHours, int departmentId)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    using (var command = new SqlCommand("Demo.CreateInstructor", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("InstructorName", instructorName);
                        command.Parameters.AddWithValue("Office", office);
                        command.Parameters.AddWithValue("OfficeHours", officeHours);
                        command.Parameters.AddWithValue("DepartmentId", departmentId);

                        var param = command.Parameters.Add("InstructorId", SqlDbType.Int);
                        param.Direction = ParameterDirection.Output;

                        connection.Open();

                        command.ExecuteNonQuery();

                        transaction.Complete();

                        return new Instructor((int)param.Value, instructorName, office, officeHours, departmentId);
                    }
                }
            }
        }
    }
}
