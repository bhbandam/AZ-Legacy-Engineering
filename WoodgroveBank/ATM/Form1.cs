using System;
using System.Reflection;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Timers;
using System.IO;
using Microsoft.HostIntegration.SNA.Session;

namespace CSClient
{
    enum eStates
    {
        eUnconnected,
        eConnected,
        eMenu,
        eAccountBalance,
        eAmounts,
        eAccounts,
        eMoreAccounts,
        eTransferAmounts,
        eStatements,
        ePushingMoney,
        eReadingCard,
        ePushingCard
    }
    public partial class Form1 : Form
    {
        const int eNone = 0;
        const int eTop = 1;
        const int eUpper = 2;
        const int eLower = 4;
        const int eBottom = 8;
        const int eAll = 15;

        private SessionConnectionLU0 m_Connection = null;
        private AccountHandler _accountHandler = null;
        private static eStates eInternalState = eStates.eUnconnected;
        private static Form1 _thisForm;
        public delegate void PerformTimerDelegate();
        public PerformTimerDelegate _delegate;
        private string _pinString = "";
        private string _accountString = "";
        private decimal _balance;

        private string[] _accountNames;
        private string[] _accountNumbers;
        private int _transferIndex;

        private TextBox[] _allOutputLines;
        private int _startingStatementNumber = 0;
        private string[] _statements;
        private Button _lastPressed = null;

        Image _billComplete;
        Image _cardComplete;
        Image[] _cardBits;

        private string _statementHeader = "    Account    Movement Type    Date        Amount";
        private Font _FixedFont;

        System.Timers.Timer _aTimer;
        private int _moneyPushingState;
        private int _cardReadingState;

        private System.Drawing.Size _moneyPictureSize;
        private int _partMoney;
        private int _fullMoney;
        private int _topOfMoneyBox;

        private System.Drawing.Size _cardPictureSize;
        private int _partCard;
        private int _fullCard;
        private int _topOfCardBox;

        private bool _nonNumberEntered = false;

        public Form1()
        {
            InitializeComponent();
        }

        private void SetOpeningState()
        {
            // set the last button pressed on the main menu
            _lastPressed = null;

            DisableEverything();

            try
            {
                // connect to the host if not already done so
                if (m_Connection == null)
                {
                    // use a SessionLU0 to do the connection
                    SessionLU0 session = new SessionLU0();
                    string connectionString = "LogicalUnitName=" + this.InputLUNameBox.Text.Trim().ToUpperInvariant()
                                              + ";DestinationLogicalUnitName=" + this.InputCICSNameBox.Text.Trim().ToUpperInvariant();
                    session.Connect(connectionString, SessionLU0InitType.INITSELF);
                    // get the connection from the session
                    m_Connection = session.Connection;
                    // and disconnect this session
                    session.Disconnect();
                }
                if (_accountHandler != null)
                    _accountHandler.FinishWithAccount();

                // start up the animation of the card
                eInternalState = eStates.eReadingCard;
                _cardReadingState = 0;
                HandleReadingCard();
            }
            catch (Exception ex)
            {
                string messageToShow = ex.Message;
                if (ex.InnerException != null)
                    messageToShow += Environment.NewLine + ex.InnerException.Message;

                MessageBox.Show(messageToShow);
            }
        }

        #region Enable Disable Elements
        private void EnableConfiguration()
        {
            DisableEverything();

            this.InputCICSNameBox.Enabled = true;
            this.InputLUNameBox.Enabled = true;
            this.StartWorkButton.Enabled = true;

            EnableDisableStartWork();
        }

        private void DisableConfiguration()
        {
            this.InputCICSNameBox.Enabled = false;
            this.InputLUNameBox.Enabled = false;
            this.StartWorkButton.Enabled = false;
        }

