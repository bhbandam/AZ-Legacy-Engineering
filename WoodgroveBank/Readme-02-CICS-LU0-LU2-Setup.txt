Steps to prepare CICS on the mainframe for the Woodgrove Bank CICS ATM and 
Customer Care applications that use LU0 and LU2 protocols. 

Prepare CICS for LU0 and LU2 access
1) The following instructions use names that may not be valid for your installation.
   Check with your mainframe system administrator for appropriate name
   a. SNA LU6.2 Name: Lxxxnn00
   b. SNA LU2 Names: Lxxxnn02 - Lxxxnn07
   c. SNA LU0 Names: Lxxxnn08
   d. See Readme-1-VTAM-LU0-LU2-Setup.txt

2) You will need to define a Terminal Control Table module for the SLUP device for each CICS 
   region where you want to install the Woodgrove Bank samples.  You should only have to do this
   step once for any CICS sharing the TCT load library which is picked up in the SIT startup member
   using the TCT= parameter.

   You should add your standard JobCard information to the JCL provided below and make any updates
   as required to excute the JCL correctly.  The PROC can be located in SDFHPROC library sent with
   with the CICS installation software.  

      //* THIS JCL CREATES THE TCT TABLE ENTRY FOR THE LDC
      //ASMTAB  EXEC PROC=DFHAUPLE,NAME='xxxx.CICS.SDFHLOAD'
      //ASSEM.SYSUT1 DD   *
               PRINT NOGEN,NODATA
               DFHTCT TYPE=INITIAL,ACCMETH=VTAM,SUFFIX=TI
      POCLDCT1 DFHTCT TYPE=LDC,LOCAL=INITIAL
      LDC2     DFHTCT TYPE=LDCLIST,                                    X
                     LDC=(DS,JP,PB=5,LP,MS)
               DFHTCT TYPE=LDC,LDC=(DS=1),DVC=3604,                    X
                     PGESIZE=(6,40),PGESTAT=PAGE
               DFHTCT TYPE=LDC,LDC=SYSTEM
               DFHTCT TYPE=FINAL
               END

3) Using the CICS Resource Definition Utility create the RDO
   Entries for the CSD and define a TYPETERM with the following parameters
             TYPETERM = T3600
             LDClist  = LDC2     Note: LDC label defined in the TCT assemble in step 2
             DEVICE   = 3600
             SENDSIZE = 224
             RECEIVESIZE = 256
             LOGMODE  = IBM3600  Note: As define on the LU definition in the PU               

4) Using the CICS Resource Definition Utility create the RDO
   Entries for the Terminal Entry in the CSD
             TYPETERM = T3600
             NETNAME  = Lxxxnn08 Note: LU as defined in the VTAM PU definition
             MODENAME = IBM3600


