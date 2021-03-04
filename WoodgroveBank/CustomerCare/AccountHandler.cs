using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.HostIntegration.SNA.Session;
using Microsoft.HostIntegration.TI;
using System.Collections;
using WoodgroveBank;
using System.Windows.Forms;
using System.Drawing;

namespace CSClient
{
    public enum AccountType
    {
        Checking = 1,
        Savings = 2
    }

    interface IAccountHander
    {
        void ValidateCustomer(string customerName);
        decimal GetAccountBalance(string accountNumber);
        string[] GetStatements();
        void CreateNewAccount(AccountType accountType);
        void RetrieveCustomerInfo();
        void UpdateCustomer();
        void CreateNewCustomer();
        void FinishWithCustomer();
    }

    class AccountHandler : IAccountHander
    {
        public const string META_DATA_ERROR = "HISMAGB0007";

        protected string _name = "";
        protected string _ssn = "";
        protected string _street = "";
        protected string _city = "";
        protected string _state = "";
        protected string _zip = "";
        protected string _phone = "";
        protected string _pin = "";

        protected bool _isExistingCustomer = false;

        protected string[] _accountNumbers = null;

        public string[] AccountNumbers { get { return _accountNumbers; } }
        public bool IsExistingCustomer { get { return _isExistingCustomer; } }

        public string SSN { get { return _ssn; } set { _ssn = value; } }
        public string Street { get { return _street; } set { _street = value; } }
        public string City { get { return _city; } set { _city = value; } }
        public string State { get { return _state; } set { _state = value; } }
        public string ZIP { get { return _zip; } set { _zip = value; } }
        public string Phone { get { return _phone; } set { _phone = value; } }
        public string PIN { get { return _pin; } }


        public virtual void ValidateCustomer(string customerName) { throw new NotImplementedException(); }
        public virtual decimal GetAccountBalance(string accountNumber) { throw new NotImplementedException(); }
        public virtual string[] GetStatements() { throw new NotImplementedException(); }
        public virtual void CreateNewAccount(AccountType accountType) { throw new NotImplementedException(); }
        public virtual void RetrieveCustomerInfo() { throw new NotImplementedException(); }
        public virtual void UpdateCustomer() { throw new NotImplementedException(); }
        public virtual void CreateNewCustomer() { throw new NotImplementedException(); }
        public virtual void FinishWithCustomer() { throw new NotImplementedException(); }
    }

    class AccountHandler3270 : AccountHandler
    {
        private const int MaximumNameLength = 30;
        private const int MaximumStreetLength = 20;
        private const int MaximumCityLength = 15;

        private SessionDisplay _Handler = null;

        // tracing area
        private TextBox m_TextBox = null;
        private System.Drawing.Font m_FixedFont;

        public AccountHandler3270(SessionDisplay handler)
        {
            if (handler == null)
                throw new ArgumentNullException("handler");

            _Handler = handler;

            // if we should trace, we need a fixed width font
            FontFamily fontFamily = new FontFamily("Courier New");
            m_FixedFont = new Font(fontFamily, 10, FontStyle.Regular, GraphicsUnit.Pixel);
        }

        public TextBox TraceBox
        {
            get { return m_TextBox; } 
            set 
            { 
                m_TextBox = value;
                m_TextBox.Font = m_FixedFont;
            }
        }

