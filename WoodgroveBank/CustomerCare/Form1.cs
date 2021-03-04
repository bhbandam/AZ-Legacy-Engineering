using System;
using System.Reflection;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Microsoft.HostIntegration.SNA.Session;
using System.Timers;
using System.IO;

namespace CSClient
{
    public partial class Form1 : Form
    {
        private bool _use3270 = true;
        private SessionDisplay m_Handler = null;
        private bool _hostOK = false;
        private AccountHandler _accountHandler = null;
        private string _accountName = "";

        private string[] _accountNumbers;

        private Font _FixedFont;

        // checking for numerical vs non-numerical character entered
        private bool _nonNumberEntered = false;
        private bool _SSNValid = false;
        private bool _StreetValid = false;
        private bool _CityValid = false;
        private bool _StateValid = false;
        private bool _ZIPValid = false;
        private bool _PhoneValid = false;

        private bool _CustomerPageEnabled = false;

        private int _largeWindowSize;

        public Form1()
        {
            InitializeComponent();
        }

        private bool SetOpeningState()
        {
            try
            {
                // if we are doing 3270
                if (_use3270)
                {
                    // connect to the host if not already done so
                    if (m_Handler == null)
                    {
                        m_Handler = new SessionDisplay ();
                        m_Handler.Connect("TRANSPORT=SNA;LOGICALUNITNAME=" + this.InputLUNameBox.Text.Trim().ToUpperInvariant());
                        m_Handler.Connection.HostCodePage = 37;

                        // set the large form, so that we can see 3270 stuff
                        this.Width = _largeWindowSize;

                        // wait for the Message 10 Screen
                        m_Handler.WaitForContent("TERM NAME", 20000);

                        // try to connect to CICS
                        m_Handler.SendKey("LOGON APPLID(" + this.InputCICSNameBox.Text.Trim().ToUpperInvariant() + ")@E");

                        // must be in PLU session
                        m_Handler.WaitForSession (SessionDisplayWaitType.PLUSLU, 20000);

                        // wait for the blurb to come
                        m_Handler.WaitForContent(@"DEMONSTRATION", 20000);

                        // go to the clear screen
                        ClearScreenAndWait();

                        _hostOK = true;
                    }
                }
                else
                {
                    // squash the form down!
                    this.Width = 1049;
                    this.Height = 588;
                    _hostOK = true;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                if (m_Handler != null)
                    m_Handler.Disconnect();
                m_Handler = null;
                return false;
            }
            DisableEverything();

            EnableWorkTab();
            return true;
        }

        // Routine to send the Clear Screen command and then wait until the Session Calms down
        private void ClearScreenAndWait()
        {
            m_Handler.SendKey("@C");

            m_Handler.WaitForSession (SessionDisplayWaitType.NotBusy, 20000);
        }


#region Enable Disable Elements
        private void DisableEverything()
        {
            DisableConfigurationTab();
            DisableWorkTab();
            DisableCustomersTab();
            DisableAccountsTab();
        }
        private void DisableConfigurationTab()
        {
            // remove the configuration tab
            this.tabControl1.TabPages.Remove(ConfigurationTabPage);
        }
        private void EnableConfiguration()
        {
            DisableEverything();
            EnableConfigurationTab();
        }
        private void EnableConfigurationTab()
        {
            // add the tab to the control
            this.tabControl1.TabPages.Add(ConfigurationTabPage);

            // set the 3270 radion button and update stuff
            this.COM3270RadioButton.Checked = _use3270;
            this.TIRadioButton.Checked = !_use3270;
            EnableDisable3270ParametersAndStartWork();
        }
        private void DisableWorkTab()
        {
            // remove the work tab
            this.tabControl1.TabPages.Remove(WorkTabPage);

            this.WorkWithCustomer.Enabled = false;
            this.ReconfigureButton.Enabled = false;
            this.FinishWithCustomer.Enabled = false;
            this.InputCustomerBox.Enabled = false;
        }
        private void EnableWorkTab()
        {
            // add the tab to the control
            this.tabControl1.TabPages.Add(WorkTabPage);

            this.WorkWithCustomer.Enabled = true;
            this.ReconfigureButton.Enabled = true;
            if (_hostOK)
            {
                this.InputCustomerBox.Enabled = true;
                this.InputCustomerBox.Text = "";
            }
        }
        private void DisableCustomersTab()
        {
            // remove the customer tab
            this.tabControl1.TabPages.Remove(CustomersTabPage);

            _CustomerPageEnabled = false;
        }
        private void DisableAccountsTab()
        {
            this.tabControl1.TabPages.Remove(AccountsTabPage);
        }
        private void EnableCustomersTab()
        {
            // add the tab to the control
            this.tabControl1.TabPages.Add(CustomersTabPage);

            // add the name
            this.CustomerNameBox.Text = _accountName;

            // fill out the Accounts combobox
            _accountNumbers = _accountHandler.AccountNumbers;
            this.AccountsComboBox.DataSource = _accountNumbers;

            // clear the message box
            this.MessagesListBox.Items.Clear();

            _CustomerPageEnabled = true;
        }
        private void EnableAccountsTab()
        {
            // add the Accounts control
            this.tabControl1.TabPages.Add(AccountsTabPage);

            // set the customer name
            this.AccountCustomerNameBox.Text = _accountName;

            // when we enter here, there is not enough info in the new customer
            EnableDisableNewCustomer();

            if (_accountHandler.IsExistingCustomer)
            {
                this.UpdateCustomerButton.Enabled = true;
                this.SSNBox.Enabled = false;

                EnableNewAccounts();
            }
            else
            {
                this.UpdateCustomerButton.Enabled = false;
                this.SSNBox.Enabled = true;

                DisableNewAccounts();
            }
        }
        private void EnableNewAccounts()
        {
            this.NewCheckingCheckbox.CheckState = CheckState.Unchecked;
            this.NewCheckingCheckbox.Enabled = true;
            this.NewSavingsCheckbox.CheckState = CheckState.Unchecked;
            this.NewSavingsCheckbox.Enabled = true;
            this.AddAccountsButton.Enabled = false;
        }
        private void DisableNewAccounts()
        {
            this.NewCheckingCheckbox.CheckState = CheckState.Unchecked;
            this.NewCheckingCheckbox.Enabled = false;
            this.NewSavingsCheckbox.CheckState = CheckState.Unchecked;
            this.NewSavingsCheckbox.Enabled = false;
            this.AddAccountsButton.Enabled = false;
        }
        private void MoveToCustomersTab()
        {
            this.tabControl1.SelectedTab = CustomersTabPage;
        }
        private void MoveToAccountsTab()
        {
            this.tabControl1.SelectedTab = AccountsTabPage;
        }
        private void EnableDisableNewCustomer()
        {
            bool _allValid = _SSNValid && _StreetValid && _CityValid && _StateValid && _ZIPValid && _PhoneValid;

            if (_accountHandler.IsExistingCustomer)
            {
                this.NewCustomerButton.Enabled = false;

                if (_allValid)
                    this.UpdateCustomerButton.Enabled = true;
                else
                    this.UpdateCustomerButton.Enabled = false;

                return;
            }

            if (_allValid)
                this.NewCustomerButton.Enabled = true;
            else
                this.NewCustomerButton.Enabled = false;
        }
        private void EnableDisableStartWork()
        {
            // basically always enabled
            bool enabled = true;
            
            // unless there is nothing in one of the 2 input boxes and 3270 is checked
            if (this.COM3270RadioButton.Checked)
            {
                if ((this.InputCICSNameBox.Text.Trim().Length == 0) || (this.InputLUNameBox.Text.Trim().Length == 0))
                    enabled = false;
            }

            this.StartWorkButton.Enabled = enabled;
        }

        private void EnableDisable3270ParametersAndStartWork()
        {
            if (this.COM3270RadioButton.Checked)
            {
                this.InputLUNameBox.Enabled = true;
                this.InputCICSNameBox.Enabled = true;
                EnableDisableStartWork();
            }
            else
            {
                this.InputLUNameBox.Enabled = false;
                this.InputCICSNameBox.Enabled = false;
                EnableDisableStartWork();
            }
        }
#endregion

        private void Form1_Load(object sender, EventArgs e)
        {
            // get the window width 
            _largeWindowSize = this.Width;

            // setup a fixed font
            FontFamily fontFamily = new FontFamily("Courier New");
            _FixedFont = new Font(fontFamily, 12, FontStyle.Bold, GraphicsUnit.Pixel);

            // set the messages box to this font
            this.MessagesListBox.Font = _FixedFont;

            // set the Configuration Tab as the only tab
            EnableConfiguration ();
        }

        private void Form1_Closing(object sender, EventArgs e)
        {
            if (m_Handler != null)
                m_Handler.Disconnect();
            m_Handler = null;
        }

        private void WorkWithCustomer_Click(object sender, EventArgs e)
        {
            try
            {
                // flip the buttons
                this.WorkWithCustomer.Enabled = false;
                this.ReconfigureButton.Enabled = false;
                this.FinishWithCustomer.Enabled = true;

                // create an account handler, with all the available info
                if (_use3270)
                {
                    AccountHandler3270 accHandler3270 = new AccountHandler3270(m_Handler);
                    _accountHandler = accHandler3270 as AccountHandler;
                    accHandler3270.TraceBox = ScreenText;
                }
                else
                    _accountHandler = new AccountHandlerTI() as AccountHandler;

                // go get the customers info
                _accountHandler.ValidateCustomer(this.InputCustomerBox.Text);

                // save the account name, add it to the appropriate boxes
                _accountName = this.InputCustomerBox.Text;

                // Add the tabs as appropriate: check for this being an existing customer
                if (_accountHandler.IsExistingCustomer)
                {
                    // fill out the customer data
                    CustomerDetailsFromHandler();

                    EnableCustomersTab();
                    EnableAccountsTab();

                    MoveToCustomersTab();
                }
                else
                {
                    EnableAccountsTab();
                    MoveToAccountsTab();

                    this.SSNBox.Text = "";
                    _SSNValid = false;

                    this.StreetBox.Text = "";
                    _StreetValid = false;

                    this.CityBox.Text = "";
                    _CityValid = false;

                    this.StateBox.Text = "";
                    _StateValid = false;

                    this.ZIPBox.Text = "";
                    _ZIPValid = false;

                    this.PhoneBox.Text = "";
                    _PhoneValid = false;

                    
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void FinishWithCustomer_Click(object sender, EventArgs e)
        {
            // set the message boxes back to empty
            this.AccountMessagesListBox.ResetText();
            this.MessagesListBox.ResetText();

            // get rid of the Customer
            _accountHandler.FinishWithCustomer();

            // back to the opening state
            SetOpeningState();
        }

        private void BalanceButton_Click(object sender, EventArgs e)
        {
            try
            {
                // get the chosen Account Number
                string accountNumber = (string) this.AccountsComboBox.SelectedItem;

                // ask the account handler for the balance
                decimal balance = _accountHandler.GetAccountBalance(accountNumber);

                // write out a nice message
                string line = "Account Balance for Account " + accountNumber + " is " + balance.ToString();
                MessagesListBox.Items.Add(line);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void StatementsButton_Click(object sender, EventArgs e)
        {
            try
            {
                // ask the account handler for the statements
                string [] statements = _accountHandler.GetStatements();

                // write out a nice message
                string line = "Statements for " + _accountName ;
                MessagesListBox.Items.Add(line);

                // and for each statement add it
                foreach (string statementLine in statements)
                    MessagesListBox.Items.Add(statementLine);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void NewCheckingCheckbox_CheckedChanged(object sender, EventArgs e)
        {
            // check for either button being checked
            if ( (this.NewCheckingCheckbox.CheckState == CheckState.Checked) ||  (this.NewSavingsCheckbox.CheckState == CheckState.Checked) )
                this.AddAccountsButton.Enabled = true;
            else
                this.AddAccountsButton.Enabled = false;
        }

        private void NewSavingsCheckbox_CheckedChanged(object sender, EventArgs e)
        {
            // check for either button being checked
            if ((this.NewCheckingCheckbox.CheckState == CheckState.Checked) || (this.NewSavingsCheckbox.CheckState == CheckState.Checked))
                this.AddAccountsButton.Enabled = true;
            else
                this.AddAccountsButton.Enabled = false;
        }

        private void AddAccountsButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (this.NewCheckingCheckbox.CheckState == CheckState.Checked) 
                    _accountHandler.CreateNewAccount (AccountType.Checking);

                if (this.NewSavingsCheckbox.CheckState == CheckState.Checked)
                    _accountHandler.CreateNewAccount(AccountType.Savings);

                // fill out the Accounts combobox
                _accountNumbers = _accountHandler.AccountNumbers;
                this.AccountsComboBox.DataSource = _accountNumbers;

                // enable the Customer Page if it is not yet enabled
                if (!_CustomerPageEnabled)
                    EnableCustomersTab();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void SSNBox_TextChanged(object sender, EventArgs e)
        {
            // check for the length
            if (this.SSNBox.Text.Trim().Length == 9)
                _SSNValid = true;
            else
                _SSNValid = false;

            EnableDisableNewCustomer();
        }

        private void StreetBox_TextChanged(object sender, EventArgs e)
        {
            // must be some input
            if (this.StreetBox.Text.Trim().Length != 0)
                _StreetValid = true;
            else
                _StreetValid = false;
        }

        private void CityBox_TextChanged(object sender, EventArgs e)
        {
            // must be some input
            if (this.CityBox.Text.Trim().Length != 0)
                _CityValid = true;
            else
                _CityValid = false;

            EnableDisableNewCustomer();
        }

        private void StateBox_TextChanged(object sender, EventArgs e)
        {
            // check for the length
            if (this.StateBox.Text.Trim().Length == 2)
                _StateValid = true;
            else
                _StateValid = false;

            EnableDisableNewCustomer();
        }

        private void ZIPBox_TextChanged(object sender, EventArgs e)
        {
            // check for the length
            if (this.ZIPBox.Text.Trim().Length == 5)
                _ZIPValid = true;
            else
                _ZIPValid = false; 
            
            EnableDisableNewCustomer();
        }

        private void PhoneBox_TextChanged(object sender, EventArgs e)
        {
            // check for the length
            if (this.PhoneBox.Text.Trim().Length == 10)
                _PhoneValid = true;
            else
                _PhoneValid = false;

            EnableDisableNewCustomer();
        }

        private void PhoneBox_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            HandleKeyPressNeedNumeric(e, _PhoneValid);
        }
        private void PhoneBox_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            HandleKeyDown(e);
        }
        private void ZIPBox_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            HandleKeyPressNeedNumeric(e, _ZIPValid);
        }
        private void ZIPBox_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            HandleKeyDown(e);
        }
        private void SSNBox_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            HandleKeyPressNeedNumeric(e, _SSNValid);
        }
        private void SSNBox_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            HandleKeyDown(e);
        }
        private void StateBox_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            HandleKeyPressNeedAlphabetic(e, _StateValid);
        }
        private void StateBox_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            HandleKeyDown(e);
        }
        private void HandleKeyDown(System.Windows.Forms.KeyEventArgs e)
        {
            // Initialize the flag to false.
            _nonNumberEntered = false;

            // Determine whether the keystroke is a number from the top of the keyboard.
            if (e.KeyCode < Keys.D0 || e.KeyCode > Keys.D9)
            {
                // Determine whether the keystroke is a number from the keypad.
                if (e.KeyCode < Keys.NumPad0 || e.KeyCode > Keys.NumPad9)
                {
                    // Determine whether the keystroke is a backspace or Delete.
                    if ( (e.KeyCode != Keys.Back) &&  (e.KeyCode != Keys.Delete) )
                    {
                        // A non-numerical keystroke was pressed.
                        // Set the flag to true and evaluate in KeyPress event.
                        _nonNumberEntered = true;
                    }
                }
            }
        }
        private void HandleKeyPressNeedNumeric(System.Windows.Forms.KeyPressEventArgs e, bool noMoreInput)
        {
            // Check for the flag being set in the KeyDown event.
            if ( (_nonNumberEntered == true) || noMoreInput )
            {
                // Stop the character from being entered into the control since it is non-numerical.
                e.Handled = true;
            }
        }
        private void HandleKeyPressNeedAlphabetic(System.Windows.Forms.KeyPressEventArgs e, bool noMoreInput)
        {
            // Check for the flag being set in the KeyDown event.
            if ( (_nonNumberEntered == false) || noMoreInput )
            {
                // Stop the character from being entered into the control since it is numerical.
                e.Handled = true;
            }
        }

