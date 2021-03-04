using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Data.Sql;
using System.Data.SqlClient;

namespace WoodgroveBank
{
	public partial class Form1 : Form
	{
		private const int CustomersFile = 0;
		//private const int AccountsFile = 1;
		private const int TransactionsFile = 1;
		HostFileAccess _hostAccess = null;

		public Form1()
		{
			InitializeComponent();

			// add all UI events
			_deleteRecords.CheckedChanged += new EventHandler(OperationChanged);
			_addRecords.CheckedChanged += new EventHandler(OperationChanged);
			_saveToXml.CheckedChanged += new EventHandler(OperationChanged);
			_saveToSql.CheckedChanged += new EventHandler(OperationChanged);
			_displayRecords.CheckedChanged += new EventHandler(OperationChanged);

			EnableOperations(false);
			_deleteRecords.Checked = true;
		}

		void OperationChanged(object sender, EventArgs e)
		{
			this.SuspendLayout();

			_xmlFileSourceLabel.Enabled = false;
			_xmlFileSource.Enabled = false;
			_xmlFileSourceBrowse.Enabled = false;
			_xmlFileDestinationLabel.Enabled = false;
			_xmlFileDestination.Enabled = false;
			_xmlFileDestinationBrowse.Enabled = false;
			_sqlServerConnectionString.Enabled = false;
			_sqlServerConnectionStringLabel.Enabled = false;
			_fileData.Enabled = false;
			_dataSetTable.Enabled = false;
			_dataSetTableLabel.Enabled = false;

			if (sender == _addRecords)
			{
				_xmlFileSourceLabel.Enabled = true;
				_xmlFileSource.Enabled = true;
				_xmlFileSourceBrowse.Enabled = true;
			}
			else if (sender == _saveToXml)
			{
				_xmlFileDestinationLabel.Enabled = true;
				_xmlFileDestination.Enabled = true;
				_xmlFileDestinationBrowse.Enabled = true;
			}
			else if (sender == _saveToSql)
			{
				_sqlServerConnectionStringLabel.Enabled = true;
				_sqlServerConnectionString.Enabled = true;
			}
			else if (sender == _displayRecords)
			{
				_fileData.Enabled = true;
				_dataSetTable.Enabled = true;
				_dataSetTableLabel.Enabled = true;
			}

			this.ResumeLayout();
		}

		private void _xmlFileSourceBrowse_Click(object sender, EventArgs e)
		{
			OpenFileDialog dialog = new OpenFileDialog();
			if(Directory.Exists("..\\.."))
				dialog.InitialDirectory = "..\\..";
			else
				dialog.InitialDirectory = ".";
			dialog.Filter = "XML files (*.xml)|*.xml";
			dialog.FilterIndex = 1;
			if (dialog.ShowDialog() == DialogResult.OK)
			{
				_xmlFileSource.Text = dialog.FileName;
			}
		}

		private void _xmlFileDestinationBrowse_Click(object sender, EventArgs e)
		{
			SaveFileDialog dialog = new SaveFileDialog();
			if (Directory.Exists("..\\.."))
				dialog.InitialDirectory = "..\\..";
			else
				dialog.InitialDirectory = ".";
			dialog.Filter = "XML files (*.xml)|*.xml";
			dialog.FilterIndex = 1;
			if (dialog.ShowDialog() == DialogResult.OK)
			{
				_xmlFileDestination.Text = dialog.FileName;
			}
		}

		private void _connect_Click(object sender, EventArgs e)
		{
			try
			{
				_hostAccess = new HostFileAccess(_connectionString.Text);

				EnableOperations(true);
				_disconnect.Enabled = true;
				_connect.Enabled = false;
			}
			catch (Exception ex)
			{
				DisplayError(ex.ToString());
			}
		}

		private void _disconnect_Click(object sender, EventArgs e)
		{
			try
			{
				_hostAccess.Dispose();
				_hostAccess = null;

				EnableOperations(false);
				_disconnect.Enabled = false;
				_connect.Enabled = true;
			}
			catch (Exception ex)
			{
				DisplayError(ex.ToString());
			}
		}

