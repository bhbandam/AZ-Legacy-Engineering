Steps to prepare the VTAM on the mainframe for the Woodgrove Bank CICS, ATM and 
Customer Care applications that use LU0 and LU2 protocols.

Prepare VTAM for LU0 and LU2 access
1) The following instructions use names that may not be valid for your installation.
   Check with your mainframe system administrator for appropriate names
   a. SNA LU6.2 Name: Lxxxnn00
   b. SNA LU2 Names: Lxxxnn02 - Lxxxnn07
   c. SNA LU0 Names: Lxxxnn08
   d. Independent LU6.2 unsecured mode name: PA62TKNU
   e. VTAM USSTAB: USSSMS
   
2) Add the following Node definition to VTAM
      WGRVBnn  VBUILD TYPE=SWNET
      Lxxxnn   PU    PUTYPE=2,ADDR=2D,                                 X
                     MAXDATA=521,MODETAB=ISTINCMS,                     X
                     IDBLK=05D,IDNUM=A002D
      Lxxxnn00 LU    LOCADDR=0,RESSCB=10,DLOGMOD=PA62TKNU
      Lxxxnn02 LU    LOCADDR=02,DLOGMOD=SNX32702,USSTAB=USSSMS                      
      Lxxxnn03 LU    LOCADDR=03,DLOGMOD=SNX32702,USSTAB=USSSMS                      
      Lxxxnn04 LU    LOCADDR=04,DLOGMOD=SNX32702,USSTAB=USSSMS                      
      Lxxxnn05 LU    LOCADDR=05,DLOGMOD=SNX32702,USSTAB=USSSMS                      
      Lxxxnn06 LU    LOCADDR=06,DLOGMOD=SNX32702,USSTAB=USSSMS                      
      Lxxxnn07 LU    LOCADDR=07,DLOGMOD=SNX32702,USSTAB=USSSMS                      
      Lxxxnn08 LU    LOCADDR=08,MODETAB=ISTINCMN,DLOGMOD=IBM3600