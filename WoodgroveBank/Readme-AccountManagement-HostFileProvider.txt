Steps to prepare the mainframe for the Host File Provider scenario for Woodgrove Bank.

1) Make sure you follow the steps in 
   a. Readme-01-VTAM-LU0-LU2-Setup.txt
   b. Readme-08-DFM-Configure-HIS.txt

2) Allocate and initialize the data sets required for the Woodgrove Bank Host Files 
   provider sample:
   a. Logon to TSO and enter ISPF at the command prompt if ispf is not already started
   b. Allocate base data sets
      1. Enter TSO command =3.2
      2. Using the "A Allocate new data set" command, allocate the following data sets
         a. MYUSERID.HIS85.WGRVBANK.CNTL     (DSORG=PO, RECFM=FB, LRECL=80, BLKSIZE=23440) 
   c. Transfer files to the mainframe data sets using IND$FILE 
      1. If using IND$FILE enter TSO command "=6"
      2 Send, from the PC to the Host the files in each directory to the corresponding host file 
         (the member name must be the same as the file name excluding the extension)
         a. <installdir>\SDK\Samples\EndToEndScenarios\WoodgroveBank\MainframeJob to MYUSERID.HIS85.WGRVBANK.CNTL
   d. Run the batch data set allocation job 
      1. Enter TSO command =3.4
      2. Enter MYUSERID.HIS85.WGRVBANK in the "Dsname Level" field 
      3. Edit data set MYUSERID.HIS85.WGRVBANK.CNTL by placing an E to the left of the data set name   
      4. Select member "ALLOC" by placing an S to the left of the member name
      5. Enter TSO command "C ALL MYUSERID <your userid>" where <your userid> is the ID you used to signon to TSO
      6. Replace all occurrances of STORCLASS(DBCLASS) with the correct information. SMS users should change to appropriate storage class as defined at their location. Non SMS users should change to the appropriate volume assigned to their location. Check with your mainframe system administrator for the correct information.
      7. Change the job name "MYJOBNAM" to a valid job name
      8. Enter TSO command Submit
      9. Press PF3 


Steps to create the Woodgrove Bank SQL Server Database

1) Note: The Woodgrove Bank Host Files tutorial uses a SQL Server database to demonstrate how to 
   move data between a host file and Microsoft SQL Server. A host file can contain nested 
   records or record sets, and these are normalized by the .NET data provider for Host FIles 
   into one or more tables inside a .NET DataSet. Each of these tables can be copied to SQL 
   Server where you can take advantage of any of SQL Server's services such as data analysis, 
   replication, or notification services.

2) SQL Server 2005
   a. Open SQL Server Management Studio by navigating to 
      Start->All Programs->Microsoft SQL Server 2005->Sql Server Management Studio.
   b. When the "Connect To Server" dialog appears, choose a server type of "Database Engine", 
      enter a valid server name and authentication, and click "Connect".
   c. Open the WoodgroveBank.sql file by navigating to the File menu->Open->File... and 
      choosing the WoodgroveBank.sql file from the tutorial.
   d. Run the sql script by pressing F5.


Steps to add schema information to a Host Files Metadata Assembly created by the Designer

1) Note: The Account Management tutorial contains a precreated metadata assembling that describe 
   the host files used by the Account Management client. To use the precreated assembly, 
   you must update the Table items to include the host file name on your host system.

   a. Open the Account Management directory and double click on "Account Management.sln". 
      This will open Visual Studio 2005.
   b. Once the solution opens, exapand the WoodgroveBankFiles project and double click on 
      the WoodgroveBankFiles.dll metadata assembly.
   c. The assembly opens using the HIS designer Visual Studio plug-in. You will see Tables, 
      Schemas, and Unions folders in the left pane of the designer. Expand the Tables folder 
      to reveal the two Tables, "Customers", and "Transactions".
   d. Right click on the "Customer" Table icon, and choose Properties.
   e. In the properties, change the Host File Name property from 
      "MYUSERID.HIS85.WGRVBANK.WBCUSTDB" to the name you have given your host file on the host.
   f. Repeat steps 4-5 for the "Transactions" Table. Change the Host File Name property 
      from MYUSERID.HIS85.WGRVBANK.WBTXNDB to the name you have given your host file on the host.
   g. Right click on the "WoodgroveBankFiles" icon, and choose Properties.
      change KeyFile to : WoodgroveBank.snk  ( without this step you cannot GAC assembly)
   h. Save the assembly by selecting File menu->Save All.

Steps to register the Host Files Metadata Assembly

