Steps to prepare the AS/400 for the Woodgrove Bank DPC  
Customer Care applications that uses Transaction Integrator

1) Prepare AS/400 for execution of the TI programs
   a) Logon to the AS/400 
   b) If the WGBANK library does not exist create it using the command
      "CRTLIB WGBANK"
   c) Create source physical files QDDSSRC, QRPGLESRC, QCLSRC, QCMDSRC and QMNUSRC 
      in the WGBANK library. From the command line use the following commands:
      1. CRTSRCPF FILE(WGBANK/QDDSSRC)   RCDLEN(92) AUT(*ALL).
      2. CRTSRCPF FILE(WGBANK/QCLSRC)    RCDLEN(92) AUT(*ALL).
      3. CRTSRCPF FILE(WGBANK/QCMDSRC)   RCDLEN(92) AUT(*ALL). 
      4. CRTSRCPF FILE(WGBANK/QMNUSRC)   RCDLEN(92) AUT(*ALL). 
      5. CRTSRCPF FILE(WGBANK/QRPGLESRC) RCDLEN(112) AUT(*ALL) 
          

2) Transfer files to the AS/400 "WGBANK" Library 
   a) Send, from the PC to the Host "WGBANK" Library the files in the directory below
      (the member name must be the same as the file name excluding the extension)
      1) Transfer RPG source code (*.rpg) files from 
         %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TransactionIntegrator\AS400\DPC
         to WGBANK/QRPGLESRC
      2) Transfer CL source code (*.cl) files from 
         %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TransactionIntegrator\AS400\DPC
         to WGBANK/QCLSRC         
      3) Transfer file and screen source code (*.pf, *.lf, *.dspf, *.menu) files from 
         %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TransactionIntegrator\AS400\DPC
         to WGBANK/QDDSSRC               
           
3)	From an AS400 command line use the following command to compile program WBSetup:
    "CRTCLPGM PGM(WGBANK/WGSETUP) SRCFILE(WGBANK/QCLSRC) AUT(*ALL)
   
4)  From an AS400 command line execute the following command to 
    compile programs, allocate and load data sets necessary to execute the 
    Woodgrove Bank application.
    "CALL WGBANK/WGSETUP PARM(WGBANK)


   

