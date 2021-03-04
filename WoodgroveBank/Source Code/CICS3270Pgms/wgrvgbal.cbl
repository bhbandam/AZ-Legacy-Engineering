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
       PROGRAM-ID. WGRVGBAL.
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

       01 HW-LENGTH                   PIC 9(4)    COMP.
       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 DONE                        PIC X               VALUE 'N'.
       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.

       01 LOG-MSG.
          05 LOG-ID                         PIC X(7)   VALUE 'TASK #'.
          05 TASK-NUMBER                    PIC 9(7).
          05 FILLER                         PIC X      VALUE SPACE.
          05 LOG-MSG-BUFFER                 PIC X(80)  VALUE SPACES.

       01 ENABLE-LOGGING                    PIC X          VALUE 'Y'.
          88 LOGGING-IS-ENABLED                            VALUE 'Y'.
          88 LOGGING-IS-DISABLED                           VALUE 'N'.

      **** COPY THE BMS MAP DEFINITION FOR CEDAR BANK
       COPY WGRVMAP.

       LINKAGE SECTION.

       PROCEDURE DIVISION.

           EXEC CICS HANDLE AID CLEAR(END-WGRVGBAL)
                                PF3(END-WGRVGBAL)
                                PF5(XFER-WGRVGACC)
                                PF6(XFER-WGRVGCUS)
                                PF7(XFER-WGRVGDET)
                                PF8(XFER-WGRVADDC)
                                PF9(XFER-WGRVADDA)
                                PF10(XFER-WGRVCUSL) END-EXEC.

           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.
           EXEC CICS SEND MAP('WGRVMGB') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           PERFORM UNTIL DONE = 'Y'
              EXEC CICS RECEIVE MAP('WGRVMGB') MAPSET('WGRVMAP')
                                ASIS END-EXEC

              MOVE 0 TO RET-CODE
              PERFORM VALIDATE-INPUT THRU VALIDATE-INPUT-EXIT
              IF RET-CODE = 0
                 PERFORM GET-CUST-SSN THRU GET-CUST-SSN-EXIT
              END-IF
              IF RET-CODE = 0
                 PERFORM GET-ACCT-BAL THRU GET-ACCT-BAL-EXIT
              END-IF

              IF RET-CODE = 0 THEN
                 PERFORM FORMAT-GOOD-MSG THRU FORMAT-GOOD-MSG-EXIT
              ELSE
                 PERFORM FORMAT-ERROR-MSG THRU FORMAT-ERROR-MSG-EXIT
              END-IF
           END-PERFORM.

           EXEC CICS RETURN END-EXEC.

      **************************************************************
      ** FORMAT A GOOD MESSAGE TO SEND TO THE TERMINAL USER       **
      **************************************************************
       FORMAT-GOOD-MSG.
           EVALUATE ACCOUNT-TYPE-CODE
              WHEN 'C'
                 MOVE ACCOUNT-CHK-BAL TO ACCTBALO
              WHEN 'S'
                 MOVE ACCOUNT-SAV-BAL TO ACCTBALO
              WHEN OTHER
                 MOVE ZERO TO ACCTBALO
           END-EVALUATE.

           EXEC CICS SEND MAP('WGRVMGB') MAPSET('WGRVMAP')
                          FROM (WGRVMGBO) ERASE END-EXEC.

       FORMAT-GOOD-MSG-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-ERROR-MSG.
           EXEC CICS SEND MAP('WGRVMGB') MAPSET('WGRVMAP')
                          FROM (WGRVMGBO) ERASE END-EXEC.

       FORMAT-ERROR-MSG-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE MAP                      **
      **************************************************************
       VALIDATE-INPUT.
           IF NAMEL = 0 OR NAMEI = SPACES
               MOVE 'Name is invalid' TO GBMSG1O
               MOVE 1 TO RET-CODE
               GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE NAMEI TO NAME OF CUST-REC-KEY.

           IF ACCTNUML = 0 OR ACCTNUMI = SPACES
               MOVE 'Account number is invalid' TO GBMSG1O
               MOVE 1 TO RET-CODE
               GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACCTNUMI TO NUM OF ACCT-REC-KEY.

       VALIDATE-INPUT-EXIT.
           EXIT.

       GET-CUST-SSN.
      **************************************************
      *    READ THE CUSTOMER SSN FROM THE VSAM DATA SET
      **************************************************
           EXEC CICS READ
                     DATASET(WBCUSTDB-DD)
                     INTO(CUSTOMER-RECORD)
                     LENGTH(LENGTH OF CUSTOMER-RECORD)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     RIDFLD(CUST-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 MOVE CUSTOMER-SSN TO SSN OF ACCT-REC-KEY
                 MOVE 0 TO RET-CODE
                 MOVE SPACES TO GBMSG1O
                 GO TO GET-CUST-SSN-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO GBMSG1O
                 MOVE 1 TO RET-CODE
                 GO TO GET-CUST-SSN-EXIT
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN OTHER
                 MOVE 'I/O error on Customer file' TO GBMSG1O
                 MOVE RESP-CODE TO EDIT-NUM
                 STRING 'Response code=' DELIMITED SIZE
                        EDIT-NUM DELIMITED SIZE
                        INTO GBMSG2O
                 END-STRING
                 MOVE 3 TO RET-CODE
                 GO TO GET-CUST-SSN-EXIT
           END-EVALUATE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-NOTFND.
           MOVE 'Customer name not found' TO GBMSG1O.
           MOVE 2 TO RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-EXIT.
           EXIT.

       GET-ACCT-BAL.
      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
           EXEC CICS READ
                     DATASET(WBACCTDB-DD)
                     INTO(ACCOUNT-RECORD)
                     LENGTH(LENGTH OF ACCOUNT-RECORD)
                     KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                     RIDFLD(ACCT-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 IF ACCOUNT-NUMBER NOT = ACCTNUMI THEN
                    GO TO GET-ACCT-BAL-NOTFND
                 END-IF
                 MOVE 0 TO RET-CODE
                 MOVE SPACES TO GBMSG1O
                 GO TO GET-ACCT-BAL-EXIT
              WHEN DFHRESP(NOTFND)
                 GO TO GET-ACCT-BAL-NOTFND
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Account file not open' TO GBMSG1O
                 MOVE 2 TO RET-CODE
                 GO TO GET-ACCT-BAL-EXIT
              WHEN DFHRESP(ENDFILE)
                 MOVE 'Account could not be found' TO GBMSG1O
                 MOVE 1 TO RET-CODE
                 GO TO GET-ACCT-BAL-EXIT
              WHEN OTHER
                 GO TO GET-ACCT-BAL-ERROR
           END-EVALUATE.
           GO TO GET-ACCT-BAL-EXIT.

       GET-ACCT-BAL-NOTFND.
           MOVE 'Name / account could not be found' TO GBMSG1O.
           MOVE 2 TO RET-CODE.
           GO TO GET-ACCT-BAL-EXIT.

       GET-ACCT-BAL-ERROR.
           MOVE 'I/O error reading the Account VSAM file' TO GBMSG1O.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Response code=' DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO GBMSG2O
           END-STRING.
           MOVE 3 TO RET-CODE.
           EXEC CICS HANDLE CONDITION ENDFILE ERROR NOTFND END-EXEC.
           GO TO GET-ACCT-BAL-EXIT.

       GET-ACCT-BAL-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS.
           MOVE 'WBGB' TO GBTRANO.
           MOVE SPACES TO NAMEO.
           MOVE SPACES TO ACCTNUMO.
           MOVE 0      TO ACCTBALO.
           MOVE SPACES TO GBMSG1O.
           MOVE SPACES TO GBMSG2O.

       SET-MAP-DEFAULTS-EXIT.
           EXIT.

      *****************************************************************
      *  WRITE A MESSAGE OUT TO A CICS TRANSIENT DATA QUEUE           *
      *****************************************************************
       WRITE-LOG-MSG.
           IF LOGGING-IS-ENABLED THEN
              MOVE LENGTH OF LOG-MSG TO HW-LENGTH
              MOVE EIBTASKN          TO TASK-NUMBER
              EXEC CICS WRITEQ TD QUEUE('CSMT')
                                  FROM(LOG-MSG)
                                  LENGTH(HW-LENGTH)
                                  NOHANDLE
                                  END-EXEC
           END-IF.

       WRITE-LOG-MSG-EXIT.
           EXIT.

       XFER-WGRVGACC.
           EXEC CICS XCTL PROGRAM('WGRVGACC') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVGCUS.
           EXEC CICS XCTL PROGRAM('WGRVGCUS') END-EXEC.
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

       END-WGRVGBAL.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVGBAL-EXIT.
           EXIT.
