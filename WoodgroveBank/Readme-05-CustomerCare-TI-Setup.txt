Steps to prepare CICS on the mainframe for the Woodgrove Bank CICS  
Customer Care applications that uses Transaction Integrator with the 

********************************************************************
** Important notes on the TCP/IP environment for CICS
********************************************************************
** There is a single versions of the Microsoft COMTI Concurrent Server
** sample program. It is:
** 1. MSCMTICS
**
** The HIS 2010 version of this program must be used with the Woodgrove 
** Bank Customer Care Tutorial. It has special code in it that allows
** the server application program in CICS to maintain context information
** when using Persistent Connection calls. This 
** context information is passed back and forth between MSCMTICS program 
** and the Server program. The 1st 256 bytes of the Commarea are used 
** for this purpose. User data associated with the real method call 
** start at position 257 in the Commarea
**
** The HIS 2010 version of this program is used for all other TRM and 
** ELM applications as well. The functionality of the HIS 2010 version
** of this program is same as the HIS 2004 version and is therefore
** compatible with existing WIP client applications. New WIP applicaitons 
** that want to use Server Context with Persistent Connections need to use
** the HIS 2010 version of the program.
**
** Both Microsoft Concurrent Server programs can be installed and
** use by Standard and Enhanced listeners at the same time.
**
** If a simple Installation Verification is needed without the need 
** for the complete Woodgrove Bank scenario, the TI tutorial found in
** %SNARoot%\..\SDK\Samples\ApplicationIntegration\WindowsInitiated\InstallationVerification
** is a better starting point. This IVP (Installation Verification Program) 
** uses the MSCMTICS Concurrent Server program and the GetBalance 
** application program
** 
**********************************************************************


Prepare CICS for execution of the TI programs
1) Logon to TSO and enter ISPF at the command prompt if ispf is not already started

2) Allocate base data sets
   a) Enter TSO command =3.2
   b) Using the "A Allocate new data set" command, allocate the following data sets
      1) MYUSERID.HIS85.TUTORIAL.CNTL     (DSORG=PO, RECFM=FB, LRECL=80, BLKSIZE=23440) 
      2) MYUSERID.HIS85.TUTORIAL.COB      (DSORG=PO, RECFM=FB, LRECL=80, BLKSIZE=23440) 
      3) MYUSERID.HIS85.TUTORIAL.MAPS     (DSORG=PO, RECFM=FB, LRECL=80, BLKSIZE=23440)
      4) MYUSERID.HIS85.TUTORIAL.LKDCNTL  (DSORG=PO, RECFM=FB, LRECL=80, BLKSIZE=23440)  
      5) MYUSERID.HIS85.TUTORIAL.COBCOPY  (DSORG=PO, RECFM=FB, LRECL=80, BLKSIZE=23440)    
      6) MYUSERID.HIS85.TUTORIAL.LOADLIB  (DSORG=PO, RECFM=U, BLKSIZE=23046) 

3) Transfer files to the mainframe data sets using IND$FILE or FTP 
   a) If using IND$FILE enter TSO command "=6"
   b) Send, from the PC to the Host the files in each directory to the corresponding host file 
      (the member name must be the same as the file name excluding the extension)
      1) %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\MainframeJob                                          to MYUSERID.HIS85.TUTORIAL.CNTL
      2) %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TransactionIntegrator\CICS\ELMLink\*.lkd to MYUSERID.HIS85.TUTORIAL.LKDCNTL
      3) %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TransactionIntegrator\CICS\ELMLink\*.cbl to MYUSERID.HIS85.TUTORIAL.COB
      4) %SNARoot%\..\SDK\Samples\ApplicationIntegration\WindowsInitiatedSampleCode\TCP CICS MSLink\mscmtics.cbl        to MYUSERID.HIS85.TUTORIAL.COB
      5) %SNARoot%\..\SDK\Samples\ApplicationIntegration\WindowsInitiatedSampleCode\TCP CICS MSLink\mscmtics.lkd        to MYUSERID.HIS85.TUTORIAL.LKDCNTL
           
Compile and link the mainframe CICS Programs
1) Logon to TSO
2) Edit each file in MYUSERID.HIS85.TUTORIAL.MAPS
   a) Add a Job card and a COBOL CICS compile and link step prior to the BMS map source
   b) Use the similar named linkage control statements in MYUSERID.HIS85.TUTORIAL.LKDCNTL 
   c) Note: Return code of 4 is OK for this job
3) Edit each file in MYUSERID.HIS85.TUTORIAL.COB
   a) Add a Job card and a COBOL CICS compile and link step prior to the COBOL source
   b) Use the similar named linkage control statements in MYUSERID.HIS85.TUTORIAL.LKDCNTL 
   
