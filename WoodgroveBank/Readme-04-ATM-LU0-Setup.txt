Steps to prepare the mainframe for execution of the ATM LU0 CICS programs.

Prepare CICS for execution of the LU0
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
      1) <installdir>\SDK\Samples\EndToEndScenarios\WoodgroveBank\MainframeJob          to MYUSERID.HIS85.TUTORIAL.CNTL
      2) <installdir>\SDK\Samples\EndToEndScenarios\WoodgroveBank\ATM\CICSLU0Pgms\*.lkd to MYUSERID.HIS85.TUTORIAL.LKDCNTL
      3) <installdir>\SDK\Samples\EndToEndScenarios\WoodgroveBank\ATM\CICSLU0Pgms\*.cbl to MYUSERID.HIS85.TUTORIAL.COB

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
   a) CEDA DEF GROUP(HISSAMP) TRANS(WB00) PROGRAM(WBVALUSR)
   b) CEDA DEF GROUP(HISSAMP) TRANS(WB01) PROGRAM(WBGETBAL)
   c) CEDA DEF GROUP(HISSAMP) TRANS(WB02) PROGRAM(WBGETACC)
   d) CEDA DEF GROUP(HISSAMP) TRANS(WB03) PROGRAM(WBGCASH)
   e) CEDA DEF GROUP(HISSAMP) TRANS(WB04) PROGRAM(WBXFER)      
   f) CEDA DEF GROUP(HISSAMP) TRANS(WB05) PROGRAM(WBGSTMT)   
  
Define the CICS Program resources
   a) CEDA DEF GROUP(HISSAMP) PROGRAM(WBVALUSR)  LANG(COBOL)
   b) CEDA DEF GROUP(HISSAMP) PROGRAM(WBGETBAL)  LANG(COBOL)
   c) CEDA DEF GROUP(HISSAMP) PROGRAM(WBGETACC)  LANG(COBOL)
   d) CEDA DEF GROUP(HISSAMP) PROGRAM(WBGCASH)   LANG(COBOL)
   e) CEDA DEF GROUP(HISSAMP) PROGRAM(WBXFER)    LANG(COBOL)    
   f) CEDA DEF GROUP(HISSAMP) PROGRAM(WBGSTMT)   LANG(COBOL)  

Define the CICS File resources 
   a) CEDA DEF GROUP(HISSAMP) FILE(WBCUSTDB) DSN(MYUSERID.HIS85.TUTORIAL.WBCUSTDB)
                                             ADD(YES) BR(YES) UPDATE(YES) READ(YES)
   b) CEDA DEF GROUP(HISSAMP) FILE(WBACCTDB) DSN(MYUSERID.HIS85.TUTORIAL.WBACCTDB)
                                             ADD(YES) BR(YES) UPDATE(YES) READ(YES) 
   c) CEDA DEF GROUP(HISSAMP) FILE(WBTXNDB)  DSN(MYUSERID.HIS85.TUTORIAL.WBTXNDB)
                                             ADD(YES) BR(YES) UPDATE(YES) READ(YES) 
                                              
Install the CICS Woodgrove Bank resource group
1) CEDA INSTALL GROUP(HISSAMP)

Opening and Closing the CICS VSAM Files
1) Logon to CICS
2) Clear the screen
3) To open the Woodgrove Bank VSAM Files ent the CICS command:
      CEMT S FILE(WBCUSTDB,WBACCTDB,WBTXNDB) OPE ENA
4) To close the Woodgrove Bank VSAM Files ent the CICS command:
      CEMT S FILE(WBCUSTDB,WBACCTDB,WBTXNDB) CLO DIS