        private void DisableEverything()
        {
            EnableButtons(eNone, eNone);

            DisableLogon();
        }
        private void DisableLogon()
        {
            DisableAccount();
            DisablePINs();
            DisableEnter();
            ClearAllTexts();
        }
        private void EnableEnter()
        {
            this.EnterButton.Enabled = true;
            this.EnterButton.Select();
        }
        private void DisableEnter()
        {
            this.EnterButton.Enabled = false;
        }
        private void EnableAccount()
        {
            // set the account string to empty
            _accountString = "";

            // enable the input box
            this.AccountInputBox.Enabled = true;
            this.AccountInputBox.Text = "";
            this.AccountInputBox.Focus();
        }
        private void DisableAccount()
        {
            this.AccountInputBox.Enabled = false;
        }
        private void EnablePINs()
        {
            ChangePINs(true);
            _pinString = "";

            // set the input focus to the Text Box for PIN Input
            PINBox.Visible = true;
            PINBox.BringToFront();
            PINBox.Text = _pinString;
            PINBox.Focus();
        }
        private void DisablePINs()
        {
            ChangePINs(false);
        }
        private void ChangePINs(bool enabled)
        {
            // enable/disable the PIN keys
            this.Key0.Enabled = enabled;
            this.Key1.Enabled = enabled;
            this.Key2.Enabled = enabled;
            this.Key3.Enabled = enabled;
            this.Key4.Enabled = enabled;
            this.Key5.Enabled = enabled;
            this.Key6.Enabled = enabled;
            this.Key7.Enabled = enabled;
            this.Key8.Enabled = enabled;
            this.Key9.Enabled = enabled;
        }

        private void EnableButtons(int eLeft, int eRight)
        {
            EnableLeftButtons(eLeft);
            EnableRightButtons(eRight);
        }

        private void EnableLeftButtons(int buttons)
        {
            if (buttons == eNone)
            {
                this.TopLeft.Enabled = false;
                this.UpperLeft.Enabled = false;
                this.LowerLeft.Enabled = false;
                this.BottomLeft.Enabled = false;
            }
            else
            {
                // enable disable each button
                if ((buttons & eTop) != 0)
                    this.TopLeft.Enabled = true;

                if ((buttons & eUpper) != 0)
                    this.UpperLeft.Enabled = true;

                if ((buttons & eLower) != 0)
                    this.LowerLeft.Enabled = true;

                if ((buttons & eBottom) != 0)
                    this.BottomLeft.Enabled = true;
            }
        }

        private void EnableRightButtons(int buttons)
        {
            if (buttons == eNone)
            {
                this.TopRight.Enabled = false;
                this.UpperRight.Enabled = false;
                this.LowerRight.Enabled = false;
                this.BottomRight.Enabled = false;
            }
            else
            {
                // enable disable each button
                if ((buttons & eTop) != 0)
                    this.TopRight.Enabled = true;

                if ((buttons & eUpper) != 0)
                    this.UpperRight.Enabled = true;

                if ((buttons & eLower) != 0)
                    this.LowerRight.Enabled = true;

                if ((buttons & eBottom) != 0)
                    this.BottomRight.Enabled = true;
            }
        }


        private void SetTextEnableButtonLeft(int eWhere, string text)
        {
            // enable the button
            EnableLeftButtons(eWhere);

            // set the text
            SetLeftText(eWhere, text);
        }

        private void SetTextEnableButtonRight(int eWhere, string text)
        {
            // enable the button
            EnableRightButtons(eWhere);

            // set the text
            SetRightText(eWhere, text);
        }

        public void ClearOutoutLines()
        {
            foreach (TextBox tb in _allOutputLines)
                tb.Text = "";
        }
        #endregion

        #region Set Text
        private void SetLeftText(int eWhere, string text)
        {
            // set Text in the appropriate box
            TextBox thisBox = this.TopLeftBox;

            if ((eWhere & eUpper) != 0)
                thisBox = this.UpperLeftBox;

            if ((eWhere & eLower) != 0)
                thisBox = this.LowerLeftBox;

            if ((eWhere & eBottom) != 0)
                thisBox = this.BottomLeftBox;

            thisBox.Text = text;
            if (text.Length != 0)
                thisBox.BringToFront();
        }

        private void ClearLeftTexts()
        {
            SetLeftText(eTop, "");
            SetLeftText(eUpper, "");
            SetLeftText(eLower, "");
            SetLeftText(eBottom, "");
        }

