using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Common;
using Microsoft.HostIntegration.MsHostFileClient;

namespace WoodgroveBank
{
	class HostFileAccess : IDisposable
	{
		private HostFileConnection _conn;

		public HostFileAccess(string connString)
		{
			_conn = new HostFileConnection(connString);
			_conn.Open();
		}

		public DataSet GetFileDataSet(string hostFile)
		{
			DataSet result = new DataSet();
			HostFileCommand cmd = new HostFileCommand(_conn);
			cmd.CommandText = string.Format("SELECT * FROM {0}", hostFile);

			HostFileDataAdapter adapter = new HostFileDataAdapter();
			adapter.SelectCommand = cmd;

			adapter.Fill(result);

			cmd.Dispose();

			return result;
		}

		public int DeleteAllRecords(string hostFile)
		{
			HostFileCommand cmd = new HostFileCommand(_conn);
			cmd.CommandText = string.Format("SELECT * FROM {0}", hostFile);
			HostFileRecordSet recordSet = cmd.ExecuteRecordSet();
			int deletedRecords = 0;
			
			while (recordSet.Read())
			{
				recordSet.Delete();
				recordSet.Update();
				deletedRecords++;
			}
			recordSet.Close();

			cmd.Dispose();
			return deletedRecords;
		}

		public int AddRecords(string hostFile, DataSet newRecords)
		{
			HostFileCommand cmd = new HostFileCommand(_conn);
			cmd.CommandText = string.Format("SELECT * FROM {0}", hostFile);
			
			HostFileDataAdapter adapter = new HostFileDataAdapter();
			adapter.SelectCommand = cmd;

			return adapter.Update(newRecords);
		}

		#region IDisposable Members

		public void Dispose()
		{
			_conn.Close();
			_conn.Dispose();
		}

		#endregion
	}
}
