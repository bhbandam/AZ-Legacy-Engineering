namespace CSClient
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
            this.ScreenText = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.WorkTabPage = new System.Windows.Forms.TabPage();
            this.ReconfigureButton = new System.Windows.Forms.Button();
            this.FinishWithCustomer = new System.Windows.Forms.Button();
            this.WorkWithCustomer = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.InputCustomerBox = new System.Windows.Forms.TextBox();
            this.CustomersTabPage = new System.Windows.Forms.TabPage();
            this.MessagesListBox = new System.Windows.Forms.ListBox();
            this.StatementsButton = new System.Windows.Forms.Button();
            this.BalanceButton = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.AccountsComboBox = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.CustomerNameBox = new System.Windows.Forms.TextBox();
            this.AccountsTabPage = new System.Windows.Forms.TabPage();
            this.label11 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.StreetBox = new System.Windows.Forms.TextBox();
            this.CityBox = new System.Windows.Forms.TextBox();
            this.SSNBox = new System.Windows.Forms.TextBox();
            this.AccountMessagesListBox = new System.Windows.Forms.ListBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.AccountCustomerNameBox = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.PhoneBox = new System.Windows.Forms.TextBox();
            this.label13 = new System.Windows.Forms.Label();
            this.UpdateCustomerButton = new System.Windows.Forms.Button();
            this.ZIPBox = new System.Windows.Forms.TextBox();
            this.StateBox = new System.Windows.Forms.TextBox();
            this.label12 = new System.Windows.Forms.Label();
            this.NewCustomerButton = new System.Windows.Forms.Button();
            this.label9 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.NewSavingsCheckbox = new System.Windows.Forms.CheckBox();
            this.NewCheckingCheckbox = new System.Windows.Forms.CheckBox();
            this.AddAccountsButton = new System.Windows.Forms.Button();
            this.ConfigurationTabPage = new System.Windows.Forms.TabPage();
            this.StartWorkButton = new System.Windows.Forms.Button();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.InputCICSNameBox = new System.Windows.Forms.TextBox();
            this.label16 = new System.Windows.Forms.Label();
            this.InputLUNameBox = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.COM3270RadioButton = new System.Windows.Forms.RadioButton();
            this.TIRadioButton = new System.Windows.Forms.RadioButton();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.tabControl1.SuspendLayout();
            this.WorkTabPage.SuspendLayout();
            this.CustomersTabPage.SuspendLayout();
            this.AccountsTabPage.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.ConfigurationTabPage.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // ScreenText
            // 
            this.ScreenText.BackColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.ScreenText.CausesValidation = false;
            this.ScreenText.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ScreenText.Font = new System.Drawing.Font("Courier New", 14F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Pixel, ((byte)(0)));
            this.ScreenText.HideSelection = false;
            this.ScreenText.Location = new System.Drawing.Point(3, 28);
            this.ScreenText.Multiline = true;
            this.ScreenText.Name = "ScreenText";
            this.ScreenText.ReadOnly = true;
            this.ScreenText.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.ScreenText.Size = new System.Drawing.Size(602, 530);
            this.ScreenText.TabIndex = 1;
            this.ScreenText.TabStop = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(3, 7);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(602, 18);
            this.label1.TabIndex = 13;
            this.label1.Text = "3270 Screen";
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.WorkTabPage);
            this.tabControl1.Controls.Add(this.CustomersTabPage);
            this.tabControl1.Controls.Add(this.AccountsTabPage);
            this.tabControl1.Controls.Add(this.ConfigurationTabPage);
            this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControl1.Location = new System.Drawing.Point(0, 0);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(429, 561);
            this.tabControl1.TabIndex = 14;
            // 
            // WorkTabPage
            // 
            this.WorkTabPage.Controls.Add(this.ReconfigureButton);
            this.WorkTabPage.Controls.Add(this.FinishWithCustomer);
            this.WorkTabPage.Controls.Add(this.WorkWithCustomer);
            this.WorkTabPage.Controls.Add(this.label5);
            this.WorkTabPage.Controls.Add(this.InputCustomerBox);
            this.WorkTabPage.Location = new System.Drawing.Point(4, 22);
            this.WorkTabPage.Name = "WorkTabPage";
            this.WorkTabPage.Padding = new System.Windows.Forms.Padding(3);
            this.WorkTabPage.Size = new System.Drawing.Size(421, 535);
            this.WorkTabPage.TabIndex = 2;
            this.WorkTabPage.Text = "Work";
            this.WorkTabPage.UseVisualStyleBackColor = true;
            // 
            // ReconfigureButton
            // 
            this.ReconfigureButton.Location = new System.Drawing.Point(252, 84);
            this.ReconfigureButton.Name = "ReconfigureButton";
            this.ReconfigureButton.Size = new System.Drawing.Size(142, 23);
            this.ReconfigureButton.TabIndex = 6;
            this.ReconfigureButton.Text = "Re-Configure";
            this.ReconfigureButton.UseVisualStyleBackColor = true;
            this.ReconfigureButton.Click += new System.EventHandler(this.ReconfigureButton_Click);
            // 
            // FinishWithCustomer
            // 
            this.FinishWithCustomer.Location = new System.Drawing.Point(252, 55);
            this.FinishWithCustomer.Name = "FinishWithCustomer";
            this.FinishWithCustomer.Size = new System.Drawing.Size(142, 23);
            this.FinishWithCustomer.TabIndex = 4;
            this.FinishWithCustomer.Text = "Finished with Customer";
            this.FinishWithCustomer.UseVisualStyleBackColor = true;
            this.FinishWithCustomer.Click += new System.EventHandler(this.FinishWithCustomer_Click);
            // 
            // WorkWithCustomer
            // 
            this.WorkWithCustomer.Location = new System.Drawing.Point(252, 26);
            this.WorkWithCustomer.Name = "WorkWithCustomer";
            this.WorkWithCustomer.Size = new System.Drawing.Size(142, 23);
            this.WorkWithCustomer.TabIndex = 3;
            this.WorkWithCustomer.Text = "Work with Customer";
            this.WorkWithCustomer.UseVisualStyleBackColor = true;
            this.WorkWithCustomer.Click += new System.EventHandler(this.WorkWithCustomer_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(6, 9);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(131, 18);
            this.label5.TabIndex = 5;
            this.label5.Text = "Customer Name";
            // 
            // InputCustomerBox
            // 
            this.InputCustomerBox.Location = new System.Drawing.Point(8, 28);
            this.InputCustomerBox.MaxLength = 30;
            this.InputCustomerBox.Name = "InputCustomerBox";
            this.InputCustomerBox.Size = new System.Drawing.Size(237, 20);
            this.InputCustomerBox.TabIndex = 2;
            // 
            // CustomersTabPage
            // 
            this.CustomersTabPage.Controls.Add(this.MessagesListBox);
            this.CustomersTabPage.Controls.Add(this.StatementsButton);
            this.CustomersTabPage.Controls.Add(this.BalanceButton);
            this.CustomersTabPage.Controls.Add(this.label4);
            this.CustomersTabPage.Controls.Add(this.AccountsComboBox);
            this.CustomersTabPage.Controls.Add(this.label3);
            this.CustomersTabPage.Controls.Add(this.label2);
            this.CustomersTabPage.Controls.Add(this.CustomerNameBox);
            this.CustomersTabPage.Location = new System.Drawing.Point(4, 22);
            this.CustomersTabPage.Name = "CustomersTabPage";
            this.CustomersTabPage.Padding = new System.Windows.Forms.Padding(3);
            this.CustomersTabPage.Size = new System.Drawing.Size(421, 535);
            this.CustomersTabPage.TabIndex = 0;
            this.CustomersTabPage.Text = "Customers";
            this.CustomersTabPage.UseVisualStyleBackColor = true;
            // 
            // MessagesListBox
            // 
            this.MessagesListBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.MessagesListBox.FormattingEnabled = true;
            this.MessagesListBox.ItemHeight = 17;
            this.MessagesListBox.Location = new System.Drawing.Point(9, 166);
            this.MessagesListBox.Name = "MessagesListBox";
            this.MessagesListBox.Size = new System.Drawing.Size(392, 276);
            this.MessagesListBox.TabIndex = 5;
            // 
            // StatementsButton
            // 
            this.StatementsButton.Location = new System.Drawing.Point(316, 46);
            this.StatementsButton.Name = "StatementsButton";
            this.StatementsButton.Size = new System.Drawing.Size(85, 23);
            this.StatementsButton.TabIndex = 4;
            this.StatementsButton.Text = "Statements";
            this.StatementsButton.UseVisualStyleBackColor = true;
            this.StatementsButton.Click += new System.EventHandler(this.StatementsButton_Click);
            // 
            // BalanceButton
            // 
            this.BalanceButton.Location = new System.Drawing.Point(316, 106);
            this.BalanceButton.Name = "BalanceButton";
            this.BalanceButton.Size = new System.Drawing.Size(85, 23);
            this.BalanceButton.TabIndex = 3;
            this.BalanceButton.Text = "Balance";
            this.BalanceButton.UseVisualStyleBackColor = true;
            this.BalanceButton.Click += new System.EventHandler(this.BalanceButton_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(6, 147);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(85, 18);
            this.label4.TabIndex = 8;
            this.label4.Text = "Messages";
            // 
            // AccountsComboBox
            // 
            this.AccountsComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.AccountsComboBox.FormattingEnabled = true;
            this.AccountsComboBox.Location = new System.Drawing.Point(9, 106);
            this.AccountsComboBox.Name = "AccountsComboBox";
            this.AccountsComboBox.Size = new System.Drawing.Size(210, 21);
            this.AccountsComboBox.TabIndex = 2;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(6, 87);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(78, 18);
            this.label3.TabIndex = 7;
            this.label3.Text = "Accounts";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(6, 27);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(131, 18);
            this.label2.TabIndex = 6;
            this.label2.Text = "Customer Name";
            // 
            // CustomerNameBox
            // 
            this.CustomerNameBox.Location = new System.Drawing.Point(9, 46);
            this.CustomerNameBox.Name = "CustomerNameBox";
            this.CustomerNameBox.ReadOnly = true;
            this.CustomerNameBox.Size = new System.Drawing.Size(210, 20);
            this.CustomerNameBox.TabIndex = 1;
            // 
            // AccountsTabPage
            // 
            this.AccountsTabPage.Controls.Add(this.label11);
            this.AccountsTabPage.Controls.Add(this.label10);
            this.AccountsTabPage.Controls.Add(this.label7);
            this.AccountsTabPage.Controls.Add(this.StreetBox);
            this.AccountsTabPage.Controls.Add(this.CityBox);
            this.AccountsTabPage.Controls.Add(this.SSNBox);
            this.AccountsTabPage.Controls.Add(this.AccountMessagesListBox);
            this.AccountsTabPage.Controls.Add(this.label6);
            this.AccountsTabPage.Controls.Add(this.label8);
            this.AccountsTabPage.Controls.Add(this.AccountCustomerNameBox);
            this.AccountsTabPage.Controls.Add(this.groupBox1);
            this.AccountsTabPage.Controls.Add(this.groupBox2);
            this.AccountsTabPage.Location = new System.Drawing.Point(4, 22);
            this.AccountsTabPage.Name = "AccountsTabPage";
            this.AccountsTabPage.Padding = new System.Windows.Forms.Padding(3);
            this.AccountsTabPage.Size = new System.Drawing.Size(421, 535);
            this.AccountsTabPage.TabIndex = 1;
            this.AccountsTabPage.Text = "Accounts";
            this.AccountsTabPage.UseVisualStyleBackColor = true;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.Location = new System.Drawing.Point(6, 105);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(53, 18);
            this.label11.TabIndex = 17;
            this.label11.Text = "Street";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.Location = new System.Drawing.Point(6, 147);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(37, 18);
            this.label10.TabIndex = 18;
            this.label10.Text = "City";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(6, 63);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(42, 18);
            this.label7.TabIndex = 16;
            this.label7.Text = "SSN";
            // 
            // StreetBox
            // 
            this.StreetBox.Location = new System.Drawing.Point(9, 124);
            this.StreetBox.MaxLength = 20;
            this.StreetBox.Name = "StreetBox";
            this.StreetBox.Size = new System.Drawing.Size(274, 20);
            this.StreetBox.TabIndex = 3;
            this.StreetBox.TextChanged += new System.EventHandler(this.StreetBox_TextChanged);
            // 
            // CityBox
            // 
            this.CityBox.Location = new System.Drawing.Point(9, 166);
            this.CityBox.MaxLength = 15;
            this.CityBox.Name = "CityBox";
            this.CityBox.Size = new System.Drawing.Size(207, 20);
            this.CityBox.TabIndex = 4;
            this.CityBox.TextChanged += new System.EventHandler(this.CityBox_TextChanged);
            // 
            // SSNBox
            // 
            this.SSNBox.ImeMode = System.Windows.Forms.ImeMode.Off;
            this.SSNBox.Location = new System.Drawing.Point(9, 82);
            this.SSNBox.MaxLength = 9;
            this.SSNBox.Name = "SSNBox";
            this.SSNBox.Size = new System.Drawing.Size(164, 20);
            this.SSNBox.TabIndex = 2;
            this.SSNBox.TextChanged += new System.EventHandler(this.SSNBox_TextChanged);
            this.SSNBox.KeyDown += new System.Windows.Forms.KeyEventHandler(this.SSNBox_KeyDown);
            this.SSNBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.SSNBox_KeyPress);
            // 
            // AccountMessagesListBox
            // 
            this.AccountMessagesListBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AccountMessagesListBox.FormattingEnabled = true;
            this.AccountMessagesListBox.ItemHeight = 17;
            this.AccountMessagesListBox.Location = new System.Drawing.Point(9, 336);
            this.AccountMessagesListBox.Name = "AccountMessagesListBox";
            this.AccountMessagesListBox.Size = new System.Drawing.Size(408, 106);
            this.AccountMessagesListBox.TabIndex = 400;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(6, 319);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(85, 18);
            this.label6.TabIndex = 23;
            this.label6.Text = "Messages";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.Location = new System.Drawing.Point(6, 21);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(131, 18);
            this.label8.TabIndex = 15;
            this.label8.Text = "Customer Name";
            // 
            // AccountCustomerNameBox
            // 
            this.AccountCustomerNameBox.Location = new System.Drawing.Point(9, 40);
            this.AccountCustomerNameBox.Name = "AccountCustomerNameBox";
            this.AccountCustomerNameBox.ReadOnly = true;
            this.AccountCustomerNameBox.Size = new System.Drawing.Size(274, 20);
            this.AccountCustomerNameBox.TabIndex = 1;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.PhoneBox);
            this.groupBox1.Controls.Add(this.label13);
            this.groupBox1.Controls.Add(this.UpdateCustomerButton);
            this.groupBox1.Controls.Add(this.ZIPBox);
            this.groupBox1.Controls.Add(this.StateBox);
            this.groupBox1.Controls.Add(this.label12);
            this.groupBox1.Controls.Add(this.NewCustomerButton);
            this.groupBox1.Controls.Add(this.label9);
            this.groupBox1.Location = new System.Drawing.Point(3, 6);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(414, 232);
            this.groupBox1.TabIndex = 14;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Customer Information";
            // 
            // PhoneBox
            // 
            this.PhoneBox.ImeMode = System.Windows.Forms.ImeMode.Off;
            this.PhoneBox.Location = new System.Drawing.Point(125, 202);
            this.PhoneBox.MaxLength = 13;
            this.PhoneBox.Name = "PhoneBox";
            this.PhoneBox.Size = new System.Drawing.Size(155, 20);
            this.PhoneBox.TabIndex = 7;
            this.PhoneBox.TextChanged += new System.EventHandler(this.PhoneBox_TextChanged);
            this.PhoneBox.KeyDown += new System.Windows.Forms.KeyEventHandler(this.PhoneBox_KeyDown);
            this.PhoneBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.PhoneBox_KeyPress);
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.Location = new System.Drawing.Point(130, 181);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(56, 18);
            this.label13.TabIndex = 21;
            this.label13.Text = "Phone";
            // 
            // UpdateCustomerButton
            // 
            this.UpdateCustomerButton.Location = new System.Drawing.Point(298, 73);
            this.UpdateCustomerButton.Name = "UpdateCustomerButton";
            this.UpdateCustomerButton.Size = new System.Drawing.Size(102, 23);
            this.UpdateCustomerButton.TabIndex = 9;
            this.UpdateCustomerButton.Text = "Update Customer";
            this.UpdateCustomerButton.UseVisualStyleBackColor = true;
            this.UpdateCustomerButton.Click += new System.EventHandler(this.UpdateCustomerButton_Click);
            // 
            // ZIPBox
            // 
            this.ZIPBox.ImeMode = System.Windows.Forms.ImeMode.Off;
            this.ZIPBox.Location = new System.Drawing.Point(5, 202);
            this.ZIPBox.MaxLength = 5;
            this.ZIPBox.Name = "ZIPBox";
            this.ZIPBox.Size = new System.Drawing.Size(114, 20);
            this.ZIPBox.TabIndex = 6;
            this.ZIPBox.TextChanged += new System.EventHandler(this.ZIPBox_TextChanged);
            this.ZIPBox.KeyDown += new System.Windows.Forms.KeyEventHandler(this.ZIPBox_KeyDown);
            this.ZIPBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.ZIPBox_KeyPress);
            // 
            // StateBox
            // 
            this.StateBox.Location = new System.Drawing.Point(236, 160);
            this.StateBox.MaxLength = 2;
            this.StateBox.Name = "StateBox";
            this.StateBox.Size = new System.Drawing.Size(44, 20);
            this.StateBox.TabIndex = 5;
            this.StateBox.TextChanged += new System.EventHandler(this.StateBox_TextChanged);
            this.StateBox.KeyDown += new System.Windows.Forms.KeyEventHandler(this.StateBox_KeyDown);
            this.StateBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.StateBox_KeyPress);
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.Location = new System.Drawing.Point(3, 183);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(33, 18);
            this.label12.TabIndex = 20;
            this.label12.Text = "ZIP";
            // 
            // NewCustomerButton
            // 
            this.NewCustomerButton.Location = new System.Drawing.Point(298, 31);
            this.NewCustomerButton.Name = "NewCustomerButton";
            this.NewCustomerButton.Size = new System.Drawing.Size(102, 23);
            this.NewCustomerButton.TabIndex = 8;
            this.NewCustomerButton.Text = "New Customer";
            this.NewCustomerButton.UseVisualStyleBackColor = true;
            this.NewCustomerButton.Click += new System.EventHandler(this.NewCustomerButton_Click);
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.Location = new System.Drawing.Point(230, 141);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(47, 18);
            this.label9.TabIndex = 19;
            this.label9.Text = "State";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.NewSavingsCheckbox);
            this.groupBox2.Controls.Add(this.NewCheckingCheckbox);
            this.groupBox2.Controls.Add(this.AddAccountsButton);
            this.groupBox2.Location = new System.Drawing.Point(3, 246);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(414, 70);
            this.groupBox2.TabIndex = 22;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Additional Accounts";
            // 
            // NewSavingsCheckbox
            // 
            this.NewSavingsCheckbox.AutoSize = true;
            this.NewSavingsCheckbox.Location = new System.Drawing.Point(6, 42);
            this.NewSavingsCheckbox.Name = "NewSavingsCheckbox";
            this.NewSavingsCheckbox.Size = new System.Drawing.Size(132, 17);
            this.NewSavingsCheckbox.TabIndex = 11;
            this.NewSavingsCheckbox.Text = "New Savings Account";
            this.NewSavingsCheckbox.UseVisualStyleBackColor = true;
            this.NewSavingsCheckbox.CheckedChanged += new System.EventHandler(this.NewSavingsCheckbox_CheckedChanged);
            // 
            // NewCheckingCheckbox
            // 
            this.NewCheckingCheckbox.AutoSize = true;
            this.NewCheckingCheckbox.Location = new System.Drawing.Point(6, 19);
            this.NewCheckingCheckbox.Name = "NewCheckingCheckbox";
            this.NewCheckingCheckbox.Size = new System.Drawing.Size(139, 17);
            this.NewCheckingCheckbox.TabIndex = 10;
            this.NewCheckingCheckbox.Text = "New Checking Account";
            this.NewCheckingCheckbox.UseVisualStyleBackColor = true;
            this.NewCheckingCheckbox.CheckedChanged += new System.EventHandler(this.NewCheckingCheckbox_CheckedChanged);
            // 
            // AddAccountsButton
            // 
            this.AddAccountsButton.Location = new System.Drawing.Point(298, 19);
            this.AddAccountsButton.Name = "AddAccountsButton";
            this.AddAccountsButton.Size = new System.Drawing.Size(102, 23);
            this.AddAccountsButton.TabIndex = 12;
            this.AddAccountsButton.Text = "Add Accounts";
            this.AddAccountsButton.UseVisualStyleBackColor = true;
            this.AddAccountsButton.Click += new System.EventHandler(this.AddAccountsButton_Click);
            // 
            // ConfigurationTabPage
            // 
            this.ConfigurationTabPage.Controls.Add(this.tableLayoutPanel2);
            this.ConfigurationTabPage.Location = new System.Drawing.Point(4, 22);
            this.ConfigurationTabPage.Name = "ConfigurationTabPage";
            this.ConfigurationTabPage.Padding = new System.Windows.Forms.Padding(3);
            this.ConfigurationTabPage.Size = new System.Drawing.Size(421, 535);
            this.ConfigurationTabPage.TabIndex = 3;
            this.ConfigurationTabPage.Text = "Configuration";
            this.ConfigurationTabPage.UseVisualStyleBackColor = true;
            this.ConfigurationTabPage.Click += new System.EventHandler(this.ConfigurationTabPage_Click);
            // 
            // StartWorkButton
            // 
            this.StartWorkButton.Location = new System.Drawing.Point(3, 225);
            this.StartWorkButton.Name = "StartWorkButton";
            this.StartWorkButton.Size = new System.Drawing.Size(157, 23);
            this.StartWorkButton.TabIndex = 9;
            this.StartWorkButton.Text = "Start Work";
            this.StartWorkButton.UseVisualStyleBackColor = true;
            this.StartWorkButton.Click += new System.EventHandler(this.StartWorkButton_Click);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.InputCICSNameBox);
            this.groupBox3.Controls.Add(this.label16);
            this.groupBox3.Controls.Add(this.InputLUNameBox);
            this.groupBox3.Controls.Add(this.label14);
            this.groupBox3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox3.Location = new System.Drawing.Point(3, 73);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(409, 146);
            this.groupBox3.TabIndex = 8;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "3270 Parameters";
            // 
            // InputCICSNameBox
            // 
            this.InputCICSNameBox.Location = new System.Drawing.Point(9, 77);
            this.InputCICSNameBox.MaxLength = 8;
            this.InputCICSNameBox.Name = "InputCICSNameBox";
            this.InputCICSNameBox.Size = new System.Drawing.Size(298, 20);
            this.InputCICSNameBox.TabIndex = 12;
            this.InputCICSNameBox.TextChanged += new System.EventHandler(this.InputCICSNameBox_TextChanged);
            this.InputCICSNameBox.Leave += new System.EventHandler(this.InputCICSNameBox_Leave);
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label16.Location = new System.Drawing.Point(6, 58);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(96, 18);
            this.label16.TabIndex = 11;
            this.label16.Text = "CICS Name";
            // 
            // InputLUNameBox
            // 
            this.InputLUNameBox.Location = new System.Drawing.Point(9, 35);
            this.InputLUNameBox.MaxLength = 8;
            this.InputLUNameBox.Name = "InputLUNameBox";
            this.InputLUNameBox.Size = new System.Drawing.Size(298, 20);
            this.InputLUNameBox.TabIndex = 10;
            this.InputLUNameBox.TextChanged += new System.EventHandler(this.InputLUNameBox_TextChanged);
            this.InputLUNameBox.Leave += new System.EventHandler(this.InputLUNameBox_Leave);
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label14.Location = new System.Drawing.Point(6, 16);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(139, 18);
            this.label14.TabIndex = 9;
            this.label14.Text = "LU or Pool Name";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label15.Location = new System.Drawing.Point(3, 0);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(187, 18);
            this.label15.TabIndex = 7;
            this.label15.Text = "Communication Method";
            // 
            // COM3270RadioButton
            // 
            this.COM3270RadioButton.AutoSize = true;
            this.COM3270RadioButton.Location = new System.Drawing.Point(3, 50);
            this.COM3270RadioButton.Name = "COM3270RadioButton";
            this.COM3270RadioButton.Size = new System.Drawing.Size(49, 17);
            this.COM3270RadioButton.TabIndex = 1;
            this.COM3270RadioButton.Text = "3270";
            this.COM3270RadioButton.UseVisualStyleBackColor = true;
            this.COM3270RadioButton.CheckedChanged += new System.EventHandler(this.COM3270RadioButton_CheckedChanged);
            // 
            // TIRadioButton
            // 
            this.TIRadioButton.AutoSize = true;
            this.TIRadioButton.Checked = true;
            this.TIRadioButton.Location = new System.Drawing.Point(3, 23);
            this.TIRadioButton.Name = "TIRadioButton";
            this.TIRadioButton.Size = new System.Drawing.Size(129, 17);
            this.TIRadioButton.TabIndex = 0;
            this.TIRadioButton.TabStop = true;
            this.TIRadioButton.Text = "Transaction Integrator";
            this.TIRadioButton.UseVisualStyleBackColor = true;
            this.TIRadioButton.CheckedChanged += new System.EventHandler(this.TIRadioButton_CheckedChanged);
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.tabControl1);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.tableLayoutPanel1);
            this.splitContainer1.Size = new System.Drawing.Size(1041, 561);
            this.splitContainer1.SplitterDistance = 429;
            this.splitContainer1.TabIndex = 15;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.ScreenText, 0, 1);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 4.634581F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 95.36542F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(608, 561);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.AutoSize = true;
            this.tableLayoutPanel2.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel2.ColumnCount = 1;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Controls.Add(this.label15, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.StartWorkButton, 0, 4);
            this.tableLayoutPanel2.Controls.Add(this.TIRadioButton, 0, 1);
            this.tableLayoutPanel2.Controls.Add(this.groupBox3, 0, 3);
            this.tableLayoutPanel2.Controls.Add(this.COM3270RadioButton, 0, 2);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 6;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 27F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 23F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 152F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 33F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(415, 529);
            this.tableLayoutPanel2.TabIndex = 10;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1041, 561);
            this.Controls.Add(this.splitContainer1);
            this.Name = "Form1";
            this.Text = "COM 3270 Sample - Running against CICS Sample Woodgrove Bank";
            this.Load += new System.EventHandler(this.Form1_Load);
 	    this.Closing += new System.ComponentModel.CancelEventHandler(this.Form1_Closing);
            this.tabControl1.ResumeLayout(false);
            this.WorkTabPage.ResumeLayout(false);
            this.WorkTabPage.PerformLayout();
            this.CustomersTabPage.ResumeLayout(false);
            this.CustomersTabPage.PerformLayout();
            this.AccountsTabPage.ResumeLayout(false);
            this.AccountsTabPage.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ConfigurationTabPage.ResumeLayout(false);
            this.ConfigurationTabPage.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.ResumeLayout(false);

        }
        #endregion

        private System.Windows.Forms.TextBox ScreenText;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage CustomersTabPage;
        private System.Windows.Forms.TabPage AccountsTabPage;
        private System.Windows.Forms.ComboBox AccountsComboBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox CustomerNameBox;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ListBox MessagesListBox;
        private System.Windows.Forms.Button StatementsButton;
        private System.Windows.Forms.Button BalanceButton;
        private System.Windows.Forms.TabPage WorkTabPage;
		private System.Windows.Forms.Button FinishWithCustomer;
        private System.Windows.Forms.Button WorkWithCustomer;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox InputCustomerBox;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox StreetBox;
        private System.Windows.Forms.TextBox CityBox;
        private System.Windows.Forms.TextBox StateBox;
        private System.Windows.Forms.TextBox SSNBox;
        private System.Windows.Forms.Button AddAccountsButton;
        private System.Windows.Forms.Button NewCustomerButton;
        private System.Windows.Forms.ListBox AccountMessagesListBox;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox AccountCustomerNameBox;
        private System.Windows.Forms.TextBox PhoneBox;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.TextBox ZIPBox;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.CheckBox NewSavingsCheckbox;
        private System.Windows.Forms.CheckBox NewCheckingCheckbox;
        private System.Windows.Forms.Button UpdateCustomerButton;
        private System.Windows.Forms.TabPage ConfigurationTabPage;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.RadioButton COM3270RadioButton;
        private System.Windows.Forms.RadioButton TIRadioButton;
        private System.Windows.Forms.Button StartWorkButton;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.TextBox InputCICSNameBox;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.TextBox InputLUNameBox;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.Button ReconfigureButton;
		private System.Windows.Forms.SplitContainer splitContainer1;
		private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
		private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
    }
}