        private void SetRightText(int eWhere, string text)
        {
            // set Text in the appropriate box
            TextBox thisBox = this.TopRightBox;

            if ((eWhere & eUpper) != 0)
                thisBox = this.UpperRightBox;

            if ((eWhere & eLower) != 0)
                thisBox = this.LowerRightBox;

            if ((eWhere & eBottom) != 0)
                thisBox = this.BottomRightBox;

            thisBox.Text = text;
            if (text.Length != 0)
                thisBox.BringToFront();
        }

        private void ClearRightTexts()
        {
            SetRightText(eTop, "");
            SetRightText(eUpper, "");
            SetRightText(eLower, "");
            SetRightText(eBottom, "");
        }

        private void SetTopText(string text)
        {
            // set Text in the appropriate box
            TextBox thisBox = this.TopLine;

            thisBox.Text = text;
            if (text.Length != 0)
                thisBox.BringToFront();
        }

        private void ClearTopText()
        {
            SetTopText("");
        }

        private void SetFirstText(string text)
        {
            // set Text in the appropriate box
            TextBox thisBox = this.FirstLine;

            thisBox.Text = text;

            if (text.Length != 0)
                thisBox.BringToFront();
        }

        private void ClearFirstText()
        {
            SetFirstText("");
        }

        private void SetSecondText(string text)
        {
            // set Text in the appropriate box
            TextBox thisBox = this.SecondLine;

            thisBox.Text = text;

            // set centered
            thisBox.TextAlign = HorizontalAlignment.Center;

            if (text.Length != 0)
                thisBox.BringToFront();
        }

        private void SetSecondTextLeft(string text)
        {
            // set Text in the appropriate box
            TextBox thisBox = this.SecondLine;

            thisBox.Text = text;

            // set left aligned
            thisBox.TextAlign = HorizontalAlignment.Left;

            if (text.Length != 0)
                thisBox.BringToFront();
        }

        private void ClearSecondText()
        {
            SetSecondText("");
        }
        private void ClearAllTexts()
        {
            ClearLeftTexts();
            ClearRightTexts();
            ClearTopText();
            ClearFirstText();
            ClearSecondText();
            ClearOutoutLines();
        }
        #endregion
        #region Menu Items
        private void SetMainMenu()
        {
            // disable all the buttons
            EnableButtons(eNone, eNone);

            // Clear all the Texts
            ClearAllTexts();

            // add the texts and enable the buttons
            SetTextEnableButtonLeft(eTop, "Account Balance");
            SetTextEnableButtonLeft(eUpper, "Get Cash");
            // if there is only the logged in account, you cannot transfer money
            if (_accountHandler.AccountNumbers.Length != 0)
                SetTextEnableButtonLeft(eLower, "Transfer Money");

            // right now there are no more options, but this would be added if there was
            // SetTextEnableButtonLeft(eBottom, "More");

            SetTextEnableButtonRight(eTop, "Statements");
            SetTextEnableButtonRight(eBottom, "Finish");

            string userName = _accountHandler.UserName;
            userName = userName.Trim();
            SetTopText(userName);
            SetFirstText("Choose from the menu items");

            // choose get balance if not chosen
            if (_lastPressed == null)
                _lastPressed = this.TopLeft;

            _lastPressed.Select();

            // clear the picture box :-)
            this.pictureBox1.Image = null;

            eInternalState = eStates.eMenu;
        }

        private void SetAccountBalance()
        {
            // Clear all the Texts
            ClearAllTexts();

            // disable all the buttons
            EnableButtons(eNone, eNone);

            SetFirstText("The Account Balance for Account# " + AccountInputBox.Text + " is");
            SetSecondText("$" + _balance.ToString());

            // add the texts and enable the buttons
            SetTextEnableButtonRight(eBottom, "Return");

            SetTopText("Select Return to go back to the Main Menu");
            this.BottomRight.Select();

            eInternalState = eStates.eAccountBalance;
        }

        private void SetAmounts()
        {
            // disable all the buttons
            EnableButtons(eNone, eNone);

            // Clear all the Texts
            ClearAllTexts();

            SetTopText("Please Select an Amount or Cancel");

            // add the texts and enable the buttons
            SetTextEnableButtonLeft(eTop, "20");
            SetTextEnableButtonLeft(eUpper, "40");
            SetTextEnableButtonLeft(eLower, "60");
            SetTextEnableButtonLeft(eBottom, "80");

            SetTextEnableButtonRight(eTop, "100");
            SetTextEnableButtonRight(eUpper, "150");
            SetTextEnableButtonRight(eLower, "200");
            SetTextEnableButtonRight(eBottom, "Cancel");

            this.TopLeft.Select();

            eInternalState = eStates.eAmounts;
        }

