using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using Microsoft.HostIntegration.SNA.Session;

namespace CSClient
{
	class AccountHandler
	{
		private SessionLU0 _session = null;

		private string _accountNumber = "";
		private string _pin = "";
		private string _ssn = "";
		private string _name = "";

		private string[] _accountNumbers = null;
		private string[] _accountNames = null;

		private string _returnedStatementString = "";

		// HostConverter allows for multiple CodePages per process, use instead of
		// Deprecated HostStringConverter
		HostConverter hostConverter = new HostConverter();

		// as the LU0 managed wrapper does no tracing
		// we will trace the data contents to the provided text box
		private TextBox m_TextBox = null;
		private Font m_FixedFont;

		public AccountHandler(SessionConnectionLU0 connection)
		{
			if (connection == null)
				throw new ArgumentNullException("connection");

			// attach the connection to a new Session
			_session = new SessionLU0(connection);

			// if we should trace, we need a fixed width font
			FontFamily fontFamily = new FontFamily("Courier New");
			m_FixedFont = new Font(fontFamily, 10, FontStyle.Regular, GraphicsUnit.Pixel);
		}

		public void FinishWithAccount()
		{
			if (_session != null)
				_session.Disconnect();
			_session = null;
		}

		// if the Client of account handler wishes, we will trace to a provided TextBox
		public TextBox TraceTextBox
		{
			set
			{
				m_TextBox = value;

				// setup some things
				m_TextBox.WordWrap = false;
				m_TextBox.Multiline = true;

				// find a fixed font
				m_TextBox.Font = m_FixedFont;
			}
		}

		public string[] AccountNames { get { return _accountNames; } }
		public string[] AccountNumbers { get { return _accountNumbers; } }
		public string UserName { get { return _name; } }

		public void ValidateAccount(string accountNumber, string PIN)
		{
			if (accountNumber.Length != 10)
				throw new ArgumentException("Length is not 10", "accountNumber");
			if (PIN.Length != 4)
				throw new ArgumentException("Length is not 4", "PIN");

			// create a Logon Message
			//
			// 4 Bytes TXN in EBCDIC
			// 10 Bytes Account Number in EBCDIC
			// 4 Bytes PIN in EBCDIC
			string wholeMessageUnicode = "WB00" + accountNumber + PIN;
			// convert to EBCDIC
			byte[] ebcdicTXN = hostConverter.ConvertUnicodeToEbcdic(wholeMessageUnicode);

			// send the stuff off, throwing if on error
			SessionLU0Data data = new SessionLU0Data();
			data.Data = ebcdicTXN;

			// trace out the data to send
			TraceData(true, ebcdicTXN, 0);

			_session.Send(data);

			// now wait for the reply for 20 seconds
			SessionLU0Data receivedData = _session.Receive(20000, true);

			// trace out the received data
			TraceData(false, receivedData.Data, (int)receivedData.Indication);

			// translate back to Unicode
			string unicodeString = hostConverter.ConvertEbcdicToUnicode(receivedData.Data);

			// Format of returned message:
			// 1 Byte 
			//      0 = Success
			//      1 = No Such Account
			//      2 = PIN Incorrect
			//
			// 9 Bytes - SSN
			// 30 Bytes - Name
			switch (unicodeString[0])
			{
				case '0':
					break;
				case '1':
					throw new ArgumentException("Invalid Account Number", "accountNumber");
				case '2':
					throw new ArgumentException("Invalid PIN", "pin");
				default:
					throw new Exception("Host returned - " + unicodeString[0]);
			}

			if (unicodeString.Length != 40)
				throw new Exception("Data returned from Host - " + unicodeString + " is not 40 characters long");

			// all is well, keep hold of the data
			_accountNumber = accountNumber;
			_pin = PIN;
			_ssn = unicodeString.Substring(1, 9);
			_name = unicodeString.Substring(10, 30);
		}