        private void NewCustomerButton_Click(object sender, EventArgs e)
        {
            try
            {
                // pass off all the values to the handler
                CustomerDetailsToHandler();

                // create the customer
                _accountHandler.CreateNewCustomer();

                // get the pin
                string PIN = _accountHandler.PIN;

                // tell every one
                string line = "Customer " + _accountName + " added with secret PIN = " + PIN;
                AccountMessagesListBox.Items.Add(line);

                // get the right state of the buttons
                this.UpdateCustomerButton.Enabled = true;
                this.NewCustomerButton.Enabled = true;
                EnableNewAccounts();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void CustomerDetailsToHandler()
        {
            _accountHandler.SSN = this.SSNBox.Text.Trim();
            _accountHandler.Street = this.StreetBox.Text.Trim();
            _accountHandler.City = this.CityBox.Text.Trim();
            _accountHandler.State = this.StateBox.Text.Trim();
            _accountHandler.ZIP = this.ZIPBox.Text.Trim();
            _accountHandler.Phone = this.PhoneBox.Text.Trim();
        }

        private void CustomerDetailsFromHandler()
        {
            this.SSNBox.Text = _accountHandler.SSN;
            _SSNValid = true;

            this.StreetBox.Text = _accountHandler.Street;
            _StreetValid = true;

            this.CityBox.Text = _accountHandler.City;
            _CityValid = true;

            this.StateBox.Text = _accountHandler.State;
            _StateValid = true;

            this.ZIPBox.Text = _accountHandler.ZIP;
            _ZIPValid = true;

            this.PhoneBox.Text = _accountHandler.Phone;
            _PhoneValid = true;
        }

        private void UpdateCustomerButton_Click(object sender, EventArgs e)
        {
            try
            {
                // move the data to the handler
                CustomerDetailsToHandler();

                _accountHandler.UpdateCustomer();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void StartWorkButton_Click(object sender, EventArgs e)
        {
            // using 3270?
            _use3270 = this.COM3270RadioButton.Checked;

            // set the original state
            bool connectedOK = SetOpeningState();
            // if we could not connect stay at the config page
            if (!connectedOK)
                EnableConfiguration();
        }

        private void TIRadioButton_CheckedChanged(object sender, EventArgs e)
        {
            EnableDisable3270ParametersAndStartWork();
        }

        private void COM3270RadioButton_CheckedChanged(object sender, EventArgs e)
        {
            EnableDisable3270ParametersAndStartWork();
        }

        private void InputLUNameBox_TextChanged(object sender, EventArgs e)
        {
            EnableDisableStartWork();
        }

        private void InputLUNameBox_Leave(object sender, EventArgs e)
        {
            InputLUNameBox.Text = InputLUNameBox.Text.ToUpper();
        }

        private void InputCICSNameBox_TextChanged(object sender, EventArgs e)
        {
            EnableDisableStartWork();
        }

        private void InputCICSNameBox_Leave(object sender, EventArgs e)
        {
            InputCICSNameBox.Text = InputCICSNameBox.Text.ToUpper();
        }

        private void ReconfigureButton_Click(object sender, EventArgs e)
        {
            // disconnect the session if we are using 3270
            if (m_Handler != null)
                m_Handler.Disconnect();
            m_Handler = null;

            // return to the configuration page
            DisableEverything();
            EnableConfigurationTab();
        }

        private void ConfigurationTabPage_Click(object sender, EventArgs e)
        {

        }
    }
}