Allocate and initialize the data sets required to execute the Woodgrove Bank programs
1) Run the batch data set allocation job 
   a) Enter TSO command =3.4
   b) Enter MYUSERID.HIS85.HISSAMP in the "Dsname Level" field 
   c) Edit data set MYUSERID.HIS85.TUTORIAL.CNTL by placing an E to the left of the data set name   
   d) Select member "ALLOC" by placing an S to the left of the member name
   e) Enter TSO command "C ALL MYUSERID <your userid>" where <your userid> is the ID you used to signon to TSO
   f) Change the job name "MYJOBNAM" to a valid job name
   g) Enter TSO command Submit
   h) Press PF3 
   
Define the CICS Transaction resources 
1) Logon to CICS
2) Clear the screen
3) Using the tranasction based Resource Definition enter the following commands:
   a) CEDA DEF GROUP(HISSAMP) TRANS(MSCS) PROGRAM(MSCMTICS)
  
Define the CICS Program resources
   a) CEDA DEF GROUP(HISSAMP) PROGRAM(MSCMTICS)  LANG(COBOL) 
   b) CEDA DEF GROUP(HISSAMP) PROGRAM(WTIGBAL)   LANG(COBOL) 
   c) CEDA DEF GROUP(HISSAMP) PROGRAM(WTIGACC)   LANG(COBOL) 
   d) CEDA DEF GROUP(HISSAMP) PROGRAM(WTIGCUSI)  LANG(COBOL) 
   e) CEDA DEF GROUP(HISSAMP) PROGRAM(WTISCUSI)  LANG(COBOL) 
   f) CEDA DEF GROUP(HISSAMP) PROGRAM(WTIGSTMT)  LANG(COBOL) 
   g) CEDA DEF GROUP(HISSAMP) PROGRAM(WTIADDA)   LANG(COBOL) 
   h) CEDA DEF GROUP(HISSAMP) PROGRAM(WTIADDC)   LANG(COBOL) 

Define the CICS File resources 
   a) CEDA DEF GROUP(HISSAMP) FILE(WBCUSTDB) DSN(MYUSERID.HIS85.TUTORIAL.WBCUSTDB)
                                             ADD(YES) BR(YES) UPDATE(YES) READ(YES)
   b) CEDA DEF GROUP(HISSAMP) FILE(WBACCTDB) DSN(MYUSERID.HIS85.TUTORIAL.WBACCTDB)
                                             ADD(YES) BR(YES) UPDATE(YES) READ(YES) 
   c) CEDA DEF GROUP(HISSAMP) FILE(WBTXNDB)  DSN(MYUSERID.HIS85.TUTORIAL.WBTXNDB)
                                             ADD(YES) BR(YES) UPDATE(YES) READ(YES) 
                                              
Install the CICS Woodgrove Bank resource group
   1) CEDA INSTALL GROUP(HISSAMP)

Define and start the CICS Enhanced Listener for Woodgrove Bank
   a) Note: CSKM is used as a default value for the definition of 
            the Enhanced Listener. Please choose a name that is appropriate 
            for your installation
   b) Define a TCP/IP Enhanced Listener for the Woodgrove Bank Customer Care
      Applicaiton
         EZAC DEF LISTENER
            TranID: CSKM
            Format: Enhanced
            Port: {choose a port number, e.g.7511}
            Immediate: Yes
            Backlog:  40
            Numsock: 100
            MinMsgL:   4
            AccTime:  30
            GivTime: 600
            ReaTime: 300            
            CSTranID: MSCS 
            CSSTType: KC
            CSDelay: 0
            MsgLength: 35
            PeekData: No
            MsgFormat: EBCDIC  
   c) Start the CICS enhanced listeners
      1) Use CICS transaction 'EZAO' to start Listener CSKM
                                 
TCP/IP configuration       
a) Define the port to be used for accessing CICS in
   TCPIP.PROFILE.DATA. "HOSTCICS" is the name if the
   CICS Region.
   PORT
      7511 TCP HOSTCICS            ; CICS ELM Link Socket   
                  
Opening and Closing the CICS VSAM Files
1) Logon to CICS
2) Clear the screen
3) To open the Woodgrove Bank VSAM Files ent the CICS command:
      CEMT S FILE(WBCUSTDB,WBACCTDB,WBTXNDB) OPE ENA
4) To close the Woodgrove Bank VSAM Files ent the CICS command:
      CEMT S FILE(WBCUSTDB,WBACCTDB,WBTXNDB) CLO DIS