		public decimal GetBalance()
		{
			if (_ssn.Length == 0)
				throw new Exception("You have not yet logged in");

			// create a GetBalance
			//
			// 4 Bytes TXN in EBCDIC
			// 10 Bytes Account Number in EBCDIC
			// 9 Bytes SSN in EBCDIC
			string wholeMessageUnicode = "WB01" + _accountNumber + _ssn;
			// convert to EBCDIC
			byte[] ebcdicTXN = hostConverter.ConvertUnicodeToEbcdic(wholeMessageUnicode);

			// send the stuff off, throwing if on error
			SessionLU0Data data = new SessionLU0Data();
			data.Data = ebcdicTXN;

			// trace out the data to send
			TraceData(true, ebcdicTXN, 0);

			_session.Send(data);

			// now wait for the reply for 20 seconds
			SessionLU0Data receivedData = _session.Receive(20000, true);

			// trace out the received data
			TraceData(false, receivedData.Data, (int)receivedData.Indication);

			// translate back to Unicode
			string unicodeString = hostConverter.ConvertEbcdicToUnicode(receivedData.Data);

			// Format of returned message:
			// 1 Byte 
			//      0 = Success
			//      1 = No Such Account
			//      3 = No Such SSN
			//
			// 10.2 (13) Bytes - Balance
			switch (unicodeString[0])
			{
				case '0':
					break;
				case '1':
					throw new Exception("Invalid Account Number!");
				case '3':
					throw new Exception("Invalid SSN!");
				default:
					throw new Exception("Host returned - " + unicodeString[0]);
			}
			if (unicodeString.Length != 14)
				throw new Exception("Data returned from Host - " + unicodeString + " is not 14 characters long");

			return decimal.Parse(unicodeString.Substring(1));
		}

		public decimal Withdraw(int value)
		{
			if (_ssn.Length == 0)
				throw new Exception("You have not yet logged in");

			// create a Withdrawal
			//
			// 4 Bytes TXN in EBCDIC
			// 10 Bytes Account Number in EBCDIC
			// 9 Bytes SSN in EBCDIC
			// 3 Bytes value (020/040/060/080/100/150/200) in EBCDIC
			string valueString = value.ToString();
			if (valueString.Length == 2)
				valueString = "0" + valueString;

			string wholeMessageUnicode = "WB03" + _accountNumber + _ssn + valueString;
			// convert to EBCDIC
			byte[] ebcdicTXN = hostConverter.ConvertUnicodeToEbcdic(wholeMessageUnicode);

			// send the stuff off, throwing if on error
			SessionLU0Data data = new SessionLU0Data();
			data.Data = ebcdicTXN;

			// trace out the data to send
			TraceData(true, ebcdicTXN, 0);

			_session.Send(data);

			// now wait for the reply for 20 seconds
			SessionLU0Data receivedData = _session.Receive(20000, true);

			// trace out the received data
			TraceData(false, receivedData.Data, (int)receivedData.Indication);

			// translate back to Unicode
			string unicodeString = hostConverter.ConvertEbcdicToUnicode(receivedData.Data);

			// Format of returned message:
			// 1 Byte 
			//      0 = Success
			//      1 = No Such Account
			//      3 = No Such SSN
			//      4 = Would Overdraw
			//
			// 10.2 (13) Bytes - Balance
			switch (unicodeString[0])
			{
				case '0':
					break;
				case '1':
					throw new Exception("Invalid Account Number!");
				case '3':
					throw new Exception("Invalid SSN!");
				case '4':
					throw new Exception("Would require an Overdraft!");
				default:
					throw new Exception("Host returned - " + unicodeString[0]);
			}

			if (unicodeString.Length != 14)
				throw new Exception("Data returned from Host - " + unicodeString + " is not 14 characters long");

			return decimal.Parse(unicodeString.Substring(1));
		}

