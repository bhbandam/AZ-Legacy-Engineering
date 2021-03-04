Steps to prepare the Windows workstation for the Woodgrove Bank CICS ATM and 
Customer Care applications that use LU0 and LU2 protocols. 

Configure Host Integration Server 2010
1) The following instructions use names that may not be valid for your installation.
   Check with your mainframe system administrator for appropriate name
   a. Remote LU Alias name for CICS region: HOSTCICS
   b. SNA LU6.2 Name: Lxxxnn00
   c. SNA LU2 Names: Lxxxnn02 - Lxxxnn07
   d. SNA LU0 Names: Lxxxnn08
   e. Network name: NETWRKNM
   f. Primary NNS name for the IP-DLC link service: SYS1
2) Configure an IP-DLC link service named SNAIP1
3) Add a connection name TOSYS1 that is configered as a Peer System using SNAIP1
4) Add a connection name LUPOOL that is configued as a Host System
   a) Address: Network Name=NETWRKNM, Control Point Name=SYS1
   b) System Identification: Local Node ID=05D A00nn
5) Add Display LU's to the LUPOOL Connections
   a) Lxxxnn02 - Lxxxnn07
   b) Assign LU's to user Everyone
6) Add Application LU to the LUPOOL Connections   
   a) Lxxxnn08
   b) Assign LU to user Everyone
7) Add Local APPC LU
   a) LU Alias:     Lxxxnn00   
   b) Network name: NETWRKNM
   c) LU Name:      Lxxxnn00
8) Add Remote APPC LU
   a) Connection:         TOSYS1
   b) LU Alias:           HOSTCICS
   c) Network name:       NETWRKNM
   d) LU Name:            HOSTCICS
   e) Uninterpreted name: HOSTCICS
9) Add Pools
   a) TERMPOOL: Add display terminals Lxxxnn02 - Lxxxnn07
   b) LUAPOOL: Add application terminal Lxxxnn08
   c) Assign poolsto user Everyone
10) Save Configuration
11) Right click "My Computer", click "Manage", expand "Services and Applications", double click "Services"
12) Set "Session Integrator Server" to startup Manually
13) From a command prompt enter the following commands net stop "SIServer"
14) Start Sna Server and Connections
15) Start Session Integrator Server. From a command window type net start "SIServer" and press enter
16) Add "SNALink.exe" as a Program Exception in the Windows Firewall application