        override public void ValidateCustomer(string customerName)
        {
            if (string.IsNullOrEmpty(customerName))
                throw new ArgumentNullException("customerName");

            // save the name come what may
            _name = customerName;
       
            // call up the WBGA transaction
            _Handler.SendKey("WBGA@E");
            TraceScreen();

            // wait for the F9=Add Acct
            _Handler.WaitForContent("F9=Add Acct", 5000);
            TraceScreen();

            // The cursor is at the right place
            _Handler.SendKey(customerName + "@E");
            TraceScreen();

            // wait for the "paging commands" or name is invalid
            ScreenPartialFieldCollection fields = new ScreenPartialFieldCollection(2);
            fields.Add(new ScreenPartialField("Customer name not found", 21, 2));
            fields.Add(new ScreenPartialField("Press <Enter> and follow with paging commands", 1, 2));

            int indexOfField = _Handler.WaitForContent(fields, 5000);
            TraceScreen();

            // if we can't find the customer
            if (indexOfField == 0)
            {
                _isExistingCustomer = false;

                // go to the blank screen
                ClearScreenAndWait();
            }
            else
            {
                _isExistingCustomer = true;

                // hit enter
                _Handler.SendKey("@E");
                TraceScreen();

                // wait for "End of Report"
                _Handler.WaitForContent("End of Report", 5000);
                TraceScreen();

                // get all the accounts available
                ScreenFieldCollection sfcAccountNumbers = _Handler.GetFieldsByColumn(2, 4);

                _accountNumbers = new string[sfcAccountNumbers.Length];
                for (int index = 0; index < sfcAccountNumbers.Length; index++)
                {
                    _accountNumbers[index] = (string)sfcAccountNumbers[index].Data;
                }

                // go to the blank screen
                ClearScreenAndWait();

                // get the customers address data
                RetrieveCustomerInfo();
            }
        }

        // Routine to send the Clear Screen command and then wait until the Session Calms down
        private void ClearScreenAndWait()
        {
            _Handler.SendKey("@C");

            _Handler.WaitForSession(SessionDisplayWaitType.NotBusy, 20000);
            TraceScreen();
        }

        override public decimal GetAccountBalance(string accountNumber)
        {
            if (!_isExistingCustomer)
                throw new Exception("Account Balance may only be obtained for an existing customer");

            if (string.IsNullOrEmpty(accountNumber))
                throw new ArgumentNullException("accountNumber");

            // call up the WBGB transaction
            _Handler.SendKey("WBGB@E");
            TraceScreen();

            // wait for the F9=Add Acct
            _Handler.WaitForContent("F9=Add Acct", 5000);
            TraceScreen();

            // The cursor is at the right place
            _Handler.CurrentField.Data = _name;
            // now, next input field
            _Handler.MoveNextField(new ScreenFieldAttributeData(ScreenFieldAttribute.Normal)).Data = accountNumber;
            _Handler.SendKey("@E");
            TraceScreen();

            // wait for the ". sign" or name is invalid
            ScreenPartialFieldCollection fields = new ScreenPartialFieldCollection(3);
            fields.Add (new ScreenPartialField("Customer name not found", 21, 2));
            fields.Add (new ScreenPartialField("Name / account could not be found", 21, 2));
            fields.Add (new ScreenPartialField(".", 5, 31));

            int indexOfField = _Handler.WaitForContent(fields, 5000);
            TraceScreen();

            if (indexOfField == 0)
                throw new ArgumentException("Customer Name incorrect", _name);
            if (indexOfField == 1)
                throw new ArgumentException("Account Name incorrect", accountNumber);

            // get the amount field, by using a partial field
            string amountString = _Handler.GetField(5, 20)[2].Data;

            // go to the blank screen
            ClearScreenAndWait();

            return decimal.Parse (amountString);
        }