		public void RetrieveAccounts()
		{
			if (_ssn.Length == 0)
				throw new Exception("You have not yet logged in");

			// if we already have the accounts
			if (_accountNumbers != null)
				return;

			// create a GetAccounts
			//
			// 4 Bytes TXN in EBCDIC
			// 9 Bytes SSN in EBCDIC
			string wholeMessageUnicode = "WB02" + _ssn;
			// convert to EBCDIC
			byte[] ebcdicTXN = hostConverter.ConvertUnicodeToEbcdic(wholeMessageUnicode);

			// send the stuff off, throwing if on error
			SessionLU0Data data = new SessionLU0Data();
			data.Data = ebcdicTXN;

			// trace out the data to send
			TraceData(true, ebcdicTXN, 0);

			_session.Send(data);

			// now wait for the reply for 20 seconds
			SessionLU0Data receivedData = _session.Receive(20000, true);

			// trace out the received data
			TraceData(false, receivedData.Data, (int)receivedData.Indication);

			// translate back to Unicode
			string unicodeString = hostConverter.ConvertEbcdicToUnicode(receivedData.Data);

			// Format of returned message:
			// 1 Byte 
			//      0 = Success
			//      3 = No Such SSN
			// 1 Byte - Count of Accounts, Max 9
			//
			// 9 * (10 Bytes - Number, 10 Bytes - Name)
			switch (unicodeString[0])
			{
				case '0':
					break;
				case '3':
					throw new Exception("Invalid SSN!");
				default:
					throw new Exception("Host returned - " + unicodeString[0]);
			}

			// get the count
			int numberOfAccounts = int.Parse(unicodeString.Substring(1, 1));
			if (numberOfAccounts == 0)
				throw new Exception("Data returned from Host - " + unicodeString + " shows Count of Accounts = 0");

			int expectedLength = 2 + numberOfAccounts * (10 + 10);

			if (unicodeString.Length != expectedLength)
				throw new Exception("Data returned from Host - " + unicodeString + " is not " + expectedLength.ToString() + " characters long");

			_accountNumbers = new string[numberOfAccounts];
			_accountNames = new string[numberOfAccounts];

			int offset = 2;
			int accountIndex = 0;
			for (int i = 0; i < numberOfAccounts; i++)
			{
				// filter out the account corresponding to the account logged in
				if (unicodeString.Substring(offset, 10) != _accountNumber)
				{
					_accountNumbers[accountIndex] = unicodeString.Substring(offset, 10);
					offset += 10;
					_accountNames[accountIndex++] = unicodeString.Substring(offset, 10);
					offset += 10;
				}
				else
					offset += 20;
			}
			if (numberOfAccounts != accountIndex)
			{
				Array.Resize(ref _accountNumbers, accountIndex);
				Array.Resize(ref _accountNames, accountIndex);
			}
		}

		public decimal Transfer(int value, string accountNumber)
		{
			if (_ssn.Length == 0)
				throw new Exception("You have not yet logged in");

			if (accountNumber.Length != 10)
				throw new ArgumentException("Length is not 10", "accountNumber");

			if (value < 0)
				throw new ArgumentOutOfRangeException("value", "You can only transfer positive values");

			// no sense in moving stuff from / to the same account
			if (accountNumber == _accountNumber)
				throw new ArgumentException("Transfer not supported to/from the same account", "accountNumber");

			// create a Transfer
			//
			// 4 Bytes TXN in EBCDIC
			// 10 Bytes Account Number in EBCDIC
			// 9 Bytes SSN in EBCDIC
			// 3 Bytes value (020/040/060/080/100/150/200) in EBCDIC
			// 10 Bytes Destination Account Number in EBCDIC
			string valueString = value.ToString();
			if (valueString.Length == 2)
				valueString = "0" + valueString;

			string wholeMessageUnicode = "WB04" + _accountNumber + _ssn + valueString + accountNumber;
			// convert to EBCDIC
			byte[] ebcdicTXN = hostConverter.ConvertUnicodeToEbcdic(wholeMessageUnicode);

			// send the stuff off, throwing if on error
			SessionLU0Data data = new SessionLU0Data();
			data.Data = ebcdicTXN;

			// trace out the data to send
			TraceData(true, ebcdicTXN, 0);

			_session.Send(data);

			// now wait for the reply for 20 seconds
			SessionLU0Data receivedData = _session.Receive(20000, true);

			// trace out the received data
			TraceData(false, receivedData.Data, (int)receivedData.Indication);

			// translate back to Unicode
			string unicodeString = hostConverter.ConvertEbcdicToUnicode(receivedData.Data);

			// Format of returned message:
			// 1 Byte 
			//      0 = Success
			//      1 = No Such Account (source)
			//      3 = No Such SSN
			//      4 = Would Overdraw
			//      5 = No Such Account (destination)
			//
			// 10.2 (13) Bytes - Balance
			switch (unicodeString[0])
			{
				case '0':
					break;
				case '1':
					throw new Exception("Invalid Account Number - Source!");
				case '3':
					throw new Exception("Invalid SSN!");
				case '4':
					throw new Exception("Would require an Overdraft!");
				case '5':
					throw new Exception("Invalid Account Number - Destination!");
				default:
					throw new Exception("Host returned - " + unicodeString[0]);
			}

			if (unicodeString.Length != 14)
				throw new Exception("Data returned from Host - " + unicodeString + " is not 14 characters long");

			return decimal.Parse(unicodeString.Substring(1));
		}

