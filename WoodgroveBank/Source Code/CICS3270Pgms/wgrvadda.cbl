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
       PROGRAM-ID. WGRVADDA.
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

       01 CURRENT-DATE.
          05 CURRENT-DATE-MM              PIC XX.
          05 FILLER                       PIC X.
          05 CURRENT-DATE-DD              PIC XX.
          05 FILLER                       PIC X.
          05 CURRENT-DATE-YYYY            PIC 9999.

       01 TEMP-CUST-KEY                   PIC X(30).
       01 TEMP-CUST-REC.
          05 FILLER                       PIC X(30).
          05 TEMP-CUST-SSN                PIC X(9).
          05 FILLER                       PIC X(61).

       01  TEMP-ACCT-KEY.
           05 SSN                         PIC X(9).
           05 NUM                         PIC X(10).
       01  TEMP-ACCT-REC.
           05 TEMP-ACCT-SSN               PIC X(9).
           05 TEMP-ACCT-NUM               PIC X(10).
           05 FILLER                      PIC X(11).
           05 ACCOUNT-AREA                PIC X(39).

       01 ACCT-NUMBER-NUMERIC         PIC 9(10).
       01 UTIME                       PIC S9(15) COMP-3.
       01 FILLER REDEFINES UTIME.
          05 FILLER                   PIC X(3).
          05 UTIME-X                  PIC S9(9)   COMP-3.
       01 UTIME-YEAR                  PIC S9(8)   COMP VALUE 0.
       01 HW-LENGTH                   PIC 9(4)    COMP.
       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 DONE-CHK                    PIC X               VALUE 'N'.
       01 DONE-SAV                    PIC X               VALUE 'N'.
       01 DONE                        PIC X               VALUE 'N'.
       01 GOT-ACCT                    PIC X               VALUE 'N'.

       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.
       01 EBCDIC-NUM-LEN              PIC S9(4)     COMP.
       01 EBCDIC-NUM                  PIC X(16)     JUST RIGHT.
       01 PACKED-NUM                  PIC S9(13)V99 COMP-3.
       01 PACKED-NUM-CENTS            PIC S99       COMP-3.
       01 I                           PIC S9(4)     COMP.
       01 CENTS-DIGITS                PIC S9(4)     COMP.
       01 DOLLAR-DIGITS               PIC S9(4)     COMP.
       01 EBCDIC-DIGIT                PIC 9.
       01 DOING-CENTS                 PIC X.
       01 EDIT-PACKED-NUM             PIC 9,999,999,999,999.99.
       01 DONE-WITH-WHITE-SPACE       PIC X.

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

           EXEC CICS HANDLE AID CLEAR(END-WGRVADDA)
                                PF3(END-WGRVADDA)
                                PF4(XFER-WGRVGBAL)
                                PF5(XFER-WGRVGACC)
                                PF6(XFER-WGRVGCUS)
                                PF7(XFER-WGRVGDET)
                                PF8(XFER-WGRVADDC)
                                PF10(XFER-WGRVCUSL) END-EXEC.

           PERFORM GET-DATE THRU GET-DATE-EXIT.

           PERFORM SET-MAP-DEFAULTS-AAM THRU SET-MAP-DEFAULTS-AAM-EXIT.
           EXEC CICS SEND MAP('WGRVAAM') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           PERFORM UNTIL DONE = 'Y'
              EXEC CICS RECEIVE MAP('WGRVAAM') MAPSET('WGRVMAP')
                                ASIS END-EXEC

              MOVE 0 TO RET-CODE
              PERFORM VALIDATE-INPUT-MAIN THRU VALIDATE-INPUT-MAIN-EXIT

              IF RET-CODE = 0
                 EVALUATE AAMTYPEI
                    WHEN 'C'
                       PERFORM ADD-CHECKING THRU ADD-CHECKING-EXIT
                    WHEN 'S'
                       PERFORM ADD-SAVINGS THRU ADD-SAVINGS-EXIT
                 END-EVALUATE
              END-IF

              IF RET-CODE = 0 THEN
                 PERFORM FORMAT-GOOD-MAIN THRU FORMAT-GOOD-MAIN-EXIT
              ELSE
                 PERFORM FORMAT-BAD-MAIN THRU FORMAT-BAD-MAIN-EXIT
              END-IF
           END-PERFORM.

           EXEC CICS RETURN END-EXEC.

      **************************************************************
      ** FORMAT A GOOD MESSAGE TO SEND TO THE TERMINAL USER       **
      **************************************************************
       FORMAT-GOOD-MAIN.
           PERFORM SET-MAP-DEFAULTS-AAM THRU SET-MAP-DEFAULTS-AAM-EXIT.

           MOVE 'Account successfully added' TO AAMMSG1O.
           MOVE SPACES TO AAMMSG2O.
           STRING ACCOUNT-TYPE-NAME DELIMITED SPACE
                  ' ' DELIMITED SIZE
                  ACCOUNT-NUMBER DELIMITED SIZE
                  ' ' DELIMITED SIZE
                  CUSTOMER-NAME  DELIMITED SIZE
                  INTO AAMMSG2O
           END-STRING.

           EXEC CICS SEND MAP('WGRVAAM') MAPSET('WGRVMAP')
                          FROM (WGRVAAMO) ERASE END-EXEC.

       FORMAT-GOOD-MAIN-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-BAD-MAIN.
           EXEC CICS SEND MAP('WGRVAAM') MAPSET('WGRVMAP')
                          FROM (WGRVAAMO) ERASE END-EXEC.

       FORMAT-BAD-MAIN-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-BAD-CHK.
           EXEC CICS SEND MAP('WGRVAAC') MAPSET('WGRVMAP')
                          FROM (WGRVAACO) ERASE END-EXEC.

       FORMAT-BAD-CHK-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-BAD-SAV.
           EXEC CICS SEND MAP('WGRVAAS') MAPSET('WGRVMAP')
                          FROM (WGRVAASO) ERASE END-EXEC.

       FORMAT-BAD-SAV-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE MAP                      **
      **************************************************************
       VALIDATE-INPUT-MAIN.
           IF AAMNAMEL = 0 OR AAMNAMEI = SPACES THEN
              MOVE 'Name must not be blank' TO AAMMSG1O
              MOVE SPACES TO AAMMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-MAIN-EXIT
           END-IF.
           MOVE AAMNAMEI(1:AAMNAMEL) TO NAME OF CUST-REC-KEY
                                        CUSTOMER-NAME.

           PERFORM VALIDATE-CUST-NAME THRU VALIDATE-CUST-NAME-EXIT.
           IF RET-CODE NOT = 0 THEN
              GO TO VALIDATE-INPUT-MAIN-EXIT
           END-IF.

           MOVE FUNCTION UPPER-CASE(AAMTYPEI) TO AAMTYPEI.
           IF AAMTYPEI NOT = 'C' AND AAMTYPEI NOT = 'S' THEN
              MOVE 'Account type must be "C" or "S"' TO AAMMSG1O
              MOVE SPACES TO AAMMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-MAIN-EXIT
           END-IF.

       VALIDATE-INPUT-MAIN-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE CUSTOMER NAME FROM THE MAIN MENU            **
      **************************************************************
       VALIDATE-CUST-NAME.
           EXEC CICS READ
                     DATASET(WBCUSTDB-DD)
                     INTO(CUSTOMER-RECORD)
                     LENGTH(LENGTH OF CUSTOMER-RECORD)
                     RIDFLD(CUST-REC-KEY)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 GO TO VALIDATE-CUST-NAME-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO AAMMSG1O
                 MOVE SPACES TO AAMMSG2O
                 MOVE 1 TO RET-CODE
                 GO TO VALIDATE-CUST-NAME-EXIT
              WHEN DFHRESP(NOTFND)
                 MOVE 'Customer name not found' TO AAMMSG1O
                 MOVE SPACES TO AAMMSG2O
                 MOVE 2 TO RET-CODE
                 GO TO VALIDATE-CUST-NAME-EXIT
              WHEN OTHER
                 GO TO VALIDATE-CUST-NAME-ERROR
           END-EVALUATE.
           GO TO VALIDATE-CUST-NAME-EXIT.

       VALIDATE-CUST-NAME-ERROR.
           MOVE SPACES TO LOG-MSG-BUFFER AAMMSG1O.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Error reading Customer file, response code='
                              DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO AAMMSG1O
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE AAMMSG1O TO LOG-MSG-BUFFER.
           MOVE SPACES TO AAMMSG2O.
           MOVE 2 TO RET-CODE.
           GO TO VALIDATE-CUST-NAME-EXIT.

       VALIDATE-CUST-NAME-EXIT.
           EXIT.

      **************************************************************
      ** ADD A CHECKING ACCOUNT RECORD                            **
      **************************************************************
       ADD-CHECKING.
           PERFORM GET-NEW-ACCT-NUM THRU GET-NEW-ACCT-NUM-EXIT.
           PERFORM SET-MAP-DEFAULTS-AAC THRU SET-MAP-DEFAULTS-AAC-EXIT.
           MOVE CUSTOMER-NAME       TO AACNAMEO.
           MOVE CUSTOMER-SSN        TO AACSSNO.
           MOVE ACCT-NUMBER-NUMERIC TO AACNUMO.

           EXEC CICS SEND MAP('WGRVAAC') MAPSET('WGRVMAP')
                          FROM(WGRVAACO) ERASE END-EXEC.

           MOVE 'N' TO DONE-CHK.
           PERFORM UNTIL DONE-CHK = 'Y'
              EXEC CICS RECEIVE MAP('WGRVAAC') MAPSET('WGRVMAP')
                                ASIS END-EXEC

              MOVE 0 TO RET-CODE
              INITIALIZE ACCOUNT-RECORD
              PERFORM VALIDATE-INPUT-CHK THRU VALIDATE-INPUT-CHK-EXIT

              IF RET-CODE = 0 THEN
                 MOVE 'Y'          TO DONE-CHK
                 MOVE 'C'          TO ACCOUNT-TYPE-CODE
                 MOVE 'Checking'   TO ACCOUNT-TYPE-NAME
                 MOVE 1            TO ACCOUNT-CHK-DETAIL-ITEMS
                 MOVE CURRENT-DATE TO ACCOUNT-CHK-LAST-STMT
                 PERFORM ADD-ACCT THRU ADD-ACCT-EXIT
                 IF RET-CODE = 0 THEN
                    PERFORM ADD-TX-DETAIL THRU ADD-TX-DETAIL-EXIT
                 END-IF
                 IF RET-CODE = 0 THEN
                    MOVE SPACES TO AACMSG1O
                    MOVE RESP-CODE TO EDIT-NUM
                    STRING 'Add checking account to vsam failed, RC='
                           DELIMITED SIZE
                           EDIT-NUM DELIMITED SIZE
                           INTO AACMSG1O
                   END-STRING
                   MOVE SPACES TO AACMSG2O
                   GO TO ADD-CHECKING-EXIT
                 END-IF
                 GO TO ADD-CHECKING-EXIT
              ELSE
                 PERFORM FORMAT-BAD-CHK THRU FORMAT-BAD-CHK-EXIT
              END-IF
           END-PERFORM.

       ADD-CHECKING-EXIT.
           EXIT.

      **************************************************
      *    ADD AN ACCOUNT RECORD
      **************************************************
       ADD-ACCT.
           MOVE ACCOUNT-SSN TO SSN OF ACCT-REC-KEY.
           MOVE ACCOUNT-NUMBER TO NUM OF ACCT-REC-KEY.
           EXEC CICS WRITE
                     DATASET(WBACCTDB-DD)
                     FROM(ACCOUNT-RECORD)
                     LENGTH(LENGTH OF ACCOUNT-RECORD)
                     KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                     RIDFLD(ACCT-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 MOVE 0 TO RET-CODE
              WHEN DFHRESP(NOTOPEN)
                 MOVE 1 TO RET-CODE
              WHEN DFHRESP(DUPREC)
                 MOVE 2 TO RET-CODE
              WHEN DFHRESP(DUPKEY)
                 MOVE 3 TO RET-CODE
              WHEN OTHER
                 MOVE 4 TO RET-CODE
           END-EVALUATE.

           GO TO ADD-ACCT-EXIT.

       ADD-ACCT-EXIT.
           EXIT.

      **************************************************
      *    ADD THE TRANSACTION DETAIL TO THE VSAM DATA SET
      **************************************************
       ADD-TX-DETAIL.
           MOVE CURRENT-DATE   TO TXN-DATE.
           MOVE ACCOUNT-SSN    TO TXN-SSN.
           MOVE ACCOUNT-NUMBER TO TXN-ACCT-NUM.
           MOVE 1              TO TXN-ITEM-NUM
           MOVE 'B'            TO TXN-TYPE.
           EVALUATE ACCOUNT-TYPE-CODE
              WHEN 'C'
                 MOVE ACCOUNT-CHK-BAL TO TXN-AMOUNT
              WHEN 'S'
                 MOVE ACCOUNT-SAV-BAL TO TXN-AMOUNT
           END-EVALUATE.

           MOVE TXN-SSN      TO SSN      OF TXN-REC-KEY.
           MOVE TXN-ACCT-NUM TO NUM      OF TXN-REC-KEY.
           MOVE TXN-ITEM-NUM TO ITEM-NUM OF TXN-REC-KEY

           EXEC CICS WRITE
                     DATASET(WBTXNDB-DD)
                     FROM(TXN-DETAILS)
                     LENGTH(LENGTH OF TXN-DETAILS)
                     KEYLENGTH(LENGTH OF TXN-REC-KEY)
                     RIDFLD(TXN-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN DFHRESP(DUPREC)
                 MOVE 1 TO RET-CODE
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN DFHRESP(DUPKEY)
                 MOVE 2 TO RET-CODE
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 3 TO RET-CODE
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN OTHER
                 GO TO ADD-TX-DETAIL-ERROR
           END-EVALUATE.

           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-ERROR.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Error writing Txn Detail, response code='
                              DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 3 TO RET-CODE.
           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE CHECKING DETAILS MAP     **
      **************************************************************
       VALIDATE-INPUT-CHK.
           MOVE AACSSNI TO ACCOUNT-SSN.
           MOVE AACNUMI TO ACCOUNT-NUMBER.

       VALIDATE-AACODCI.
           IF AACODCL = 0 OR AACODCI = SPACES THEN
              MOVE 'Overdraft charge must not be blank' TO AACMSG1O
              MOVE SPACES TO AACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CHK-EXIT
           END-IF.

           MOVE AACODCI TO EBCDIC-NUM.
           PERFORM EBCDIC-TO-PACKED THRU EBCDIC-TO-PACKED-EXIT.
           IF RET-CODE NOT = 0 THEN
              MOVE 'Overdraft charge must be numeric' TO AACMSG1O
              MOVE SPACES TO AACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CHK-EXIT
           END-IF.
           MOVE PACKED-NUM TO ACCOUNT-CHK-OD-CHG.

       VALIDATE-AACODLI.
           IF AACODLL = 0 OR AACODLI = SPACES THEN
              MOVE 'Overdraft limit must not be blank' TO AACMSG1O
              MOVE SPACES TO AACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CHK-EXIT
           END-IF.

           MOVE AACODLI TO EBCDIC-NUM.
           PERFORM EBCDIC-TO-PACKED THRU EBCDIC-TO-PACKED-EXIT.
           IF RET-CODE NOT = 0 THEN
              MOVE 'Overdraft limit must be numeric' TO AACMSG1O
              MOVE SPACES TO AACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CHK-EXIT
           END-IF.
           MOVE PACKED-NUM TO ACCOUNT-CHK-OD-LIMIT.

       VALIDATE-AACODLAI.
           IF AACODLAL NOT = 0 AND AACODLAI NOT = SPACES THEN
              MOVE AACODLAI TO NUM OF TEMP-ACCT-KEY
              MOVE AACSSNI  TO SSN OF TEMP-ACCT-KEY

              EXEC CICS READ
                        DATASET(WBACCTDB-DD)
                        INTO(TEMP-ACCT-REC)
                        LENGTH(LENGTH OF TEMP-ACCT-REC)
                        RIDFLD(TEMP-ACCT-KEY)
                        KEYLENGTH(LENGTH OF TEMP-ACCT-KEY)
                        RESP(RESP-CODE)
              END-EXEC

              IF RESP-CODE NOT = 0 THEN
                 MOVE 'Linked account is not valid' TO AACMSG1O
                 MOVE SPACES TO AACMSG2O
                 MOVE 1 TO RET-CODE
                 GO TO VALIDATE-INPUT-CHK-EXIT
              END-IF
              MOVE AACODLAI TO ACCOUNT-CHK-OD-LINK-ACCT
           ELSE
              MOVE SPACES TO ACCOUNT-CHK-OD-LINK-ACCT
           END-IF.

       VALIDATE-AACIBALI.
           IF AACIBALL = 0 OR AACIBALI = SPACES THEN
              MOVE 'Initial balance must not be blank' TO AACMSG1O
              MOVE SPACES TO AACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CHK-EXIT
           END-IF.

           MOVE AACIBALI TO EBCDIC-NUM.
           PERFORM EBCDIC-TO-PACKED THRU EBCDIC-TO-PACKED-EXIT.
           IF RET-CODE NOT = 0 THEN
              MOVE 'Initial balance must be numeric' TO AACMSG1O
              MOVE SPACES TO AACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CHK-EXIT
           END-IF.
           MOVE PACKED-NUM TO ACCOUNT-CHK-BAL.

       VALIDATE-INPUT-CHK-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE SAVINGS DETAILS MAP      **
      **************************************************************
       VALIDATE-INPUT-SAV.
           MOVE AASNUMI TO ACCOUNT-NUMBER.
           MOVE AASSSNI TO ACCOUNT-SSN.

       VALIDATE-AASINTRI.
           IF AASINTRL = 0 OR AASINTRI = SPACES THEN
              MOVE 'Interest Rate must not be blank' TO AASMSG1O
              MOVE SPACES TO AASMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-SAV-EXIT
           END-IF.

           MOVE AASINTRI TO EBCDIC-NUM.
           PERFORM EBCDIC-TO-PACKED THRU EBCDIC-TO-PACKED-EXIT.
           IF RET-CODE NOT = 0 THEN
              MOVE 'Interest Rate must be numeric' TO AASMSG1O
              MOVE SPACES TO AASMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-SAV-EXIT
           END-IF.
           MOVE PACKED-NUM TO ACCOUNT-SAV-INT-RATE.

       VALIDATE-AASSCHGI.
           IF AASSCHGL = 0 OR AASSCHGI = SPACES THEN
              MOVE 'Service Charge must not be blank' TO AASMSG1O
              MOVE SPACES TO AASMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-SAV-EXIT
           END-IF.

           MOVE AASSCHGI TO EBCDIC-NUM.
           PERFORM EBCDIC-TO-PACKED THRU EBCDIC-TO-PACKED-EXIT.
           IF RET-CODE NOT = 0 THEN
              MOVE 'Service Charge must be numeric' TO AASMSG1O
              MOVE SPACES TO AASMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-SAV-EXIT
           END-IF.
           MOVE PACKED-NUM TO ACCOUNT-SAV-SVC-CHRG.

       VALIDATE-AASIBALI.
           IF AASIBALL = 0 OR AASIBALI = SPACES THEN
              MOVE 'Initial balance must not be blank' TO AASMSG1O
              MOVE SPACES TO AASMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-SAV-EXIT
           END-IF.

           MOVE AASIBALI TO EBCDIC-NUM.
           PERFORM EBCDIC-TO-PACKED THRU EBCDIC-TO-PACKED-EXIT.
           IF RET-CODE NOT = 0 THEN
              MOVE 'Initial balance must be numeric' TO AASMSG1O
              MOVE SPACES TO AASMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-SAV-EXIT
           END-IF.
           MOVE PACKED-NUM TO ACCOUNT-SAV-BAL.

       VALIDATE-INPUT-SAV-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE AND CONVERT A DISPLAY NUMERIC TO PACKED DECIMAL **
      **************************************************************
       EBCDIC-TO-PACKED.
           MOVE 'N' TO DOING-CENTS DONE-WITH-WHITE-SPACE.
           MOVE 0 TO CENTS-DIGITS DOLLAR-DIGITS
                     PACKED-NUM PACKED-NUM-CENTS.
           MOVE LENGTH OF EBCDIC-NUM TO EBCDIC-NUM-LEN.
           PERFORM VARYING I FROM LENGTH OF EBCDIC-NUM BY -1
                   UNTIL I <= 0
              IF EBCDIC-NUM(I:1) NOT = SPACE THEN
                 MOVE I TO EBCDIC-NUM-LEN
                 MOVE 0 TO I
              END-IF
           END-PERFORM.

           PERFORM VARYING I FROM 1 BY 1
                   UNTIL I > EBCDIC-NUM-LEN
              EVALUATE EBCDIC-NUM(I:1)
                 WHEN ','
                 WHEN ' '
                    IF DONE-WITH-WHITE-SPACE = 'Y' THEN
                       MOVE 1 TO RET-CODE
                       GO TO EBCDIC-TO-PACKED-EXIT
                    END-IF
                 WHEN '.'
                    MOVE 'Y' TO DOING-CENTS
                    MOVE 'Y' TO DONE-WITH-WHITE-SPACE
                 WHEN OTHER
                    IF EBCDIC-NUM(I:1) IS NOT NUMERIC THEN
                       MOVE 1 TO RET-CODE
                       GO TO EBCDIC-TO-PACKED-EXIT
                    END-IF
                    MOVE 'Y' TO DONE-WITH-WHITE-SPACE

                    MOVE EBCDIC-NUM(I:1) TO EBCDIC-DIGIT
                    IF DOING-CENTS = 'N' THEN
                       ADD 1 TO DOLLAR-DIGITS
                       IF DOLLAR-DIGITS > 13 THEN
                          MOVE 2 TO RET-CODE
                          GO TO EBCDIC-TO-PACKED-EXIT
                       END-IF
                       COMPUTE PACKED-NUM = (PACKED-NUM * 10) +
                                            EBCDIC-DIGIT END-COMPUTE
                    ELSE
                       ADD 1 TO CENTS-DIGITS
                       IF CENTS-DIGITS > 2 THEN
                          MOVE 3 TO RET-CODE
                          GO TO EBCDIC-TO-PACKED-EXIT
                       END-IF
                       COMPUTE PACKED-NUM-CENTS =
                               (PACKED-NUM-CENTS * 10) +
                                EBCDIC-DIGIT END-COMPUTE
                    END-IF
              END-EVALUATE

           END-PERFORM.

           IF DOING-CENTS = 'Y' THEN
              COMPUTE PACKED-NUM = (PACKED-NUM * 100) +
                                   PACKED-NUM-CENTS END-COMPUTE
           END-IF.

       EBCDIC-TO-PACKED-EXIT.
           EXIT.

      **************************************************************
      ** ADD A SAVINGS ACCOUNT RECORD                             **
      **************************************************************
       ADD-SAVINGS.
           PERFORM GET-NEW-ACCT-NUM THRU GET-NEW-ACCT-NUM-EXIT.
           PERFORM SET-MAP-DEFAULTS-AAS THRU SET-MAP-DEFAULTS-AAS-EXIT.
           MOVE CUSTOMER-NAME       TO AASNAMEO.
           MOVE CUSTOMER-SSN        TO AASSSNO.
           MOVE ACCT-NUMBER-NUMERIC TO AASNUMO.

           EXEC CICS SEND MAP('WGRVAAS') MAPSET('WGRVMAP')
                          FROM (WGRVAASO) ERASE END-EXEC.

           MOVE 'N' TO DONE-SAV.
           PERFORM UNTIL DONE-SAV = 'Y'
              EXEC CICS RECEIVE MAP('WGRVAAS') MAPSET('WGRVMAP')
                                ASIS END-EXEC

              MOVE 0 TO RET-CODE
              INITIALIZE ACCOUNT-RECORD
              PERFORM VALIDATE-INPUT-SAV THRU VALIDATE-INPUT-SAV-EXIT

              IF RET-CODE = 0 THEN
                 MOVE 'Y'          TO DONE-SAV
                 MOVE 'S'          TO ACCOUNT-TYPE-CODE
                 MOVE 'Savings '   TO ACCOUNT-TYPE-NAME
                 MOVE 1            TO ACCOUNT-SAV-DETAIL-ITEMS
                 MOVE CURRENT-DATE TO ACCOUNT-SAV-LAST-STMT
                 PERFORM ADD-ACCT THRU ADD-ACCT-EXIT
                 IF RET-CODE = 0 THEN
                    PERFORM ADD-TX-DETAIL THRU ADD-TX-DETAIL-EXIT
                 END-IF
                 IF RET-CODE = 0 THEN
                    MOVE SPACES TO AACMSG1O
                    MOVE RESP-CODE TO EDIT-NUM
                    STRING 'Add savings account to vsam failed, RC='
                           DELIMITED SIZE
                           EDIT-NUM DELIMITED SIZE
                           INTO AASMSG1O
                   END-STRING
                   MOVE SPACES TO AASMSG2O
                   GO TO ADD-SAVINGS-EXIT
                 END-IF
                 GO TO ADD-SAVINGS-EXIT
              ELSE
                 PERFORM FORMAT-BAD-SAV THRU FORMAT-BAD-SAV-EXIT
              END-IF
           END-PERFORM.

       ADD-SAVINGS-EXIT.
           EXIT.

      **************************************************************
      ** GET A DATE IN THE FOR MM/DD/YYYY                         **
      **************************************************************
       GET-DATE.
           EXEC CICS ASKTIME ABSTIME(UTIME) END-EXEC.
           EXEC CICS FORMATTIME ABSTIME(UTIME)
                                DATESEP('/') YEAR(UTIME-YEAR)
                                MMDDYY(CURRENT-DATE) END-EXEC.

           MOVE UTIME-YEAR TO CURRENT-DATE-YYYY.

       GET-DATE-EXIT.
           EXIT.

      **************************************************************
      ** MAKE A NEW ACCOUNT NUMBER                                **
      **************************************************************
       GET-NEW-ACCT-NUM.
           MOVE 'N' TO GOT-ACCT.
           PERFORM UNTIL GOT-ACCT = 'Y'
              EXEC CICS ASKTIME ABSTIME(UTIME) END-EXEC
              COMPUTE ACCT-NUMBER-NUMERIC = UTIME-X / 100 END-COMPUTE
              MOVE ACCT-NUMBER-NUMERIC TO NUM OF ACCT-REC-KEY
              MOVE CUSTOMER-SSN TO SSN OF ACCT-REC-KEY

              EXEC CICS READ
                        DATASET(WBACCTDB-DD)
                        INTO(ACCOUNT-RECORD)
                        LENGTH(LENGTH OF ACCOUNT-RECORD)
                        RIDFLD(ACCT-REC-KEY)
                        KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                        RESP(RESP-CODE)
              END-EXEC

              EVALUATE RESP-CODE
                 WHEN 0
                    CONTINUE
                 WHEN DFHRESP(NOTFND)
                    MOVE 'Y' TO GOT-ACCT
                 WHEN DFHRESP(NOTOPEN)
                    MOVE 'Account File not open' TO
                                AAMMSG1O AACMSG1O AASMSG1O
                    MOVE SPACES  TO AAMMSG2O AACMSG2O AASMSG2O
                    MOVE 1 TO RET-CODE
                    GO TO GET-NEW-ACCT-NUM-EXIT

                 WHEN OTHER
                    MOVE SPACES  TO LOG-MSG-BUFFER
                    MOVE SPACES  TO AAMMSG1O AACMSG1O AASMSG1O
                    MOVE SPACES  TO AAMMSG2O AACMSG2O AASMSG2O
                    MOVE RESP-CODE TO EDIT-NUM
                    STRING 'Error getting acct #: RESP-CODE='
                            DELIMITED SIZE
                           EDIT-NUM  DELIMITED SIZE
                           INTO LOG-MSG-BUFFER
                    END-STRING
                    PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT
                    MOVE LOG-MSG-BUFFER TO AAMMSG1O AACMSG1O AASMSG1O
                    MOVE 2 TO RET-CODE
                    GO TO GET-NEW-ACCT-NUM-EXIT

              END-EVALUATE
           END-PERFORM.

       GET-NEW-ACCT-NUM-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS-AAM.
           MOVE 'WBAA M' TO  AAMTRANO.
           MOVE SPACES   TO  AAMNAMEO.
           MOVE SPACES   TO  AAMTYPEO.
           MOVE SPACES   TO  AAMMSG1O.
           MOVE SPACES   TO  AAMMSG2O.

       SET-MAP-DEFAULTS-AAM-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS-AAC.
           MOVE 'WBAA C' TO  AACTRANO.
           MOVE SPACES TO  AACNAMEO.
           MOVE 0      TO  AACSSNO.
           MOVE 0      TO  AACNUMO.
           MOVE 0      TO  AACODCO.
           MOVE 0      TO  AACODLO.
           MOVE SPACES TO  AACODLAO.
           MOVE 0      TO  AACIBALO.
           MOVE SPACES TO  AACMSG1O.
           MOVE SPACES TO  AACMSG2O.

       SET-MAP-DEFAULTS-AAC-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS-AAS.
           MOVE 'WBAA S' TO  AASTRANO.
           MOVE SPACES   TO  AASNAMEO.
           MOVE 0        TO  AASSSNO.
           MOVE 0        TO  AASNUMO.
           MOVE 0        TO  AASINTRO.
           MOVE 0        TO  AASSCHGO.
           MOVE 0        TO  AASIBALO.
           MOVE SPACES   TO  AASMSG1O.
           MOVE SPACES   TO  AASMSG2O.

       SET-MAP-DEFAULTS-AAS-EXIT.
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

       XFER-WGRVGBAL.
           EXEC CICS XCTL PROGRAM('WGRVGBAL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

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

       XFER-WGRVCUSL.
           EXEC CICS XCTL PROGRAM('WGRVCUSL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVADDA.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVADDA-EXIT.
           EXIT.