        override public string[] GetStatements()
        {
            if (!_isExistingCustomer)
                throw new Exception("Statements may only be obtained for an existing customer");

            // call up the WBGB transaction
            _Handler.SendKey("WBGD@E");
            TraceScreen();

            // wait for the F9=Add Acct
            _Handler.WaitForContent("F9=Add Acct", 5000);
            TraceScreen();

            // The cursor is at the right place
            _Handler.SendKey(_name + "@E");
            TraceScreen();

             // wait for the "paging commands" or name is invalid
            ScreenPartialFieldCollection fields = new ScreenPartialFieldCollection(2);
            fields.Add(new ScreenPartialField("Customer name not found", 21, 2));
            fields.Add(new ScreenPartialField("Press <Enter> and follow with paging commands", 1, 2));

            int indexOfField = _Handler.WaitForContent(fields, 5000);
            TraceScreen();

            if (indexOfField == 0)
                throw new ArgumentException("Customer Name incorrect", _name);

            // hit enter
            _Handler.SendKey("@E");
            TraceScreen();

            // statement lines
            ArrayList alLines = new ArrayList();

            // look for the end of paging or more
            fields.Clear();
            fields.Add(new ScreenPartialField("End of Report", 24, 2));
            fields.Add(new ScreenPartialField("Press Clear and type P/N to see page N", 24, 2));

            // for each page
            bool morePages = true;
            int pageNumber = 1;
            while (morePages)
            {
                // do we have more statements
                indexOfField = _Handler.WaitForContent(fields, 5000);
                TraceScreen();

                // get hold of all of the statement lines
                // the last Amount spreads over the rest of the screen, so the column
                // does no longer start at 2..thus ending the get fields
                ScreenFieldCollection sfcNumbers = _Handler.GetFieldsByColumn(2, 4);
                foreach (ScreenField numberField in sfcNumbers)
                {
                    // get the Account Number
                    string line = numberField.Data;
                    // reference the transaction type field
                    ScreenField valueField = numberField + 3;
                    // add the rest of the info
                    line += valueField.Data + (++valueField).Data;
                    // just in case the last field is humogously long, use the partial field
                    line += (++valueField)[1,13].Data;

                    alLines.Add(line);
                }

                // more?
                if (indexOfField == 1)
                {
                    // go to the blank screen
                    ClearScreenAndWait();

                    // next page
                    pageNumber++;

                    _Handler.SendKey ("P/" + pageNumber.ToString () + "@E");
                }
                else
                    morePages = false;
            }
            // go to the blank screen
            ClearScreenAndWait();

            string [] returnLines = new string[alLines.Count];
            for (int index = 0; index < alLines.Count; index++)
                returnLines[index] = (string)alLines[index];

            return returnLines;
        }

        override public void CreateNewAccount(AccountType accountType)
        {
            if (!_isExistingCustomer)
                throw new Exception("New Accounts may only be created for an existing customer");

            // call up the WBGB transaction
            _Handler.SendKey("WBAA@E");
            TraceScreen();

            // wait for the F8=Add Cust
            _Handler.WaitForContent("F8=Add Cust", 5000);
            TraceScreen();

            // The cursor is at the right place
            _Handler.CurrentField.Data = _name;
            // now, next input field
            _Handler.MoveNextField(new ScreenFieldAttributeData(ScreenFieldAttribute.Normal)).Data = (accountType == AccountType.Checking ? "C" : "S");
            _Handler.SendKey("@E");
            TraceScreen();

            // wait for the Initial Balance
            ScreenPartialFieldCollection fields = new ScreenPartialFieldCollection(2);
            fields.Add( new ScreenPartialField("Initial Balance", (short)(accountType == AccountType.Savings ? 9 : 10), 2));
            fields.Add( new ScreenPartialField( "Account add failed", 21, 2));

            int indexOfField = _Handler.WaitForContent(fields, 5000);
            TraceScreen();

            if (indexOfField == 1)
                throw new ArgumentException("Customer Name incorrect", _name);

            // pick up the new Number
            string newNumber = _Handler.GetField(5,11).Data;

            // if this is savings
            if (accountType == AccountType.Savings)
            {
                // Interest Rate
                _Handler.SendKey("2.5@T");

                // Service Charge
                _Handler.SendKey("1.0@T");

                // Initial Balance
                _Handler.SendKey("0.00@E");
                TraceScreen();

                fields.Clear();
                fields.Add(new ScreenPartialField("Account successfully added", 21, 2));
                fields.Add(new ScreenPartialField("Account add failed", 21, 2));

                indexOfField = _Handler.WaitForContent(fields, 5000);
                TraceScreen();

                if (indexOfField == 1)
                    throw new Exception("Could not add Account");
            }
            else
            {
                // Overdraft Charge
                _Handler.SendKey("1@T");

                // Overdraft Limit
                _Handler.SendKey("1000@T");

                // no Linked Savings Account, Initial Balance
                _Handler.SendKey("@T0.00@E");

                fields.Clear();
                fields.Add(new ScreenPartialField("Account successfully added", 21, 2));
                fields.Add(new ScreenPartialField("Account add failed", 21, 2));

                indexOfField = _Handler.WaitForContent(fields, 5000);

                if (indexOfField == 1)
                    throw new Exception("Could not add Account");
            }

            // add the new Number to the list of Accounts
            if (_accountNumbers == null)
                _accountNumbers = new string[1];
            else
                Array.Resize(ref _accountNumbers, _accountNumbers.Length + 1);
            _accountNumbers[_accountNumbers.Length - 1] = newNumber;

            // go to the blank screen
            ClearScreenAndWait();
        }

