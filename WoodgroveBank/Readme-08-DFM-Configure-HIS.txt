Steps to prepare Windows for the Woodgrove Bank application that use LU0 and LU2 protocols and Host File Provider.

Configure Host Integration Server 2010
1) Note: The following instructions use names that may not be valid for your installation.
   Check with your mainframe system administrator for appropriate names.
   a. Remote LU Alias name for DFM : MVS1DFM
   b. Local Node ID: 05D A00nn
   c. SNA LU6.2 Name: Lxxxnn00
   d. SNA LU2 Names: Lxxxnn02 - Lxxxnn07
   e. SNA LU0 Names: Lxxxnn08
   f. Local Network name: NETWRKNM
   g. Local Control point: CONTRLPT
   h. Host Network name: HOSTNETNM
   i Primary NNS name for the IP-DLC link service: SYS1
   
2) Configure an IP-DLC link service named SNAIP1
   a. Set Primary NNS to SYS1
   b. Set Network name to NETWRKNM
   c. Set Control point to CONTRLPT
   d. Click OK
   e. Specify Service UserID and Password
   f. Click Finish

3) Add a peer system connection
   a. Expand the SNA Service node
   b. Right click Connections, click New->IP-DLC...
   c. On the General tab
      1. Set Name to TOSYS1
      2. Expand list for Link Service and select SNAIP1
      3. Expand list for Remote end and select Peer System

4) Add a host system connection 
   a. Right click Connections, click New->IP-DLC...
   b. General tab
      1. Set Name to LUPOOL
      2. Expand list for Link Service and select SNAIP1
      3. Expand list for Remote end and select Host System
      4. Expand list for Allow directions and select Outgoing calls
      5. Expand list for Activation and select On server startup
   c. Address tab 
      1. Set Network name to HOSTNETNM 
      2. Set Control point to SYS1 
   d. System Identification tab
      1. Set Local Node ID=05D A00nn

5) Add a range of Display LUs
   a. Right click LUPOOL and click All Tasks->Range of LUs...
   b. Set Server and Connection using the drop down lists and then click Next
   c. Click Display in the LU Type group
   d. Click Decimal in the Base group
   e. Set Base LU name to Lxxxnn
   f. Set First Lunumber to 2
   g. Set number of LUs to 6
   h. Click Finish   
   
6) Add a range of LUA LUs
   a. Right click LUPOOL and click All Tasks->Range of LUs...
   b. Set Server and Connection using the drop down lists and then click Next
   c. Click LUA/TN3270 in the LU Type group
   d. Click Decimal in the Base group
   e. Set Base LU name to Lxxxnn
   f. Set First Lunumber to 8
   g. Set number of LUs to 1
   h. Click Finish   
      
7) Add users
   a. Right click Configured Users and click New->User...
   b. Type Everyone and click OK
   
8) Add a 3270 Display LU pool
   a. Right click Pools and click New->3270 Display LU Pool...
   b. Set Pool name to TERMPOOL
   c. Click OK
   d. Right click TERMPOOL and click Assign LUs...
   e. Click Connection LUPOOL
   f. Multi-select Lxxxnn02 - Lxxxnn07
   g. Click OK
   h. Right click TERMPOOL and select Assign to Users 
   i. Select Everyone and click OK
   
9) Add an LUA LU pool
   a. Right click Pools and click New->LUA LU Pool...
   b. Set Pool name to LUAPOOL
   c. Click OK
   d. Right click LUAPOOL and click Assign LUs...
   e. Click Connection LUPOOL
   f. Select Lxxxnn08
   g. Click OK
   h. Right click LUPOOL and select Assign to Users 
   i. Select Everyone and click OK

10) Add a Local APPC LU
   a. Right click Local APPC LUs and click New->Local LU...
   b. On the General tab
      1. Set LU Alias to Lxxxnn00   
      2. Set Network name to NETWRKNM
      3. Set LU Name to Lxxxnn00
   c. Click OK
   
11) Add a Remote APPC LU
   a. Right click Remote APPC LUs and click New->Remote LU...
   b. On the General tab
      1. Select TOSYS1 in the Connectrion drop down list 
      2. Set LU alias to           MVS1DFM
      3. Set Network name to       NETWRKNM
      4. Set LU Name to            MVS1DFM
      5. Set Uninterpreted name to MVS1DFM
   c. Click OK   
   
12) Save the configuration
   a. Right click Server node and click Save configuration

13) Start the SNA Base Service
   a. Right click "My Computer"
   b. Click "Manage"
   c. Expand "Services and Applications"
   d. Double click "Services"
   e. Scroll down to SNABase
   f. Right click SNABase and click Start

14) Set "Session Integrator Server" to startup Manually

15) Stop Session Integrator Server
   a. From a command prompt enter the following commands "net stop SIServer"

16) Start Sna Server and Connections

17) Start Session Integrator Server
   a. a. From a command prompt enter the following commands "net start SIServer"

18) Add "SNALink.exe" as a Program Exception in the Windows Firewall application