1) Note: The host file provider uses metadata stored in a .NET assembly. This metadata contains 
   information about the records and fields that a particular host file can contain. Metadata 
   assemblies contain both COM and .NET types and so need to be registered with Regasm.exe as 
   well as making the assembly available. In this tutorial, you will add the assembly to the 
   Global Assembly Cache (GAC) and use Regasm.exe to register the assembly.

   a. Open a Visual Studio 2005 Command Prompt by navigating to 
      Start->All Programs->Microsoft Visual Studio 2005->Visual Studio Tools->Visual Studio 2005 Command Prompt
   b. Change the current directory to the tutorial location.
   c. Add the assembly to the Global Assembly Cache by typing 
      "Gacutil /i WoodgroveBankFiles.dll" and pressing enter.
   d. Register the COM types in the assembly by typing "Regasm WoodgroveBankFiles.dll" 
      and pressing enter.

Steps to create a Connection String using the Data Access Tool

1) Note: The Account Management Client uses the .NET data provider for Host Files. You can create 
   connection strings for this provider using the Data Access Tool, which includes a Wizard 
   that walks you through the steps of creating a connection to a host.

a. Open the Data Access Tool by selecting 
   Start->All Programs->Microsoft Host Integration Server 2010->Data Access Tool.
b. When the Data Access Tool opens, select File menu->New->Data Source...
c. The Data Source Wizard Welcome page appears. Click Next to continue.
d. On the Data Source page, from the "Data source platform" drop down choose 
   "Mainframe or AS/36 file system". SNA LU6.2 will be selected as the Network type. 
   Click Next to continue.
e. On the APPC Network Connection page, select your Local LU alias, Remote LU alias, 
   and Mode name from the drop down items. Click Next to continue.
f. On the Mainframe or AS/36 File System page, enter the default library value for 
   your host under Default Library (for this tutorial, the Default Library is the 
   high level qualifier for the VSAM data sets that were allocated in step 4 associated 
   with preparing the mainframe). Click Browse... under Host file mappings and 
   navigate to your Metadata Assembly located in the WoodgroveBankFiles directory. 
   Click Next to continue.
g. On the Locale page, click Next to continue.
8. On the Security page, enter the user name and password needed to connect to the host. 
   Select the Allow saving Password checkbox to persist the password. Click Next to continue.
9. On the Adanced Options page, Click next to continue.
10. On the Validation page, you can perform a test connection. Click next to continue.
11. On the Saving Information page, enter a data source name such as "HostProviderConnection", 
    check the "Universal data link" checkbox, and click Next.
12. Click Finish on the Finish page.
13. Your new data source will appear under the File System OLE DB UDLs. 
    Right click on the data source icon and choose "Display Connection String". 
    You will see the connection string appear in the Output pane. Copy this connection 
    string for use in the Account Management Client program.


---Run the Woodgrove Bank Account Management solution---

The Woodgrove Bank Account Management solution contains sample functionality for accessing 
host files using the .NET data provider for Host Files. These actions include deleting all 
records from a host file, adding new records to a host file from data in an XML document, 
transfering records from a host file to a local XML file, transfering records from a host 
file to a SQL Server database, and displaying the contents of a host file in a WinForms 
DataGrid.

1. Open the Account Management directory and double click on "Account Management.sln"
2. Press F5 to run the project.
3. When the Woodgrove Bank Manager form appears, you will need to enter a connection string. 
   Use the connection string you created using the Data Access Tool. Once you have typed in 
   or pasted the connection string, click on the "Connect" button.
4. Select the host file you want to work with from the Host File drop down, either Customers 
   or Transactions.
5. To clear all the records in the host file, select the "Delete all records from the host 
   file" radio button and click the "Execute" button. Do not choose this option if you do 
   not want to clear all file contents.
6. To add records from an XML file to the host file, select the "move records from XML 
   to the host file" radio button. Click on the "Browse..." button to select the file 
   containing XML data pertaining to the table you have chosen. For example, if you are 
   working with the Customers table from the Host file drop down, you can use the 
   NewCustomers.xml file that is included in the tutorial. Once you have chosen the 
   XML file, click on the Execute button.
7. To copy all records from the host file to a local XML file, click on the 
   "Move records from the host file to XML" radio button. Click on the "Browse..." button 
   and type in a name for the XML file where the records will be saved. Click on "Execute" 
   to transfer the records.
8. To copy all records from the host file to a SQL Server database, click on the 
   "Move records from the host file to SQL Server" radio button. Enter a connection string 
   to a SQL Server database. Use a connection string to the database where you ran the 
   WoodgroveBank.sql file (see the section "Creating the Woodgrove Bank SQL Server Database" 
   in this document). Click on "Execute" to transfer the records.
9. To display the contents of a host file, click on the "Display records in the host file" 
   radio button. Click on "Execute" to display the records. You can choose which table to 
   view in the resulting .NET DataSet by choosing one from the "DataSet table" drop down. 
   The DataSet will contain more than one table if the host file contains nested recordsets, 
   unions, or arrays.