        override public void RetrieveCustomerInfo()
        {
            if (!_isExistingCustomer)
                throw new Exception("Retrieve Customer Info may only be called for an existing customer");

            // call up the WBCL transaction
            _Handler.SendKey("WBCL@E");
            TraceScreen();

            // wait for the F9=Add Acct
            _Handler.WaitForContent("F9=Add Acct", 5000);
            TraceScreen();

            // The cursor is at the right place
            _Handler.SendKey(_name + "@E");
            TraceScreen();

            // wait for the Customer Name
            _Handler.WaitForContent(_name, 5000);
            TraceScreen();

            // tab to the first entry
            _Handler.SendKey("@T");

            // select and hit enter
            _Handler.SendKey("S@E");
            TraceScreen();

            // wait for the Confirm
            _Handler.WaitForContent("Confirm", 5000);
            TraceScreen();

            // get all of the fields
            SSN = _Handler.GetField(4,11).Data.Trim ();
            Street = _Handler.GetField(6, 11).Data;
            City = _Handler.GetField(7, 11).Data;
            State = _Handler.GetField(8, 11).Data;
            ZIP = _Handler.GetField(9, 11).Data;
            Phone = _Handler.GetField(10, 11).Data;

            // go to the blank screen
            ClearScreenAndWait();
        }
        override public void UpdateCustomer()
        {
            if (!_isExistingCustomer)
                throw new Exception("Update Customer may only be called for an existing customer");

            // call up the WBCL transaction
            _Handler.SendKey("WBCL@E");

            // wait for the F9=Add Acct
            _Handler.WaitForContent("F9=Add Acct", 5000);

            // The cursor is at the right place
            _Handler.SendKey(_name + "@E");
            TraceScreen();

            // wait for the Customer Name
            _Handler.WaitForContent(_name, 5000);
            TraceScreen();

            // tab to the first entry
            _Handler.SendKey("@T");

            // select and hit enter
            _Handler.SendKey("S@E");
            TraceScreen();

            // wait for the Confirm
            _Handler.WaitForContent("Confirm", 5000);
            TraceScreen();

            // Cursor is at the right place Street, remove contents and input
            // if the Street was exactly long enough, no tab needed
            _Handler.SendKey("@F" + _street + ((_street.Length != MaximumStreetLength) ? "@T" : ""));
            //City
            _Handler.SendKey("@F" + _city + ((_city.Length != MaximumCityLength) ? "@T" : ""));
            // State
            _Handler.SendKey("@F" + _state);    // no tab needed
            // ZIP
            _Handler.SendKey("@F" + _zip);    // no tab needed
            // Phone, this comes in as 10 digits, the field is however 13 digits long
            _Handler.SendKey("@F" + _phone + "@E");
            TraceScreen();

            // We are not changing the PIN

            // Customer Successfully Added
            _Handler.WaitForContent("Customer successfully updated", 5000);
            TraceScreen();

            // go to the blank screen
            ClearScreenAndWait();
        }
        override public void CreateNewCustomer()
        {
            if (_isExistingCustomer)
                throw new Exception("Create New Customer may only be called for a new customer");

            // call up the WBGB transaction
            _Handler.SendKey("WBAC@E");
            TraceScreen();

            // wait for the F9=Add Acct
            _Handler.WaitForContent("F9=Add Acct", 5000);
            TraceScreen();

            // The cursor is at the right place
            _Handler.SendKey(_name + ((_name.Length != MaximumNameLength) ? "@T" : ""));

            // All of the values set by the client, first SSN
            _Handler.SendKey(_ssn);    // no tab needed
            // Street
            _Handler.SendKey(_street + ((_street.Length != MaximumStreetLength) ? "@T" : ""));
            //City
            _Handler.SendKey(_city + ((_city.Length != MaximumCityLength) ? "@T" : ""));
            // State
            _Handler.SendKey(_state);    // no tab needed
            // ZIP
            _Handler.SendKey(_zip);    // no tab needed
            // Phone, this comes in as 10 digits, the field is however 13 digits long
            _Handler.SendKey(_phone + "@T");

            // create a random 4 digit PIN
            Random r = new Random();
            string randomPIN = r.Next(1000, 11000).ToString();
            _Handler.SendKey(randomPIN + randomPIN + "@E");
            TraceScreen();

            // Customer Successfully Added
            // wait for the Initial Balance
            ScreenPartialFieldCollection fields = new ScreenPartialFieldCollection(3);
            fields.Add(new ScreenPartialField("Customer name already defined", 21, 2));
            fields.Add(new ScreenPartialField("Duplicate SSN found", 21, 2));
            fields.Add(new ScreenPartialField("Customer successfully added", 21, 2));

            int indexOfField = _Handler.WaitForContent(fields, 5000);
            TraceScreen();

            if (indexOfField == 0)
                throw new Exception("Customer Name incorrect");
            if (indexOfField == 1)
                throw new ArgumentException("Duplicate SSN found", _ssn);

            // set the PIN
            _pin = randomPIN;

            // go to the blank screen
            ClearScreenAndWait();

            // say this is now an existing customer
            _isExistingCustomer = true;
        }

