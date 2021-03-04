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
       PROGRAM-ID. WGRVADDC.
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

       01 TEMP-CUST-KEY                   PIC X(30)  VALUE SPACES.
       01 TEMP-CUST-REC.
          05 FILLER                       PIC X(30).
          05 TEMP-CUST-SSN                PIC X(9).
          05 FILLER                       PIC X(61).

       01 HW-LENGTH                   PIC 9(4)  COMP.
       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 DONE                        PIC X               VALUE 'N'.
       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.
       01 START-REC-NUM               PIC S9(9)  COMP    VALUE 1.

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

           EXEC CICS HANDLE AID CLEAR(END-WGRVADDC)
                                PF3(END-WGRVADDC)
                                PF4(XFER-WGRVGBAL)
                                PF5(XFER-WGRVGACC)
                                PF6(XFER-WGRVGCUS)
                                PF7(XFER-WGRVGDET)
                                PF9(XFER-WGRVADDA)
                                PF10(XFER-WGRVCUSL) END-EXEC.

           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.
           EXEC CICS SEND MAP('WGRVMAC') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           PERFORM UNTIL DONE = 'Y'
              EXEC CICS RECEIVE MAP('WGRVMAC') MAPSET('WGRVMAP')
                                ASIS END-EXEC

              MOVE 0 TO RET-CODE
              PERFORM VALIDATE-INPUT THRU VALIDATE-INPUT-EXIT
              IF RET-CODE = 0
                 PERFORM ADD-CUST THRU ADD-CUST-EXIT
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
           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.

           MOVE 'Customer successfully added' TO ACMSG1O.
           MOVE CUSTOMER-NAME TO ACMSG2O.

           EXEC CICS SEND MAP('WGRVMAC') MAPSET('WGRVMAP')
                          FROM (WGRVMACO) ERASE END-EXEC.

       FORMAT-GOOD-MSG-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-ERROR-MSG.
           EXEC CICS SEND MAP('WGRVMAC') MAPSET('WGRVMAP')
                          FROM (WGRVMACO) ERASE END-EXEC.

       FORMAT-ERROR-MSG-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE MAP                      **
      **************************************************************
       VALIDATE-INPUT.
           IF ACNAMEL = 0 OR ACNAMEI = SPACES THEN
              MOVE 'Name must not be blank' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACNAMEI(1:ACNAMEL)   TO NAME OF CUST-REC-KEY.
           MOVE ACNAMEI(1:ACNAMEL)   TO CUSTOMER-NAME.

           IF ACSSNL NOT = 9 OR ACSSNI IS NOT NUMERIC THEN
              MOVE 'SSN must be all numeric digits' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACSSNI               TO CUSTOMER-SSN.

           IF ACSTREEL = 0 OR ACSTREEI = SPACES THEN
              MOVE 'Street must not be blank' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACSTREEI(1:ACSTREEL) TO CUSTOMER-STREET.

           IF ACCITYL = 0 OR ACCITYI = SPACES THEN
              MOVE 'City must not be blank' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACCITYI(1:ACCITYL)   TO CUSTOMER-CITY.

           IF ACSTATEL = 0 OR ACSTATEI = SPACES THEN
              MOVE 'State must not be blank' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACSTATEI(1:ACSTATEL) TO CUSTOMER-STATE.

           IF ACZIPL NOT = 5 OR ACZIPI IS NOT NUMERIC THEN
              MOVE 'ZIP must contain all numeric digits' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACZIPI               TO CUSTOMER-ZIP.

           IF ACPHONEL = 0 OR ACPHONEI = SPACES THEN
              MOVE 'Phone must not be blank' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACPHONEI(1:ACPHONEL) TO CUSTOMER-PHONE.

           IF ACPINI IS NOT NUMERIC THEN
              MOVE 'Pin must contain 4 digits' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           IF ACPINL NOT = ACCPINL OR
              ACPINI NOT = ACCPINI THEN
              MOVE 'Pin and Confirm Pin do not match' TO ACMSG1O
              MOVE SPACES TO ACMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE ACPINI TO CUSTOMER-ACCESS-PIN.

           PERFORM VALIDATE-SSN THRU VALIDATE-SSN-EXIT.
           IF RET-CODE NOT = 0 THEN
              GO TO VALIDATE-INPUT-EXIT
           END-IF.

       VALIDATE-INPUT-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE MAP                      **
      **************************************************************
       VALIDATE-SSN.
           MOVE LOW-VALUES TO TEMP-CUST-KEY.
           EXEC CICS STARTBR DATASET(WBCUSTDB-DD)
                     RIDFLD(TEMP-CUST-KEY)
                     KEYLENGTH(LENGTH OF TEMP-CUST-KEY)
                     GTEQ
                     RESP(RESP-CODE) END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN OTHER
                 GO TO VALIDATE-SSN-ERROR-SB
           END-EVALUATE.

       VALIDATE-SSN-NEXT.
           EXEC CICS READNEXT
                     DATASET(WBCUSTDB-DD)
                     INTO(TEMP-CUST-REC)
                     LENGTH(LENGTH OF TEMP-CUST-REC)
                     RIDFLD(TEMP-CUST-KEY)
                     KEYLENGTH(LENGTH OF TEMP-CUST-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 IF TEMP-CUST-SSN NOT = ACSSNI THEN
                    GO TO VALIDATE-SSN-NEXT
                 ELSE
                    EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC
                    MOVE 'Duplicate SSN found' TO ACMSG1O
                    MOVE SPACES TO ACMSG2O
                    MOVE 2 TO RET-CODE
                    GO TO VALIDATE-SSN-EXIT
                 END-IF
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO ACMSG1O
                 MOVE SPACES TO ACMSG2O
                 MOVE 3 TO RET-CODE
                 GO TO VALIDATE-SSN-EXIT
              WHEN DFHRESP(ENDFILE)
                 EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC
                 MOVE 0 TO RET-CODE
                 GO TO VALIDATE-SSN-EXIT
              WHEN OTHER
                 GO TO VALIDATE-SSN-ERROR
           END-EVALUATE.
           GO TO VALIDATE-SSN-EXIT.

       VALIDATE-SSN-ERROR.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error on Customer file: Repsonse Code='
                  DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 4 TO RET-CODE.
           GO TO VALIDATE-SSN-EXIT.

       VALIDATE-SSN-ERROR-SB.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error on startbr Customer file: Repsonse Code='
                  DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 4 TO RET-CODE.
           GO TO VALIDATE-SSN-EXIT.

       VALIDATE-SSN-EXIT.
           EXIT.

       ADD-CUST.
      **************************************************
      *    ADD THE CUSTOMER RECORD TO THE VSAM DATA SET
      **************************************************
           EXEC CICS WRITE
                     DATASET(WBCUSTDB-DD)
                     FROM(CUSTOMER-RECORD)
                     LENGTH(LENGTH OF CUSTOMER-RECORD)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     RIDFLD(CUST-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 MOVE 0 TO RET-CODE
                 MOVE SPACES TO ACMSG1O
                 MOVE SPACES TO ACMSG2O
                 GO TO ADD-CUST-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO ACMSG1O
                 MOVE SPACES TO ACMSG2O
                 MOVE 1 TO RET-CODE
                 GO TO ADD-CUST-EXIT
              WHEN DFHRESP(DUPREC)
                 GO TO ADD-CUST-DUPLICATE
              WHEN DFHRESP(DUPKEY)
                 GO TO ADD-CUST-DUPLICATE
              WHEN OTHER
                 GO TO ADD-CUST-ERROR
           END-EVALUATE.

           GO TO ADD-CUST-EXIT.

       ADD-CUST-DUPLICATE.
           MOVE 'Customer name already defined' TO ACMSG1O.
           MOVE SPACES TO ACMSG2O.
           MOVE 2 TO RET-CODE.
           GO TO ADD-CUST-EXIT.

       ADD-CUST-ERROR.
           MOVE 'Error occurred writing the Customer VSAM file'
                 TO ACMSG1O.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Response code=' DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO ACMSG2O
           END-STRING.
           MOVE 3 TO RET-CODE.
           GO TO ADD-CUST-EXIT.

       ADD-CUST-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS.
           MOVE 'WBAC' TO ACTRANO.
           MOVE SPACES TO ACNAMEO.
           MOVE SPACES TO ACSSNO.
           MOVE SPACES TO ACSTREEO.
           MOVE SPACES TO ACCITYO.
           MOVE SPACES TO ACSTATEO.
           MOVE SPACES TO ACZIPO.
           MOVE SPACES TO ACPHONEO.
           MOVE SPACES TO ACPINO.
           MOVE SPACES TO ACCPINO.
           MOVE SPACES TO ACMSG1O.
           MOVE SPACES TO ACMSG2O.

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

       XFER-WGRVADDA.
           EXEC CICS XCTL PROGRAM('WGRVADDA') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVCUSL.
           EXEC CICS XCTL PROGRAM('WGRVCUSL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVADDC.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVADDC-EXIT.
           EXIT.