		private void DisplayError(string errorString)
		{
			MessageBox.Show(errorString, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
		}

		private void EnableOperations(bool enabled)
		{
			_operations.Enabled = enabled;
			_execute.Enabled = enabled;
			_hostFile.Enabled = enabled;
			_hostFileLabel.Enabled = enabled;
			if(enabled)
				_hostFile.SelectedIndex = 0;
		}

		private string GetHostFileName(int hostFile)
		{
			switch (hostFile)
			{
				case CustomersFile:
					return "Customers";
				//case AccountsFile:
				//	return "Accounts";
				case TransactionsFile:
					return "Transactions";
			}
			return String.Empty;
		}

		private void _hostFile_SelectedIndexChanged(object sender, EventArgs e)
		{
		}

		private void _dataSetTable_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (((string)_dataSetTable.SelectedItem).Length > 0 &&
				_fileData.DataSource != null)
			{
				_fileData.DataMember = (string)_dataSetTable.SelectedItem;
			}
		}

		private void _execute_Click(object sender, EventArgs e)
		{
			try
			{
				if (_deleteRecords.Checked)
				{
					DeleteRecords(_hostFile.SelectedIndex);
				}
				else if (_addRecords.Checked)
				{
					AddRecords(_hostFile.SelectedIndex, _xmlFileSource.Text);
				}
				else if (_saveToXml.Checked)
				{
					SaveToXml(_hostFile.SelectedIndex, _xmlFileDestination.Text);
				}
				else if (_saveToSql.Checked)
				{
					SaveToSql(_hostFile.SelectedIndex, _sqlServerConnectionString.Text);
				}
				else if (_displayRecords.Checked)
				{
					DisplayHostFile(_hostFile.SelectedIndex);
				}
			}
			catch (Exception ex)
			{
				DisplayError(ex.ToString());
			}
		}

		private void DeleteRecords(int hostFile)
		{
			if (DialogResult.Yes == MessageBox.Show("Are you sure you want to delete all records in the host file?", "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Question))
			{
				int recordsDeleted = _hostAccess.DeleteAllRecords(GetHostFileName(hostFile));


				MessageBox.Show(string.Format("{0} records were successfully deleted.", recordsDeleted.ToString()));
			}
		}

		private void AddRecords(int hostFile, string xmlSource)
		{
			if (!File.Exists(xmlSource))
				throw new InvalidOperationException(string.Format("The local file '{0}' cannot be found.", xmlSource));

			DataSet ds = new DataSet();
			ds.ReadXml(xmlSource, XmlReadMode.ReadSchema);

			int recordsAdded = _hostAccess.AddRecords(GetHostFileName(hostFile), ds);

			MessageBox.Show(string.Format("{0} records were successfully added.", recordsAdded.ToString()));
		}

		private void SaveToXml(int hostFile, string xmlDestination)
		{
			if (File.Exists(xmlDestination) &&
				DialogResult.No == MessageBox.Show(string.Format("The file '{0}' already exists. Is it ok to override this file?", xmlDestination), "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Question))
			{
				return;
			}

			DataSet ds = _hostAccess.GetFileDataSet(GetHostFileName(hostFile));

			ds.WriteXml(xmlDestination, XmlWriteMode.WriteSchema);

			MessageBox.Show("The host file was successfully saved to XML.");
		}

		private void SaveToSql(int hostFile, string sqlConnectionString)
		{
			SqlAccess sqlAccess = new SqlAccess(sqlConnectionString);
			DataSet ds = _hostAccess.GetFileDataSet(GetHostFileName(hostFile));

			switch (hostFile)
			{
				case CustomersFile:
					sqlAccess.TransferToCustomers(ds);
					break;
				//case AccountsFile:
				//	sqlAccess.TransferToAccounts(ds);
				//	break;
				case TransactionsFile:
					sqlAccess.TransferToTransactions(ds);
					break;
			}

			sqlAccess.Dispose();
		
			MessageBox.Show("Records were successfully saved to SQL Server.");
		}

		private void DisplayHostFile(int hostFile)
		{
			DataSet ds = _hostAccess.GetFileDataSet(GetHostFileName(hostFile));

			_fileData.DataSource = ds;

			_dataSetTable.Items.Clear();
			for(int i=0; i<ds.Tables.Count; i++)
			{
				_dataSetTable.Items.Add(ds.Tables[i].TableName);
			}

			if (_dataSetTable.Items.Count > 0)
				_dataSetTable.SelectedIndex = 0;
		}
	}
}