        override public void FinishWithCustomer()
        {
            // get back to the clear screen case
            ClearScreenAndWait();

            _Handler = null;
        }

        // Get the Unicode version of the Screen
        public String CurrentScreen()
        {
            if (_Handler == null)
                throw new Exception("C3270_E_NOT_CONNECTED");

            String screen = null;

            ScreenData screenData = _Handler.GetScreenData(1, 1, -1);

            // get rid of non-display fields
			ProcessNonDisplayFields(screenData.Data, screenData.SpecialAttributes);

			// HostConverter allows for multiple CodePages per process, use instead of
			// Deprecated HostStringConverter
			HostConverter hostConverter = new HostConverter();

			// Convert the EBCDIC to Unicode
			screen = hostConverter.ConvertEbcdicToUnicode(screenData.Data);

            return screen;
        }

        // This method checks the extended attribute buffer, for non-display fields.
        // It will change the screen character to a space if, the extended attribute
        // buffer states that it is a non-display field.
        private void ProcessNonDisplayFields(Byte[] screenData, short[] eabuf)
        {
            const ushort EA_FIELD_BIT = 16;
            const ushort EA_DISPLAY_HIGH_BIT = 8;
            const ushort EA_DISPLAY_LOW_BIT = 4;
            const Byte EBCDIC_SPACE = 0x40;

            short screenRows = _Handler.Rows;
            short screenColumns = _Handler.Columns;

            for (int i = 0; i < eabuf.Length; i++)
            {
                ushort ea = (ushort)eabuf[i];
                // We first check to see if this is a field bit
                if ((ea & EA_FIELD_BIT) == EA_FIELD_BIT)
                {
                    Byte ch = screenData[i];
                    // Check to see if this character is a non-display
                    if (((ch & EA_DISPLAY_LOW_BIT) == EA_DISPLAY_LOW_BIT) && ((ch & EA_DISPLAY_HIGH_BIT) == EA_DISPLAY_HIGH_BIT))
                    {
                        ushort pos = (ushort)i;
                        short row = (short)(pos / screenColumns + 1);
                        short column = (short)(pos % screenColumns + 1);
                        
                        // Get the field length
                        int length = _Handler.GetField(row, column).Length;

                        // Change the field members to spaces
                        for (int j = 0; j < length; j++)
                        {
                            screenData[pos++] = EBCDIC_SPACE;
                        }
                    }
                }
            }
        }

