using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace WoodgroveBank
{
	class SqlAccess : IDisposable
	{
		SqlConnection _sqlConn = null;

		public SqlAccess(string connectionString)
		{
			_sqlConn = new SqlConnection(connectionString);
			_sqlConn.Open();
		}

		public void TransferToCustomers(DataSet data)
		{
			int rowsAffected; 
			SqlCommand newCustomer = GetInsertCommand("Customers");
			SqlCommand newCustomerAddress = GetInsertCommand("CustomerAddress");

			DataTable customers = data.Tables["Table"];
			DataTable customerAddress = data.Tables["TableCUSTOMER_ADDRESS"];

			// This sample iterates through the rows in the DataTable and adds them to SQL Server. 
			// You can use SQL Server SSIS technology to perform more efficient data transfer.

			for (int i = 0; i < customers.Rows.Count; i++)
			{
				newCustomer.Parameters[0].Value = customers.Rows[i][0];
				newCustomer.Parameters[1].Value = customers.Rows[i][1];
				newCustomer.Parameters[2].Value = customers.Rows[i][3];
				newCustomer.Parameters[3].Value = customers.Rows[i][4];
				rowsAffected = newCustomer.ExecuteNonQuery();

				newCustomerAddress.Parameters[0].Value = customers.Rows[i][1];
				newCustomerAddress.Parameters[1].Value = customerAddress.Rows[i][0];
				newCustomerAddress.Parameters[2].Value = customerAddress.Rows[i][1];
				newCustomerAddress.Parameters[3].Value = customerAddress.Rows[i][2];
				newCustomerAddress.Parameters[4].Value = customerAddress.Rows[i][3];
				rowsAffected = newCustomerAddress.ExecuteNonQuery();
			}
		}

		//public void TransferToAccounts(DataSet data)
		//{
		//}

		public void TransferToTransactions(DataSet data)
		{
			int rowsAffected;
			SqlCommand newTransaction = GetInsertCommand("Transactions");

			DataTable transactions = data.Tables["Table"];

			// This sample iterates through the rows in the DataTable and adds them to SQL Server. 
			// You can use SQL Server SSIS technology to perform more efficient data transfer.

			for (int i = 0; i < transactions.Rows.Count; i++)
			{
				newTransaction.Parameters[0].Value = transactions.Rows[i][0];
				newTransaction.Parameters[1].Value = transactions.Rows[i][1];
				newTransaction.Parameters[2].Value = transactions.Rows[i][2];
				newTransaction.Parameters[3].Value = transactions.Rows[i][3];
				newTransaction.Parameters[4].Value = transactions.Rows[i][4];
				newTransaction.Parameters[5].Value = transactions.Rows[i][5];
				rowsAffected = newTransaction.ExecuteNonQuery();
			}
		}

		private SqlCommand GetInsertCommand(string table)
		{
			SqlDataAdapter adapter = new SqlDataAdapter(string.Format("SELECT * FROM {0}", table), _sqlConn);
			SqlCommandBuilder builder = new SqlCommandBuilder(adapter);
			return builder.GetInsertCommand();
		}

		#region IDisposable Members
		public void Dispose()
		{
			if (_sqlConn != null && _sqlConn.State == ConnectionState.Open)
			{
				_sqlConn.Close();
				_sqlConn.Dispose();
			}
		}
		#endregion
	}
}