        private void SetAccounts()
        {
            // disable every button and text box
            DisableEverything();

            // get the accounts
            _accountNames = this._accountHandler.AccountNames;
            _accountNumbers = this._accountHandler.AccountNumbers;

            // disable all the buttons
            EnableButtons(eNone, eNone);

            // Clear all the Texts
            ClearAllTexts();

            SetTopText("Please Select a destination Account or Cancel");

            // add the texts and enable the buttons
            SetTextEnableButtonLeft(eTop, _accountNames[0] + "(" + _accountNumbers [0] + ")");
            if (_accountNames.Length > 1)
                SetTextEnableButtonLeft(eUpper, _accountNames[1] + "(" + _accountNumbers[1] + ")");
            if (_accountNames.Length > 2)
                SetTextEnableButtonLeft(eLower, _accountNames[2] + "(" + _accountNumbers[2] + ")");

            if (_accountNames.Length > 6)
                SetTextEnableButtonLeft(eBottom, "More");

            if (_accountNames.Length > 3)
                SetTextEnableButtonRight(eTop, _accountNames[3] + "(" + _accountNumbers[3] + ")");
            if (_accountNames.Length > 4)
                SetTextEnableButtonRight(eUpper, _accountNames[4] + "(" + _accountNumbers[4] + ")");
            if (_accountNames.Length > 5)
                SetTextEnableButtonRight(eLower, _accountNames[5] + "(" + _accountNumbers[5] + ")");

            SetTextEnableButtonRight(eBottom, "Cancel");

            this.TopLeft.Select();

            eInternalState = eStates.eAccounts;
        }

        private void SetMoreAccounts()
        {
            // disable all the buttons
            EnableButtons(eNone, eNone);

            // Clear all the Texts
            ClearAllTexts();

            SetTopText("Please Select a destination Account or Cancel");

            // add the texts and enable the buttons
            SetTextEnableButtonLeft(eTop, _accountNames[6] + "(" + _accountNumbers[6] + ")");
            if (_accountNames.Length > 7)
                SetTextEnableButtonLeft(eUpper, _accountNames[7] + "(" + _accountNumbers[7] + ")");
            if (_accountNames.Length > 8)
                SetTextEnableButtonLeft(eLower, _accountNames[8] + "(" + _accountNumbers[8] + ")");

            if (_accountNames.Length > 9)
                SetTextEnableButtonRight(eTop, _accountNames[9] + "(" + _accountNumbers[9] + ")");
            if (_accountNames.Length > 10)
                SetTextEnableButtonRight(eUpper, _accountNames[10] + "(" + _accountNumbers[10] + ")");
            if (_accountNames.Length > 11)
                SetTextEnableButtonRight(eLower, _accountNames[11] + "(" + _accountNumbers[11] + ")");

            SetTextEnableButtonRight(eBottom, "Cancel");

            this.TopLeft.Select();

            eInternalState = eStates.eMoreAccounts;
        }
#endregion
        private string FormatStatement(string statement)
        {
            // the format of the string is:
            //
            // 10 characters account name/number
            // 1 Character Type of Movement
            //      B Initial Balance
            //      D      Debit      
            //      C      Credit     
            //      S  Service Charge 
            //      O Overdraft Charge
            // 10 characters Date (MM/DD/YYYY)
            // 13 characters amount
            string movementInital = "Initial Balance ";
            string movementDebit = "     Debit      ";
            string movementCredit = "     Credit     ";
            string movementServiceCharge = " Service Charge ";
            string movementOverdraftCharge = "Overdraft Charge";

            string outputString = "  " + statement.Substring(0, 10) + " ";
            switch (statement.Substring(10, 1))
            {
                case "B":
                    outputString += movementInital;
                    break;
                case "D":
                    outputString += movementDebit;
                    break;
                case "C":
                    outputString += movementCredit;
                    break;
                case "S":
                    outputString += movementServiceCharge;
                    break;
                case "O":
                    outputString += movementOverdraftCharge;
                    break;
            }
            outputString += " " + statement.Substring(11, 10) + " " + statement.Substring(21);

            return outputString;
        }