        // print out the 3270 screen to a provided text box
        private void TraceScreen()
        {
            if (m_TextBox == null)
                return;

            // if we are not connected, no info
            if (_Handler == null)
            {
                m_TextBox.ResetText();
                return;
            }

            string screen = CurrentScreen();
            short rows = _Handler.Rows;
            short columns = _Handler.Columns;

            m_TextBox.ResetText();
            for (int i = 0; i < rows; i++)
            {
                m_TextBox.Text += (i != 0 ? Environment.NewLine : "") + screen.Substring(columns * i, columns);
            }

            // add a divider
            m_TextBox.Text += Environment.NewLine + new string('-', (int)columns);

            m_TextBox.Refresh();
        }
    }
    class AccountHandlerTI: AccountHandler
    {
        // Define the TI Handler for accessing the CICS 
        // Woodgrove Bank applicaiton using the 
        // CICS TCP/IP Enhanced Listener
        private CustomerCareELMLink _Handler = null;

        // Define the TI Handler for accessing the AS/400 
        // Woodgrove Bank applicaiton using 
        // Distributed Program Call
        //private CustomerCareDPC _Handler = null;

        private ClientContext _clientContextObj = null;
        
        public AccountHandlerTI()
        {
            // Create an instance of the TI object for 
            // accessing the CICS Woodgrove Bank applicaiton 
            // using the CICS TCP/IP Enhanced Listener
            _Handler = new CustomerCareELMLink();

            // Create an instance of the TI object for 
            // accessing the AS/400 Woodgrove Bank applicaiton 
            // using Distributed Program Call
            //_Handler = new CustomerCareDPC();

            // Create an instance of a TI Client Context handler
            _clientContextObj = new ClientContext();
        }

        override public void ValidateCustomer(string customerName)
        {
            if (string.IsNullOrEmpty(customerName))
                throw new ArgumentNullException("customerName");

            // save the name come what may
            _name = customerName;

            // send the name, PIN, 20
            bool moreAccounts = true;
            short accountCount = 0;
            ACCT_INFO[] accountInfoArray;

            // set up a persistent connection
            _clientContextObj.ConnectionUsage = ConnectionTypes.PersistentOpen;

            // set up a security override connection
            _clientContextObj.User = "MYUSERID";
            _clientContextObj.Password = "MYPSWD";

            // set up an empty array list
            ArrayList alNames = new ArrayList();

            try
            {
                while (moreAccounts)
                {
                    accountInfoArray = new ACCT_INFO[0];

                    moreAccounts = _Handler.GetAccounts(_name, 20, ref accountCount, ref accountInfoArray, ref _clientContextObj);

                    foreach (ACCT_INFO ai in accountInfoArray)
                        alNames.Add(ai.ACCT_NUMBER);
                }
                _Handler.ClosePersistentConnection(ref _clientContextObj);
                _isExistingCustomer = true;
            }
            catch (CustomTIException Ex)
            {
                bool isPersistent = false;
                bool connectionIsViable = false;
                _Handler.UpdateContextInfo(ref _clientContextObj);
                isPersistent = _clientContextObj.IsPersistent;
                connectionIsViable = _clientContextObj.IsConnectionViable;

                if (isPersistent && connectionIsViable)
                {
                    // close the persistent connection
                    _Handler.ClosePersistentConnection(ref _clientContextObj);
                }

                //parse out the Error code
                int errorCode = Ex.UserErrorCode;
                string errorText = Ex.Message;
                string msgID = Ex.TIExceptionMsgId;

                // say we can't handle this error
                bool errorHandlable = false;

                // if this is a Meta Data Error Block error, we got to the host, and then
                // it failed us, hopefully with customer not found
                if (msgID == META_DATA_ERROR)
                {
                    if (errorText.Contains("Customer name not found"))
                        errorHandlable = true;
                }

                // if its not handlable, leave
                if (!errorHandlable)
                    throw;

                // ok, at this point we have a non-existing customer
                _isExistingCustomer = false;

            }
            catch (Exception)
            {
                bool isPersistent = false;
                bool connectionIsViable = false;
                _Handler.UpdateContextInfo(ref _clientContextObj);
                isPersistent = _clientContextObj.IsPersistent;
                connectionIsViable = _clientContextObj.IsConnectionViable;

                if (isPersistent && connectionIsViable)
                {
                    // close the persistent connection
                    _Handler.ClosePersistentConnection(ref _clientContextObj);
                }

                // This is not a error that the App can handle.
                throw;
            }

            if (_isExistingCustomer)
            {
                // get the accounts available
                _accountNumbers = new string[alNames.Count];

                for (int index = 0; index < alNames.Count; index++)
                    _accountNumbers[index] = (string)alNames[index];

                // get the customers address data
                RetrieveCustomerInfo();
            }
        }

