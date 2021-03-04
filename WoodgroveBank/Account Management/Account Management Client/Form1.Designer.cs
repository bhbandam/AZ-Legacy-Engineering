namespace WoodgroveBank
{
	partial class Form1
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this._hostFile = new System.Windows.Forms.ComboBox();
			this._hostFileLabel = new System.Windows.Forms.Label();
			this._deleteRecords = new System.Windows.Forms.RadioButton();
			this._addRecords = new System.Windows.Forms.RadioButton();
			this._xmlFileSourceLabel = new System.Windows.Forms.Label();
			this._xmlFileSource = new System.Windows.Forms.TextBox();
			this._xmlFileSourceBrowse = new System.Windows.Forms.Button();
			this._saveToXml = new System.Windows.Forms.RadioButton();
			this._saveToSql = new System.Windows.Forms.RadioButton();
			this._displayRecords = new System.Windows.Forms.RadioButton();
			this._xmlFileDestinationLabel = new System.Windows.Forms.Label();
			this._xmlFileDestination = new System.Windows.Forms.TextBox();
			this._xmlFileDestinationBrowse = new System.Windows.Forms.Button();
			this._sqlServerConnectionStringLabel = new System.Windows.Forms.Label();
			this._sqlServerConnectionString = new System.Windows.Forms.TextBox();
			this._execute = new System.Windows.Forms.Button();
			this._operations = new System.Windows.Forms.GroupBox();
			this._dataSetTable = new System.Windows.Forms.ComboBox();
			this._dataSetTableLabel = new System.Windows.Forms.Label();
			this._fileData = new System.Windows.Forms.DataGridView();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this._disconnect = new System.Windows.Forms.Button();
			this._connect = new System.Windows.Forms.Button();
			this._connectionString = new System.Windows.Forms.TextBox();
			this.label5 = new System.Windows.Forms.Label();
			this._operations.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this._fileData)).BeginInit();
			this.groupBox2.SuspendLayout();
			this.SuspendLayout();
			// 
			// _hostFile
			// 
			this._hostFile.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this._hostFile.FormattingEnabled = true;
			this._hostFile.Items.AddRange(new object[] {
            "Customers",
            "Transactions"});
			this._hostFile.Location = new System.Drawing.Point(10, 81);
			this._hostFile.Name = "_hostFile";
			this._hostFile.Size = new System.Drawing.Size(340, 21);
			this._hostFile.TabIndex = 0;
			this._hostFile.SelectedIndexChanged += new System.EventHandler(this._hostFile_SelectedIndexChanged);
			// 
			// _hostFileLabel
			// 
			this._hostFileLabel.Location = new System.Drawing.Point(8, 62);
			this._hostFileLabel.Name = "_hostFileLabel";
			this._hostFileLabel.Size = new System.Drawing.Size(244, 16);
			this._hostFileLabel.TabIndex = 1;
			this._hostFileLabel.Text = "&Host file:";
			// 
			// _deleteRecords
			// 
			this._deleteRecords.Location = new System.Drawing.Point(6, 19);
			this._deleteRecords.Name = "_deleteRecords";
			this._deleteRecords.Size = new System.Drawing.Size(306, 18);
			this._deleteRecords.TabIndex = 2;
			this._deleteRecords.TabStop = true;
			this._deleteRecords.Text = "&Delete all records from the host file";
			this._deleteRecords.UseVisualStyleBackColor = true;
			// 
			// _addRecords
			// 
			this._addRecords.Location = new System.Drawing.Point(6, 43);
			this._addRecords.Name = "_addRecords";
			this._addRecords.Size = new System.Drawing.Size(306, 18);
			this._addRecords.TabIndex = 4;
			this._addRecords.TabStop = true;
			this._addRecords.Text = "&Move records from XML to the &host file";
			this._addRecords.UseVisualStyleBackColor = true;
			// 
			// _xmlFileSourceLabel
			// 
			this._xmlFileSourceLabel.Location = new System.Drawing.Point(26, 64);
			this._xmlFileSourceLabel.Name = "_xmlFileSourceLabel";
			this._xmlFileSourceLabel.Size = new System.Drawing.Size(200, 16);
			this._xmlFileSourceLabel.TabIndex = 5;
			this._xmlFileSourceLabel.Text = "XML file:";
			// 
			// _xmlFileSource
			// 
			this._xmlFileSource.Location = new System.Drawing.Point(29, 83);
			this._xmlFileSource.Name = "_xmlFileSource";
			this._xmlFileSource.Size = new System.Drawing.Size(239, 20);
			this._xmlFileSource.TabIndex = 6;
			// 
			// _xmlFileSourceBrowse
			// 
			this._xmlFileSourceBrowse.Location = new System.Drawing.Point(274, 80);
			this._xmlFileSourceBrowse.Name = "_xmlFileSourceBrowse";
			this._xmlFileSourceBrowse.Size = new System.Drawing.Size(75, 23);
			this._xmlFileSourceBrowse.TabIndex = 7;
			this._xmlFileSourceBrowse.Text = "Browse...";
			this._xmlFileSourceBrowse.UseVisualStyleBackColor = true;
			this._xmlFileSourceBrowse.Click += new System.EventHandler(this._xmlFileSourceBrowse_Click);
			// 
			// _saveToXml
			// 
			this._saveToXml.Location = new System.Drawing.Point(6, 109);
			this._saveToXml.Name = "_saveToXml";
			this._saveToXml.Size = new System.Drawing.Size(306, 18);
			this._saveToXml.TabIndex = 8;
			this._saveToXml.TabStop = true;
			this._saveToXml.Text = "Move records from the host file to &XML";
			this._saveToXml.UseVisualStyleBackColor = true;
			// 
			// _saveToSql
			// 
			this._saveToSql.Location = new System.Drawing.Point(6, 175);
			this._saveToSql.Name = "_saveToSql";
			this._saveToSql.Size = new System.Drawing.Size(306, 18);
			this._saveToSql.TabIndex = 9;
			this._saveToSql.TabStop = true;
			this._saveToSql.Text = "Move records from the host file to &SQL Server";
			this._saveToSql.UseVisualStyleBackColor = true;
			// 
			// _displayRecords
			// 
			this._displayRecords.Location = new System.Drawing.Point(6, 241);
			this._displayRecords.Name = "_displayRecords";
			this._displayRecords.Size = new System.Drawing.Size(306, 18);
			this._displayRecords.TabIndex = 10;
			this._displayRecords.TabStop = true;
			this._displayRecords.Text = "&Display records in the host file";
			this._displayRecords.UseVisualStyleBackColor = true;
			// 
			// _xmlFileDestinationLabel
			// 
			this._xmlFileDestinationLabel.Location = new System.Drawing.Point(26, 130);
			this._xmlFileDestinationLabel.Name = "_xmlFileDestinationLabel";
			this._xmlFileDestinationLabel.Size = new System.Drawing.Size(200, 16);
			this._xmlFileDestinationLabel.TabIndex = 5;
			this._xmlFileDestinationLabel.Text = "XML file:";
			// 
			// _xmlFileDestination
			// 
			this._xmlFileDestination.Location = new System.Drawing.Point(29, 149);
			this._xmlFileDestination.Name = "_xmlFileDestination";
			this._xmlFileDestination.Size = new System.Drawing.Size(239, 20);
			this._xmlFileDestination.TabIndex = 6;
			// 
			// _xmlFileDestinationBrowse
			// 
			this._xmlFileDestinationBrowse.Location = new System.Drawing.Point(274, 146);
			this._xmlFileDestinationBrowse.Name = "_xmlFileDestinationBrowse";
			this._xmlFileDestinationBrowse.Size = new System.Drawing.Size(75, 23);
			this._xmlFileDestinationBrowse.TabIndex = 7;
			this._xmlFileDestinationBrowse.Text = "Browse...";
			this._xmlFileDestinationBrowse.UseVisualStyleBackColor = true;
			this._xmlFileDestinationBrowse.Click += new System.EventHandler(this._xmlFileDestinationBrowse_Click);
			// 
			// _sqlServerConnectionStringLabel
			// 
			this._sqlServerConnectionStringLabel.Location = new System.Drawing.Point(26, 196);
			this._sqlServerConnectionStringLabel.Name = "_sqlServerConnectionStringLabel";
			this._sqlServerConnectionStringLabel.Size = new System.Drawing.Size(200, 16);
			this._sqlServerConnectionStringLabel.TabIndex = 11;
			this._sqlServerConnectionStringLabel.Text = "SQL Server &connection string:";
			// 
			// _sqlServerConnectionString
			// 
			this._sqlServerConnectionString.Location = new System.Drawing.Point(29, 215);
			this._sqlServerConnectionString.Name = "_sqlServerConnectionString";
			this._sqlServerConnectionString.Size = new System.Drawing.Size(320, 20);
			this._sqlServerConnectionString.TabIndex = 12;
			this._sqlServerConnectionString.Text = "Data Source=.;Initial Catalog=WoodgroveBank;Integrated Security=True";
			// 
			// _execute
			// 
			this._execute.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this._execute.Location = new System.Drawing.Point(11, 605);
			this._execute.Name = "_execute";
			this._execute.Size = new System.Drawing.Size(75, 23);
			this._execute.TabIndex = 13;
			this._execute.Text = "Execute";
			this._execute.UseVisualStyleBackColor = true;
			this._execute.Click += new System.EventHandler(this._execute_Click);
			// 
			// _operations
			// 
			this._operations.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this._operations.Controls.Add(this._dataSetTable);
			this._operations.Controls.Add(this._dataSetTableLabel);
			this._operations.Controls.Add(this._fileData);
			this._operations.Controls.Add(this._deleteRecords);
			this._operations.Controls.Add(this._addRecords);
			this._operations.Controls.Add(this._sqlServerConnectionString);
			this._operations.Controls.Add(this._xmlFileSourceLabel);
			this._operations.Controls.Add(this._sqlServerConnectionStringLabel);
			this._operations.Controls.Add(this._xmlFileSource);
			this._operations.Controls.Add(this._displayRecords);
			this._operations.Controls.Add(this._xmlFileDestinationLabel);
			this._operations.Controls.Add(this._saveToSql);
			this._operations.Controls.Add(this._xmlFileDestination);
			this._operations.Controls.Add(this._saveToXml);
			this._operations.Controls.Add(this._xmlFileSourceBrowse);
			this._operations.Controls.Add(this._xmlFileDestinationBrowse);
			this._operations.Location = new System.Drawing.Point(12, 133);
			this._operations.Name = "_operations";
			this._operations.Size = new System.Drawing.Size(528, 466);
			this._operations.TabIndex = 14;
			this._operations.TabStop = false;
			this._operations.Text = "Choose a management operation";
			// 
			// _dataSetTable
			// 
			this._dataSetTable.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this._dataSetTable.FormattingEnabled = true;
			this._dataSetTable.Location = new System.Drawing.Point(135, 261);
			this._dataSetTable.Name = "_dataSetTable";
			this._dataSetTable.Size = new System.Drawing.Size(214, 21);
			this._dataSetTable.TabIndex = 15;
			this._dataSetTable.SelectedIndexChanged += new System.EventHandler(this._dataSetTable_SelectedIndexChanged);
			// 
			// _dataSetTableLabel
			// 
			this._dataSetTableLabel.Location = new System.Drawing.Point(29, 266);
			this._dataSetTableLabel.Name = "_dataSetTableLabel";
			this._dataSetTableLabel.Size = new System.Drawing.Size(100, 16);
			this._dataSetTableLabel.TabIndex = 14;
			this._dataSetTableLabel.Text = "DataSet table:";
			// 
			// _fileData
			// 
			this._fileData.AllowUserToAddRows = false;
			this._fileData.AllowUserToDeleteRows = false;
			this._fileData.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this._fileData.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this._fileData.Location = new System.Drawing.Point(29, 288);
			this._fileData.Name = "_fileData";
			this._fileData.ReadOnly = true;
			this._fileData.Size = new System.Drawing.Size(493, 172);
			this._fileData.TabIndex = 13;
			// 
			// groupBox2
			// 
			this.groupBox2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.groupBox2.Controls.Add(this._disconnect);
			this.groupBox2.Controls.Add(this._connect);
			this.groupBox2.Controls.Add(this._connectionString);
			this.groupBox2.Controls.Add(this.label5);
			this.groupBox2.Controls.Add(this._hostFile);
			this.groupBox2.Controls.Add(this._hostFileLabel);
			this.groupBox2.Location = new System.Drawing.Point(11, 13);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(529, 114);
			this.groupBox2.TabIndex = 15;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Host data source";
			// 
			// _disconnect
			// 
			this._disconnect.Location = new System.Drawing.Point(438, 35);
			this._disconnect.Name = "_disconnect";
			this._disconnect.Size = new System.Drawing.Size(75, 23);
			this._disconnect.TabIndex = 5;
			this._disconnect.Text = "Disconnect";
			this._disconnect.UseVisualStyleBackColor = true;
			this._disconnect.Click += new System.EventHandler(this._disconnect_Click);
			// 
			// _connect
			// 
			this._connect.Location = new System.Drawing.Point(357, 35);
			this._connect.Name = "_connect";
			this._connect.Size = new System.Drawing.Size(75, 23);
			this._connect.TabIndex = 4;
			this._connect.Text = "Connect";
			this._connect.UseVisualStyleBackColor = true;
			this._connect.Click += new System.EventHandler(this._connect_Click);
			// 
			// _connectionString
			// 
			this._connectionString.Location = new System.Drawing.Point(11, 39);
			this._connectionString.Name = "_connectionString";
			this._connectionString.Size = new System.Drawing.Size(339, 20);
			this._connectionString.TabIndex = 3;
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(7, 20);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(200, 16);
			this.label5.TabIndex = 2;
			this.label5.Text = "Connection string:";
			// 
			// Form1
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(552, 641);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this._operations);
			this.Controls.Add(this._execute);
			this.MinimumSize = new System.Drawing.Size(560, 668);
			this.Name = "Form1";
			this.Text = "Woodgrove Bank Manager";
			this._operations.ResumeLayout(false);
			this._operations.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this._fileData)).EndInit();
			this.groupBox2.ResumeLayout(false);
			this.groupBox2.PerformLayout();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.ComboBox _hostFile;
		private System.Windows.Forms.Label _hostFileLabel;
		private System.Windows.Forms.RadioButton _deleteRecords;
		private System.Windows.Forms.RadioButton _addRecords;
		private System.Windows.Forms.Label _xmlFileSourceLabel;
		private System.Windows.Forms.TextBox _xmlFileSource;
		private System.Windows.Forms.Button _xmlFileSourceBrowse;
		private System.Windows.Forms.RadioButton _saveToXml;
		private System.Windows.Forms.RadioButton _saveToSql;
		private System.Windows.Forms.RadioButton _displayRecords;
		private System.Windows.Forms.Label _xmlFileDestinationLabel;
		private System.Windows.Forms.TextBox _xmlFileDestination;
		private System.Windows.Forms.Button _xmlFileDestinationBrowse;
		private System.Windows.Forms.Label _sqlServerConnectionStringLabel;
		private System.Windows.Forms.TextBox _sqlServerConnectionString;
		private System.Windows.Forms.Button _execute;
		private System.Windows.Forms.GroupBox _operations;
		private System.Windows.Forms.DataGridView _fileData;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.Button _disconnect;
		private System.Windows.Forms.Button _connect;
		private System.Windows.Forms.TextBox _connectionString;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label _dataSetTableLabel;
		private System.Windows.Forms.ComboBox _dataSetTable;
	}
}

