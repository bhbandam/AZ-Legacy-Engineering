Steps to prepare CICS on the mainframe for the Woodgrove Bank CICS 3270 Application.

Prepare CICS for execution of the 3270 programs
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
      (the member name must be the same as the file name, excluding the extension)
      1) %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\MainframeJob                       to MYUSERID.HIS85.TUTORIAL.CNTL
      2) %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\3270Application\CICS3270Pgms\*.lkd to MYUSERID.HIS85.TUTORIAL.LKDCNTL
      3) %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\3270Application\CICS3270Pgm\*.cbl  to MYUSERID.HIS85.TUTORIAL.COB
      4) %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\3270Application\CICS3270Pgm\*.bms  to MYUSERID.HIS85.TUTORIAL.MAPS   

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
   a) CEDA DEF GROUP(HISSAMP) TRANS(WBAA) PROGRAM(WGRVADDA)
   b) CEDA DEF GROUP(HISSAMP) TRANS(WBAC) PROGRAM(WGRVADDC)
   c) CEDA DEF GROUP(HISSAMP) TRANS(WBGA) PROGRAM(WGRVGACC)
   d) CEDA DEF GROUP(HISSAMP) TRANS(WBGB) PROGRAM(WGRVGBAL)
   e) CEDA DEF GROUP(HISSAMP) TRANS(WBGC) PROGRAM(WGRVGCUS)
   f) CEDA DEF GROUP(HISSAMP) TRANS(WBGD) PROGRAM(WGRVGDET)
   g) CEDA DEF GROUP(HISSAMP) TRANS(WBCL) PROGRAM(WGRVCUSL)
  
Define the CICS Program resources
   a) CEDA DEF GROUP(HISSAMP) PROGRAM(WGRVADDA)  LANG(COBOL)
   b) CEDA DEF GROUP(HISSAMP) PROGRAM(WGRVADDC)  LANG(COBOL)
   c) CEDA DEF GROUP(HISSAMP) PROGRAM(WGRVGACC)  LANG(COBOL)
   d) CEDA DEF GROUP(HISSAMP) PROGRAM(WGRVGBAL)  LANG(COBOL)
   e) CEDA DEF GROUP(HISSAMP) PROGRAM(WGRVGCUS)  LANG(COBOL)
   f) CEDA DEF GROUP(HISSAMP) PROGRAM(WGRVGDET)  LANG(COBOL) 
   g) CEDA DEF GROUP(HISSAMP) PROGRAM(WGRVCUSL)  LANG(COBOL) 

Define the CICS BMS Map resources   
   a) CEDA DEF GROUP(HISSAMP) MAPSET(WGRVMAP)

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