        private void SetStatements()
        {
            // disable all the buttons
            EnableButtons(eNone, eNone);

            // Clear all the Texts
            ClearAllTexts();

            SetTopText("Account Movements");
            string userName = _accountHandler.UserName;
            userName = userName.Trim();
            SetFirstText("For " + userName);
            SetSecondTextLeft(_statementHeader);

            // add the texts and enable the buttons
            if (_statements.Length == 5)
            {
                SetTextEnableButtonRight(eBottom, "Cancel");
                SetTextEnableButtonLeft(eBottom, "More");
            }
            else
                SetTextEnableButtonRight(eBottom, "Return");

            // fill out the elements of the output lines
            for (int i = 0; i < _statements.Length; i++)
            {
                _allOutputLines[i].BringToFront();
                _allOutputLines[i].Text = FormatStatement(_statements[i]);
            }

            if (_statements.Length == 5)
                this.BottomLeft.Select();
            else
                this.BottomRight.Select();

            eInternalState = eStates.eStatements;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // get the output lines
            _allOutputLines = new TextBox[5];

            _allOutputLines[0] = this.OutputLines1;
            _allOutputLines[1] = this.OutputLines2;
            _allOutputLines[2] = this.OutputLines3;
            _allOutputLines[3] = this.OutputLines4;
            _allOutputLines[4] = this.OutputLines5;

            // setup a fixed font
            FontFamily fontFamily = new FontFamily("Courier New");
            _FixedFont = new Font(fontFamily, 12, FontStyle.Bold, GraphicsUnit.Pixel);

            // set the output lines to this font
            this.OutputLines1.Font = _FixedFont;
            this.OutputLines2.Font = _FixedFont;
            this.OutputLines3.Font = _FixedFont;
            this.OutputLines4.Font = _FixedFont;
            this.OutputLines5.Font = _FixedFont;

            this.TopLine.Font = _FixedFont;
            this.FirstLine.Font = _FixedFont;
            this.SecondLine.Font = _FixedFont;

            // set up the timer stuff
            _aTimer = new System.Timers.Timer();

            // Hook up the Elapsed event for the timer.
            _aTimer.Elapsed += new ElapsedEventHandler(OnTimedEvent);

            // Set the Interval to 0.1 seconds (100 milliseconds).
            _aTimer.Interval = 100;
            _aTimer.Enabled = false;

            _thisForm = this;
            _delegate = new PerformTimerDelegate(PerformTimer);

            // load the images
            Stream _billStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("CSClient.dollarbill.jpg");
            _billComplete = Image.FromStream(_billStream);
            Stream _cardStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("CSClient.CreditCard.JPG");
            _cardComplete = Image.FromStream(_cardStream);

            // chop the card up into multiple bits, by removing stuff from the top
            int imageHeight = _cardComplete.Height;
            int imageWidth = _cardComplete.Width;
            int sizeOfPart = imageHeight / 15;
            int numberOfParts = imageHeight / sizeOfPart + 1;
            _cardBits = new Image[numberOfParts];

            int sizeOfBit = imageHeight;
            int index = 0;
            // load the full image
            Graphics gf = Graphics.FromImage(_cardComplete);
            while (sizeOfBit >= 0)
            {
                // create a cropping area
                Bitmap bitmapCropped = new Bitmap(imageWidth, sizeOfBit);
                Graphics gc = Graphics.FromImage(bitmapCropped);

                // draw a portion of the whole image on the new cropped graphic
                gc.DrawImage(_cardComplete, new Rectangle(0, 0, imageWidth, sizeOfBit),
                                            new Rectangle(0, sizeOfPart * index, imageWidth, sizeOfBit),
                                            GraphicsUnit.Pixel);

                // save the image
                _cardBits[index] = bitmapCropped;

                // next bit
                index++;
                sizeOfBit -= sizeOfPart;
            }

            // info about the money box
            _topOfMoneyBox = this.pictureBox1.Top;
            _moneyPictureSize = this.pictureBox1.Size;
            _fullMoney = _moneyPictureSize.Height;
            _partMoney = _fullMoney / 14;

            // info about the card box
            _topOfCardBox = this.pictureBox2.Top;
            _cardPictureSize = this.pictureBox2.Size;
            _fullCard = _cardPictureSize.Height;
            _partCard = _fullCard / 14;

            // enable only the Configuration stuff
            EnableConfiguration();
        }

