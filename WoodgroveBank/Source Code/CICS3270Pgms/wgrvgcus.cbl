      *****************************************************************
      ** Copyright (c) Microsoft Corporation.                         * 	
      ** Licensed under the MIT license.                              * 
      **                                                              *
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      * 
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      ** THE INPUT TO THIS CICS PROGRAM IS PROVIDED THROUGH A BMS MAP *
      ** THAT IS NAMED WGRVMAP.                                       *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WGRVGCUS.
       ENVIRONMENT DIVISION.

       DATA DIVISION.

      *****************************************************************
      ** VARIABLES FOR INTERACTING WITH THE TERMINAL SESSION          *
      *****************************************************************
       WORKING-STORAGE SECTION.

       01 CUST-REC-KEY.
           05 NAME                        PIC X(30)  VALUE SPACES.

       01  CUSTOMER-RECORD.
           05 CUSTOMER-NAME               PIC X(30).
           05 CUSTOMER-SSN                PIC X(9).
           05 CUSTOMER-ADDRESS.
              10 CUSTOMER-STREET          PIC X(20).
              10 CUSTOMER-CITY            PIC X(10).
              10 CUSTOMER-STATE           PIC X(4).
              10 CUSTOMER-ZIP             PIC 9(5).
           05 CUSTOMER-PHONE              PIC X(13).
           05 CUSTOMER-ACCESS-PIN         PIC X(4).

       01 ACCT-REC-KEY.
           05 SSN                         PIC X(9)   VALUE SPACES.
           05 NUM                         PIC X(10)  VALUE SPACES.

       01  ACCOUNT-RECORD.
           05 ACCOUNT-SSN                 PIC X(9).
           05 ACCOUNT-NUMBER              PIC X(10).
           05 ACCOUNT-TYPE.
              10 ACCOUNT-TYPE-CODE        PIC X.
                 88 ACCOUNT-TYPE-CHK            VALUE 'C'.
                 88 ACCOUNT-TYPE-SAV            VALUE 'S'.
              10 ACCOUNT-TYPE-NAME        PIC X(10).
           05 ACCOUNT-AREA                PIC X(39).
           05 ACCOUNT-TYPE-CHECKING REDEFINES ACCOUNT-AREA.
              10 ACCOUNT-CHK-OD-CHG       PIC S9(3)V99   COMP-3.
              10 ACCOUNT-CHK-OD-LIMIT     PIC S9(5)V99   COMP-3.
              10 ACCOUNT-CHK-OD-LINK-ACCT PIC X(10).
              10 ACCOUNT-CHK-LAST-STMT    PIC X(10).
              10 ACCOUNT-CHK-DETAIL-ITEMS PIC S9(7)      COMP-3.
              10 ACCOUNT-CHK-BAL          PIC S9(13)V99  COMP-3.
           05 ACCOUNT-TYPE-SAVINGS  REDEFINES ACCOUNT-AREA.
              10 ACCOUNT-SAV-INT-RATE     PIC S9(1)V99   COMP-3.
              10 ACCOUNT-SAV-SVC-CHRG     PIC S9(3)V99   COMP-3.
              10 ACCOUNT-SAV-LAST-STMT    PIC X(10).
              10 ACCOUNT-SAV-DETAIL-ITEMS PIC S9(7)      COMP-3.
              10 ACCOUNT-SAV-BAL          PIC S9(13)V99  COMP-3.
              10 FILLER                   PIC X(12).

       01 TXN-REC-KEY.
           05 SSN                         PIC X(9)   VALUE SPACES.
           05 NUM                         PIC X(10)  VALUE SPACES.
           05 ITEM-NUM                    PIC S9(7)  COMP-3.

       01  TXN-DETAILS.
           05 TXN-SSN                     PIC X(9).
           05 TXN-ACCT-NUM                PIC X(10).
           05 TXN-ITEM-NUM                PIC S9(7)  COMP-3.
           05 TXN-TYPE                    PIC X.
              88 TXN-TYPE-INITIAL-BALANCE       VALUE 'B'.
              88 TXN-TYPE-CREDIT                VALUE 'C'.
              88 TXN-TYPE-DEBIT                 VALUE 'D'.
              88 TXN-TYPE-SVCCHG                VALUE 'S'.
              88 TXN-TYPE-ODCHG                 VALUE 'O'.
           05 TXN-DATE                    PIC X(10).
           05 TXN-AMOUNT                  PIC S9(13)V99  COMP-3.

       01 DONE                        PIC X       VALUE 'N'.
       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.
       01 TEMPDATA                    PIC X(1).
       01 TEMPLENG                    PIC S9(4)   COMP.
       01 PAGEN                       PIC 9(3)            VALUE 1.
       01 OPINSTR                     PIC X(52)
                VALUE 'Press <Enter> and follow with paging commands.'.

      **** COPY THE BMS MAP DEFINITION FOR CEDAR BANK
       COPY WGRVMAP.

       LINKAGE SECTION.

       PROCEDURE DIVISION.

           EXEC CICS HANDLE AID CLEAR(END-WGRVGCUS)
                                PF3(END-WGRVGCUS)
                                PF4(XFER-WGRVGBAL)
                                PF5(XFER-WGRVGACC)
                                PF7(XFER-WGRVGDET)
                                PF8(XFER-WGRVADDC)
                                PF9(XFER-WGRVADDA)
                                PF10(XFER-WGRVCUSL) END-EXEC.

           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.
           EXEC CICS SEND MAP('GCNAME') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           EXEC CICS RECEIVE MAP('GCNAME') MAPSET('WGRVMAP')
                             ASIS END-EXEC.

           MOVE LOW-VALUE TO GCHPAGNA.
           MOVE PAGEN TO GCHPAGNO.
           EXEC CICS SEND MAP('GCHEAD') MAPSET('WGRVMAP')
                          ACCUM PAGING ERASE
           END-EXEC.

           PERFORM GET-CUSTOMERS THRU GET-CUSTOMERS-EXIT.
           EXEC CICS RECEIVE INTO(TEMPDATA)
                             LENGTH(TEMPLENG) END-EXEC.

           EXEC CICS RETURN END-EXEC.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-ERROR-MSG.
           EXEC CICS SEND MAP('GCNAME') MAPSET('WGRVMAP')
                          FROM (GCNAMEO) ERASE END-EXEC.

       FORMAT-ERROR-MSG-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS.
           MOVE 'WBGC' TO GCTRANO GCNXTTRO.
           MOVE SPACES TO GCNNAMEO.
           MOVE SPACES TO GCNMSG1O.
           MOVE SPACES TO GCNMSG2O.

       SET-MAP-DEFAULTS-EXIT.
           EXIT.

       GET-CUSTOMERS.
      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
           EXEC CICS HANDLE CONDITION
                            OVERFLOW(GET-CUSTOMERS-OVERFLOW) END-EXEC.

           MOVE GCNNAMEI TO NAME OF CUST-REC-KEY.
           EXEC CICS STARTBR
                     DATASET(WBCUSTDB-DD)
                     RIDFLD(CUST-REC-KEY)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     GTEQ
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-CUSTOMERS-NOTFND-SB
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUSTOMERS-NOTFND-SB
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUSTOMERS-ENDFILE-SB
              WHEN OTHER
                 GO TO GET-CUSTOMERS-ERROR-SB
           END-EVALUATE.

       GET-CUSTOMERS-NEXT.
           EXEC CICS READNEXT
                     DATASET(WBCUSTDB-DD)
                     INTO(CUSTOMER-RECORD)
                     LENGTH(LENGTH OF CUSTOMER-RECORD)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     RIDFLD(CUST-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUSTOMERS-NOTFND
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUSTOMERS-ENDFILE
              WHEN OTHER
                 GO TO GET-CUSTOMERS-ERROR
           END-EVALUATE.

           MOVE LOW-VALUE TO GCLINEO.
           MOVE CUSTOMER-NAME TO GCLNAMEO.
           MOVE CUSTOMER-SSN  TO GCLSSNO.
           EXEC CICS SEND MAP('GCLINE') MAPSET('WGRVMAP')
                          ACCUM PAGING END-EXEC
           GO TO GET-CUSTOMERS-NEXT.

       GET-CUSTOMERS-OVERFLOW.
           EXEC CICS SEND MAP('GCFOOT') MAPSET('WGRVMAP')
                          MAPONLY ACCUM PAGING END-EXEC.
           ADD 1 TO PAGEN.
           MOVE PAGEN TO GCHPAGNO.

           EXEC CICS SEND MAP('GCHEAD') MAPSET('WGRVMAP')
                          ACCUM PAGING ERASE END-EXEC.

           EXEC CICS SEND MAP('GCLINE') MAPSET('WGRVMAP')
                          ACCUM PAGING END-EXEC.

           GO TO GET-CUSTOMERS-NEXT.

       GET-CUSTOMERS-ENDFILE.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           GO TO GET-CUSTOMERS-ENDFILE-SB.

       GET-CUSTOMERS-ENDFILE-SB.
           EXEC CICS SEND MAP('GCFINAL') MAPSET('WGRVMAP')
                          MAPONLY ACCUM PAGING END-EXEC.
           EXEC CICS SEND PAGE END-EXEC.
           EXEC CICS SEND TEXT FROM(OPINSTR)
                               LENGTH(LENGTH OF OPINSTR)
                               ERASE END-EXEC.
           GO TO GET-CUSTOMERS-EXIT.

       GET-CUSTOMERS-NOTFND.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           GO TO GET-CUSTOMERS-NOTFND-SB.

       GET-CUSTOMERS-NOTFND-SB.
           EXEC CICS SEND MAP('GCFINAL') MAPSET('WGRVMAP')
                          MAPONLY ACCUM PAGING END-EXEC.
           EXEC CICS SEND PAGE END-EXEC.
           EXEC CICS SEND TEXT FROM(OPINSTR)
                               LENGTH(LENGTH OF OPINSTR)
                               ERASE END-EXEC.
           GO TO GET-CUSTOMERS-EXIT.

       GET-CUSTOMERS-ERROR.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           GO TO GET-CUSTOMERS-ERROR-SB.

       GET-CUSTOMERS-ERROR-SB.
           EXEC CICS HANDLE CONDITION ERROR END-EXEC.
           EXEC CICS PURGE MESSAGE END-EXEC.
           EXEC CICS ABEND ABCODE('WBER') END-EXEC.

       GET-CUSTOMERS-EXIT.
           EXIT.

       XFER-WGRVGBAL.
           EXEC CICS XCTL PROGRAM('WGRVGBAL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVGACC.
           EXEC CICS XCTL PROGRAM('WGRVGACC') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVGDET.
           EXEC CICS XCTL PROGRAM('WGRVGDET') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVADDC.
           EXEC CICS XCTL PROGRAM('WGRVADDC') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVADDA.
           EXEC CICS XCTL PROGRAM('WGRVADDA') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVCUSL.
           EXEC CICS XCTL PROGRAM('WGRVCUSL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVGCUS.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVGCUS-EXIT.
           EXIT.