        override public decimal GetAccountBalance(string accountNumber)
        {
            if (!_isExistingCustomer)
                throw new Exception("Account Balance may only be obtained for an existing customer");

            if (string.IsNullOrEmpty(accountNumber))
                throw new ArgumentNullException("accountNumber");

            // send the name, and account number, note that was we should only be
            // providing correct names and numbers, we are not going to catch any exceptions!
            //_clientContextObj.DeleteContext("CONNTYPE", ref _contextArray);
            _clientContextObj.ConnectionUsage = ConnectionTypes.NonPersistent;
            return _Handler.GetBalance(_name, accountNumber, ref _clientContextObj);
        }

        override public string[] GetStatements()
        {
            if (!_isExistingCustomer)
                throw new Exception("Statements may only be obtained for an existing customer");

            // send the name, 20
            bool moreTransactions = true;
            short transactionCount = 0;
            TransactionDetails [] transactionArray;

            // set up a persistent connection
            _clientContextObj.ConnectionUsage = ConnectionTypes.PersistentOpen;

            // set up an empty array list
            ArrayList alTransactions = new ArrayList();

            try
            {
                while (moreTransactions)
                {
                    transactionArray = new TransactionDetails[0];

                    moreTransactions = _Handler.GetStatements(_name, 20, ref transactionCount, ref transactionArray, ref _clientContextObj);

                    foreach (TransactionDetails td in transactionArray)
                        alTransactions.Add(td);
                }
                _Handler.ClosePersistentConnection(ref _clientContextObj);
            }
            catch (Exception)
            {
                // close the persistent connection
                _Handler.ClosePersistentConnection(ref _clientContextObj);

                // as all of the input values should have been valid, we are not looking
                // for any particular errors
                throw;
            }

            string[] returnLines = new string[alTransactions.Count];
            for (int index = 0; index < returnLines.Length; index++)
            {
                TransactionDetails thisTD = (TransactionDetails) alTransactions[index];
                returnLines[index] = thisTD.TXN_ACCT_NUM + "   " + thisTD.TXN_TYPE + "  " + thisTD.TXN_DATE + "   " + thisTD.TXN_AMOUNT.ToString();
            }

            return returnLines;
        }