        private void Form1_Closing(object sender, EventArgs e)
        {
            // stop the timers
            _aTimer.Enabled = false;
            _thisForm = null;

            if (m_Connection != null)
                m_Connection.Dispose();
            m_Connection = null;
        }

        #region PIN Button Handling
        private void PINButtonClicked(string text)
        {
            if (text.Length != 1)
                throw new ArgumentException("PINs are entered 1 character at a time", text);

            // add character to the end of the pinstring
            _pinString += text;

            // show it
            PINBox.Text = _pinString;
        }
        private void PINBox_TextChanged(object sender, EventArgs e)
        {
            _pinString = PINBox.Text;

            // if the string is now 4 characters long, disable pin and enable enter
            if (_pinString.Length == 4)
            {
                DisablePINs();
                EnableEnter();
            }
        }

        private void Key1_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key2_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key3_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key4_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key5_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key6_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key7_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key8_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key9_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }

        private void Key0_Click(object sender, EventArgs e)
        {
            PINButtonClicked(((Button)sender).Text);
        }
        #endregion
        private void EnterButton_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eConnected:
                        DisableEverything();
                        // check for Account Number filled in and PIN complete
                        _accountString = AccountInputBox.Text.Trim();
                        if (_accountString.Length == 0)
                            throw new Exception("This just ain't right - no Account");

                        if (_pinString.Length != 4)
                            throw new Exception("This just ain't right - PIN Incomplete");

                        // hide the PIN box
                        PINBox.Visible = false;
                        PINBox.SendToBack();

                        // create an account handler, with all the available info
                        _accountHandler = new AccountHandler(m_Connection);

                        // set the trace window
                        _accountHandler.TraceTextBox = this.ScreenText;

                        // try to logon the account
                        _accountHandler.ValidateAccount(_accountString, _pinString);

                        // get all of the accounts already
                        _accountHandler.RetrieveAccounts();