		public string[] GetStatements(int startingStatementNumber, int numberToGet)
		{
			if (_ssn.Length == 0)
				throw new Exception("You have not yet logged in");
			if (startingStatementNumber > 99)
				throw new ArgumentOutOfRangeException("startingStatementNumber", "Can't get more than 100 statements");
			if (numberToGet > 9)
				throw new ArgumentOutOfRangeException("numberToGet", "Can't get more than 9 statements at once");

			// create a GetAccounts
			//
			// 4 Bytes TXN in EBCDIC
			// 9 Bytes SSN in EBCDIC
			// 17 Bytes (original values) Filled by return values from last call
			//      10 Bytes Account Number in EBCDIC (spaces)
			//       7 Bytes, Seq No in EBCDIC (all zeroes)
			// 1 Byte number of statements per call in EBCDIC
			if (startingStatementNumber == 0)
				_returnedStatementString = "          0000000";

			string wholeMessageUnicode = "WB05" + _ssn + _returnedStatementString + numberToGet.ToString();

			// convert to EBCDIC
			byte[] ebcdicTXN = hostConverter.ConvertUnicodeToEbcdic(wholeMessageUnicode);

			// send the stuff off, throwing if on error
			SessionLU0Data data = new SessionLU0Data();
			data.Data = ebcdicTXN;

			// trace out the data to send
			TraceData(true, ebcdicTXN, 0);

			_session.Send(data);

			// now wait for the reply for 20 seconds
			SessionLU0Data receivedData = _session.Receive(20000, true);

			// trace out the received data
			TraceData(false, receivedData.Data, (int)receivedData.Indication);

			// translate back to Unicode
			string unicodeString = hostConverter.ConvertEbcdicToUnicode(receivedData.Data);

			// Format of returned message:
			// 1 Byte 
			//      0 = Success (including no more statements)
			//      1 = No Such Account
			//      6 = Error in count/number
			// 17 Bytes
			//      10 Bytes Account Number in EBCDIC
			//       7 Bytes, Seq No in EBCDIC
			// 1 Byte - Count of Statements, Max 9
			//
			// 9 * 35 Bytes
			switch (unicodeString[0])
			{
				case '0':
					break;
				case '1':
					throw new Exception("Invalid Account!");
				case '6':
					throw new Exception("Wrong Order or Incorrect Count");
				default:
					throw new Exception("Host returned - " + unicodeString[0]);
			}

			// get the returned string
			_returnedStatementString = unicodeString.Substring(1, 17);

			// get the count
			int numberOfStatements = int.Parse(unicodeString.Substring(18, 1));
			int expectedLength = 19 + numberOfStatements * 34;

			if (unicodeString.Length != expectedLength)
				throw new Exception("Data returned from Host - " + unicodeString + " is not " + expectedLength.ToString() + " characters long");

			string[] results = new string[numberOfStatements];

			int offset = 19;
			for (int i = 0; i < numberOfStatements; i++)
			{
				results[i] = unicodeString.Substring(offset, 34);
				offset += 34;
			}

			return results;
		}

		// print out the Data to a provided text box
		private void TraceData(bool sent, byte[] data, int indication)
		{
			if (m_TextBox == null)
				return;

			// was the last thing sent or received?
			if (sent)
				m_TextBox.Text += "====>> Sent to Host" + Environment.NewLine;
			else
				m_TextBox.Text += "<<==== Received from Host" + Environment.NewLine;

			// how much is there to trace
			int traceLength = data.Length;

			m_TextBox.Text += "Size = " + traceLength.ToString();

			if (!sent)
				m_TextBox.Text += String.Format(", Indication = {0:X}", indication);

			m_TextBox.Text += Environment.NewLine;

			int numberTraced = 0;
			while (numberTraced < traceLength)
			{
				string hexLine = "";
				for (int i = 0; i < 16; i++)
				{
					if (numberTraced + i >= traceLength)
						hexLine += "   ";
					else
						hexLine += String.Format("{0:x2} ", data[numberTraced + i]);
				}

				m_TextBox.Text += hexLine + Environment.NewLine;

				numberTraced += 16;
			}
		}
	}
}