        override public void CreateNewAccount(AccountType accountType)
        {
            if (!_isExistingCustomer)
                throw new Exception("New Accounts may only be created for an existing customer");

            object oDescription;
            string accountTypeString;

            ACCT_TYPE_SAV ats = new ACCT_TYPE_SAV();
            ACCT_TYPE_CHK atc = new ACCT_TYPE_CHK();

            // if this is savings
            if (accountType == AccountType.Savings)
            {
                accountTypeString = "S";

                ats.ACCT_SAVE_BAL = 0.0M;
                ats.ACCT_SAVE_INT_RATE = 2.5M;
                ats.ACCT_SAVE_SVC_CHRG = 1.0M;

                oDescription = ats;
            }
            else
            {
                accountTypeString = "C";

                atc.ACCT_CHK_OD_CHG = 1;
                atc.ACCT_CHK_OD_LIMIT = 1000;
                atc.ACCT_CHK_BAL = 0;

                oDescription = atc;
            }
            //_clientContextObj.DeleteContext("CONNTYPE", ref _contextArray);
            _clientContextObj.ConnectionUsage = ConnectionTypes.NonPersistent;
            string newNumber = _Handler.CreateAccount(_name, accountTypeString, oDescription, ref _clientContextObj);

            // add the new Number to the list of Accounts
            if (_accountNumbers == null)
                _accountNumbers = new string[1];
            else
                Array.Resize(ref _accountNumbers, _accountNumbers.Length + 1);
            _accountNumbers[_accountNumbers.Length - 1] = newNumber;
        }

        override public void RetrieveCustomerInfo()
        {
            if (!_isExistingCustomer)
                throw new Exception("Retrieve Customer Info may only be called for an existing customer");

            // as we do not expect errors, no try/catch
            CustomerInformation customerInfo;
            //_clientContextObj.DeleteContext("CONNTYPE", ref _contextArray);
            _clientContextObj.ConnectionUsage = ConnectionTypes.NonPersistent;
            customerInfo = _Handler.GetCustomerInfo(_name, ref _clientContextObj);

            _pin = customerInfo.CUSTOMER_ACCESS_PIN ;
            SSN = customerInfo.CUSTOMER_SSN;
            Street = customerInfo.CUSTOMER_STREET;
            City = customerInfo.CUSTOMER_CITY;
            State = customerInfo.CUSTOMER_STATE;
            ZIP = customerInfo.CUSTOMER_ZIP.ToString();
            Phone = customerInfo.CUSTOMER_PHONE;
        }
        private CustomerInformation CreateCustomerInformation()
        {
            CustomerInformation customerInfo = new CustomerInformation();
            customerInfo.CUSTOMER_ACCESS_PIN = PIN;
            customerInfo.CUSTOMER_STREET = Street.Substring(0, Math.Min(20, Street.Length));
            customerInfo.CUSTOMER_CITY = City.Substring(0, Math.Min(10, City.Length));
            customerInfo.CUSTOMER_STATE = State.Substring(0, Math.Min(4, State.Length));
            customerInfo.CUSTOMER_ZIP = int.Parse(ZIP);
            customerInfo.CUSTOMER_PHONE = Phone.Substring(0, Math.Min(13, Phone.Length));
            customerInfo.CUSTOMER_SSN = SSN;

            return customerInfo;
        }
        override public void UpdateCustomer()
        {
            if (!_isExistingCustomer)
                throw new Exception("Update Customer may only be called for an existing customer");

            // again, we do not expect any errors, so no try catch
            CustomerInformation customerInfo = CreateCustomerInformation();
            //_clientContextObj.DeleteContext("CONNTYPE", ref _contextArray);
            _clientContextObj.ConnectionUsage = ConnectionTypes.NonPersistent;
            _Handler.SetCustomerInfo(_name, customerInfo, ref _clientContextObj);
        }
        override public void CreateNewCustomer()
        {
            if (_isExistingCustomer)
                throw new Exception("Create New Customer may only be called for a new customer");

            // create a random 4 digit PIN
            Random r = new Random();
            string randomPIN = r.Next(1000, 11000).ToString();

            // set the PIN, and create the customerInfo
            _pin = randomPIN;
            CustomerInformation customerInfo = CreateCustomerInformation();
            
            // creating a customer might fail due to Name or SSN, but we do not
            // need to do anything about it
            //_clientContextObj.DeleteContext("CONNTYPE", ref _contextArray);
            _clientContextObj.ConnectionUsage = ConnectionTypes.NonPersistent;
            _Handler.CreateCustomer(_name, customerInfo, ref _clientContextObj);

            // say this is now an existing customer
            _isExistingCustomer = true;
        }

        override public void FinishWithCustomer()
        {
            _Handler = null;
        }
    }
}