                        // say that we now have the main menu
                        SetMainMenu();

                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                // as this is a failure to log in, set up the original state
                SetOpeningState();
            }
        }

        private void TopLeft_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eMenu:
                        // set the last button pressed on the main menu
                        _lastPressed = this.TopLeft;

                        // this is the request for account balance
                        // change the screen to Please Wait, all stuff disabled
                        DisableEverything();
                        SetTopText("Please Wait : Retrieving Account Balance");

                        _balance = _accountHandler.GetBalance();

                        // say that we now have the Account Balance Info
                        SetAccountBalance();

                        break;
                    case eStates.eAmounts:
                        Withdraw(20);
                        break;
                    case eStates.eAccounts:
                        TransferAccount(0);
                        break;
                    case eStates.eMoreAccounts:
                        TransferAccount(6);
                        break;
                    case eStates.eTransferAmounts:
                        TransferAmount(20);
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void UpperLeft_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eMenu:
                        // set the last button pressed on the main menu
                        _lastPressed = this.UpperLeft;

                        // this is the request for Withdrawal
                        // fill out lots of amounts
                        SetAmounts();
                        break;
                    case eStates.eAmounts:
                        Withdraw(40);
                        break;
                    case eStates.eAccounts:
                        TransferAccount(1);
                        break;
                    case eStates.eMoreAccounts:
                        TransferAccount(7);
                        break;
                    case eStates.eTransferAmounts:
                        TransferAmount(40);
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void LowerLeft_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eMenu:
                        // set the last button pressed on the main menu
                        _lastPressed = this.LowerLeft;

                        // this is the request for a transfer of fund
                        // from this Account to another one
                        SetAccounts();
                        break;
                    case eStates.eAmounts:
                        Withdraw(60);
                        break;
                    case eStates.eAccounts:
                        TransferAccount(2);
                        break;
                    case eStates.eMoreAccounts:
                        TransferAccount(8);
                        break;
                    case eStates.eTransferAmounts:
                        TransferAmount(60);
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void BottomLeft_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eAmounts:
                        Withdraw(80);
                        break;
                    case eStates.eAccounts:
                        SetMoreAccounts();
                        break;
                    case eStates.eTransferAmounts:
                        TransferAmount(80);
                        break;
                    case eStates.eStatements:
                        DoStatements();
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void TopRight_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eMenu:
                        // set the last button pressed on the main menu
                        _lastPressed = this.TopRight;

                        // this is the request for Statements
                        _startingStatementNumber = 0;
                        DoStatements();
                        break;
                    case eStates.eAmounts:
                        Withdraw(100);
                        break;
                    case eStates.eAccounts:
                        TransferAccount(3);
                        break;
                    case eStates.eMoreAccounts:
                        TransferAccount(9);
                        break;
                    case eStates.eTransferAmounts:
                        TransferAmount(100);
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void UpperRight_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eAmounts:
                        Withdraw(150);
                        break;
                    case eStates.eAccounts:
                        TransferAccount(4);
                        break;
                    case eStates.eMoreAccounts:
                        TransferAccount(10);
                        break;
                    case eStates.eTransferAmounts:
                        TransferAmount(150);
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void LowerRight_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eAmounts:
                        Withdraw(200);
                        break;
                    case eStates.eAccounts:
                        TransferAccount(5);
                        break;
                    case eStates.eMoreAccounts:
                        TransferAccount(11);
                        break;
                    case eStates.eTransferAmounts:
                        TransferAmount(200);
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void BottomRight_Click(object sender, EventArgs e)
        {
            try
            {
                // what state are we in?
                switch (eInternalState)
                {
                    case eStates.eMenu:
                        // set the last button pressed on the main menu
                        _lastPressed = this.BottomRight;

                        // this is the request for finishing
                        DisableEverything();

                        SetTopText("Thank you for using the RobiTobi Bank");

                        _accountHandler.FinishWithAccount();

                        SetOpeningState();

                        break;
                    case eStates.eAccountBalance:
                    case eStates.eAmounts:
                    case eStates.eAccounts:
                    case eStates.eMoreAccounts:
                    case eStates.eTransferAmounts:
                    case eStates.eStatements:
                        // this is a request to return to the main menu
                        SetMainMenu();
                        break;
                    default:
                        throw new Exception("This just ain't right, Default = " + eInternalState.ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                SetMainMenu();
            }
        }

        private void AccountInputBox_TextChanged(object sender, EventArgs e)
        {
            _accountString = AccountInputBox.Text.Trim();
            // as soon as one letter is entered, get the card reading bit shut down
            if (_accountString.Length == 1)
            {
                eInternalState = eStates.eConnected;
                HandleReadingCard();
            }

            // have we got all 10 characters of the account
            if (_accountString.Length == 10)
            {
                // enable the PIN and disable the account
                EnablePINs();
                DisableAccount();

                SetFirstText("Enter your 4 Digit PIN");
            }
        }
        private void Withdraw(int value)
        {
            DisableEverything();
            SetTopText("Please Wait : Withdrawing $" + value.ToString());
            SetFirstText("From Account# " + AccountInputBox.Text);

            _balance = _accountHandler.Withdraw(value);

            // handle the pushing of the Dollar Bill
            eInternalState = eStates.ePushingMoney;
            _moneyPushingState = 0;
            HandleDollarBill();
        }

        private void TransferAccount(int accountIndex)
        {
            if (accountIndex > _accountNames.Length - 1)
                throw new ArgumentOutOfRangeException("accountIndex");

            _transferIndex = accountIndex;

            // set up the amounts
            SetAmounts();

            // and say we are in amounts transfer
            eInternalState = eStates.eTransferAmounts;
        }
        private void TransferAmount(int value)
        {
            DisableEverything();
            SetTopText("Please Wait : Transfering $" + value.ToString());
            SetFirstText("From Account# " + AccountInputBox.Text);
            SetSecondText("To Account# " + _accountNumbers[_transferIndex]);

            _balance = _accountHandler.Transfer(value, _accountNumbers[_transferIndex]);

            // say that we now have the Account Balance Info
            SetAccountBalance();
        }

        private void DoStatements()
        {
            DisableEverything();
            SetTopText("Please Wait : Retrieving Statements");
            string userName = _accountHandler.UserName;
            userName = userName.Trim();
            SetFirstText("For " + userName);

            _statements = _accountHandler.GetStatements(_startingStatementNumber, 5);
            _startingStatementNumber += 5;

            // say that we now have the Statements
            SetStatements();
        }

        private static void OnTimedEvent(object source, ElapsedEventArgs e)
        {
            if (_thisForm == null)
                return;

            try { _thisForm.Invoke(_thisForm._delegate); }
            catch (Exception) { }
        }

        public void PerformTimer()
        {
            // are we reading in a card
            if (eInternalState == eStates.eReadingCard)
                HandleReadingCard();

            // or are we pushing out money out
            if (eInternalState == eStates.ePushingMoney)
                HandleDollarBill();
        }

        private void HandleDollarBill()
        {
            // write the dollar bill to the picture box :-) a bit at a time

            // if the state of this is 0, block everything
            if (_moneyPushingState == 0)
            {
                DisableEverything();
                SetTopText("Please take your money");
                SetFirstText("");

                // put the picture in the picture box
                this.pictureBox1.Image = _billComplete;

                // enable the timer
                _aTimer.Enabled = true;
            }
            _moneyPushingState++;

            // move the picture box up 1/14
            this.pictureBox1.Top = _topOfMoneyBox + _fullMoney - _partMoney * _moneyPushingState;

            // increase its size by 1/14
            _moneyPictureSize.Height = _partMoney * _moneyPushingState;
            this.pictureBox1.Size = _moneyPictureSize;

            // if we have the money all the way out, finish up
            if (_moneyPictureSize.Height >= _fullMoney)
            {
                // Disable the timer
                _aTimer.Enabled = false;

                // if we have all of the money out, 
                // say that we now have the Account Balance Info
                SetAccountBalance();
            }
        }
        private void HandleReadingCard()
        {
            // if someone has entered stuff in the account, stop animation
            if (eInternalState != eStates.eReadingCard)
            {
                // stop the timer
                _aTimer.Enabled = false;

                // chop the size of the card picture area to 0 height
                _cardPictureSize.Height = 0;
                this.pictureBox2.Size = _cardPictureSize;

                return;
            }

            // write the credit card to the picture box :-) a bit at a time

            // if the state of this is 0, set up the timer
            if (_cardReadingState == 0)
            {
                // Enable the Account and Text "Welcome, Enter 10 digit Account"
                SetTopText("Welcome to WoodGrove Bank");
                SetFirstText("Enter your 10 Character Account Number");
                EnableAccount();

                // enable the timer
                _aTimer.Enabled = true;

                _cardPictureSize.Height = _fullCard;
                this.pictureBox2.Size = _cardPictureSize;
            }

            // get the saved image
            this.pictureBox2.Image = _cardBits[_cardReadingState];
            _cardReadingState++;

            // if we got to the end of our images
            if (_cardReadingState >= _cardBits.Length)
                _cardReadingState = 0;
        }
        private void EnableDisableStartWork()
        {
            // basically always enabled
            bool enabled = true;

            // unless there is nothing in one of the 2 input boxes
            if ((this.InputCICSNameBox.Text.Trim().Length == 0) || (this.InputLUNameBox.Text.Trim().Length == 0))
                enabled = false;

            this.StartWorkButton.Enabled = enabled;
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
                        // A non-numerical keystroke was pressed.
                        // Set the flag to true and evaluate in KeyPress event.
                        _nonNumberEntered = true;
                }
            }
        }

        private void HandleKeyPressNeedNumeric(System.Windows.Forms.KeyPressEventArgs e)
        {
            // Check for the flag being set in the KeyDown event.
            if (_nonNumberEntered == true)
            {
                // Stop the character from being entered into the control since it is non-numerical.
                e.Handled = true;
            }
        }

        private void PINBox_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            HandleKeyPressNeedNumeric(e);
        }
        private void PINBox_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            HandleKeyDown(e);
        }

        private void StartWorkButton_Click(object sender, EventArgs e)
        {
            DisableConfiguration();
            SetOpeningState();
        }
    }
}
