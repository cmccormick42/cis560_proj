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
    class DepartmentRepository
    {
        // This is usually loaded from configuration.
        const string connectionString = @"Server=(localdb)\MSSQLLocalDb;Database=johnkeller;Integrated Security=SSPI;";

        public Department CreateDepartment(string departmentName, string head, string location, string description)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    using (var command = new SqlCommand("Demo.CreateDepartment", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("DepartmentName", departmentName);
                        command.Parameters.AddWithValue("Head", head);
                        command.Parameters.AddWithValue("Location", location);
                        command.Parameters.AddWithValue("Description", description);

                        var param = command.Parameters.Add("DepartmentId", SqlDbType.Int);
                        param.Direction = ParameterDirection.Output;

                        connection.Open();

                        command.ExecuteNonQuery();

                        transaction.Complete();

                        return new Department((int)param.Value, departmentName, head, location, description);
                    }
                }
            }
        }
    }
}
