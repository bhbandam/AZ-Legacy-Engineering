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
       PROGRAM-ID. WGRVCUSL.
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

       01 SEL-ENTRY                   PIC S9(4)   COMP.
       01 CUST-CNT                    PIC S9(4)   COMP.
       01 I                           PIC S9(4)   COMP.
       01 DONE                        PIC X       VALUE 'N'.
       01 DONE-CI                     PIC X       VALUE 'N'.
       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.

      **** COPY THE BMS MAP DEFINITION FOR CEDAR BANK
       COPY WGRVMAP.

       01 CUST-IN  REDEFINES CLNAMEI.
           02  FILLER               PIC X(52).
           02  SEL-LINE-IN OCCURS 15 TIMES.
               03  CLSELL           PIC S9(4) COMP.
               03  CLSELF           PIC X.
               03  FILLER REDEFINES CLSELF.
                   04 CLSELA        PIC X.
               03  CLSELI           PIC X(01).
               03  CLNAML           PIC S9(4) COMP.
               03  CLNAMF           PIC X.
               03  FILLER REDEFINES CLNAMF.
                   04 CLNAMA        PIC X.
               03  CLNAMI           PIC X(30).
           02  FILLER               PIC X(248).

       01 CUST-OUT REDEFINES CLNAMEI.
           02  FILLER               PIC X(52).
           02  SEL-LINE-OUT OCCURS 15 TIMES.
               03  FILLER           PIC X(3).
               03  CLSELO           PIC X(01).
               03  FILLER           PIC X(3).
               03  CLNAMO           PIC X(30).
           02  FILLER               PIC X(248).

       LINKAGE SECTION.

       PROCEDURE DIVISION.

           EXEC CICS HANDLE AID CLEAR(END-WGRVCUSL)
                                PF3(END-WGRVCUSL)
                                PF4(XFER-WGRVGBAL)
                                PF5(XFER-WGRVGACC)
                                PF6(XFER-WGRVGCUS)
                                PF7(XFER-WGRVGDET)
                                PF8(XFER-WGRVADDC)
                                PF9(XFER-WGRVADDA) END-EXEC.

           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.
           EXEC CICS SEND MAP('CLNAME') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           PERFORM UNTIL DONE = 'Y'
              EXEC CICS RECEIVE MAP('CLNAME') MAPSET('WGRVMAP')
                                ASIS END-EXEC

              MOVE 0 TO RET-CODE
              PERFORM VALIDATE-INPUT THRU VALIDATE-INPUT-EXIT
              EVALUATE RET-CODE
                 WHEN 0
                    PERFORM GET-CUST-LIST THRU GET-CUST-LIST-EXIT
                 WHEN 1
                    PERFORM SHOW-CUST THRU SHOW-CUST-EXIT
                 WHEN OTHER
                    CONTINUE
              END-EVALUATE

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
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 14
              IF I > CUST-CNT THEN
                 MOVE SPACES TO CLSELO(I) CLNAMO(I)
              ELSE
                 MOVE '.' TO CLSELO(I)
              END-IF
           END-PERFORM.
           EXEC CICS SEND MAP('CLNAME') MAPSET('WGRVMAP')
                          FROM (CLNAMEO) ERASE END-EXEC.

       FORMAT-GOOD-MSG-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-ERROR-MSG.
           EXEC CICS SEND MAP('CLNAME') MAPSET('WGRVMAP')
                          FROM (CLNAMEO) ERASE END-EXEC.

       FORMAT-ERROR-MSG-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INPUT FIELDS FROM THE MAP                   **
      **************************************************************
       VALIDATE-INPUT.
           PERFORM VARYING SEL-ENTRY FROM 1 BY 1
                           UNTIL SEL-ENTRY > 14
              IF CLSELI(SEL-ENTRY) NOT = '.' AND
                 CLSELI(SEL-ENTRY) NOT = SPACES AND
                 CLSELL(SEL-ENTRY) NOT = 0 THEN
                 MOVE 1 TO RET-CODE
                 GO TO  VALIDATE-INPUT-EXIT
              END-IF
           END-PERFORM.

           MOVE 0 TO RET-CODE.

       VALIDATE-INPUT-EXIT.
           EXIT.

      **************************************************************
      ** SHOW CUSTOMER DETAILS                                    **
      **************************************************************
       SHOW-CUST.
           MOVE CLNAMO(SEL-ENTRY) TO NAME OF CUST-REC-KEY.

           EXEC CICS SEND MAP('WGRVMCI') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           PERFORM GET-CUST THRU GET-CUST-EXIT.
           PERFORM SET-MAP-DEFAULTS-CI THRU SET-MAP-DEFAULTS-CI-EXIT.
           EXEC CICS SEND MAP('WGRVMCI') MAPSET('WGRVMAP')
                          DATAONLY FROM(WGRVMCIO) END-EXEC.

           MOVE 'N' TO DONE-CI.
           PERFORM UNTIL DONE-CI = 'Y'
              EXEC CICS RECEIVE MAP('WGRVMCI') MAPSET('WGRVMAP')
                                INTO(WGRVMCII) ASIS END-EXEC

              MOVE 0 TO RET-CODE
              PERFORM VALIDATE-INPUT-CI THRU VALIDATE-INPUT-CI-EXIT
              EVALUATE RET-CODE
                 WHEN 0
                    PERFORM UPDATE-CUST THRU UPDATE-CUST-EXIT
                 WHEN OTHER
                    CONTINUE
              END-EVALUATE

              IF RET-CODE = 0 THEN
                 PERFORM FORMAT-GOOD-CI THRU FORMAT-GOOD-CI-EXIT
                 MOVE 'Y' TO DONE-CI
                 MOVE 0 TO CUST-CNT
              ELSE
                 PERFORM FORMAT-ERROR-CI THRU FORMAT-ERROR-CI-EXIT
              END-IF
           END-PERFORM.

       SHOW-CUST-EXIT.
           EXIT.

       GET-CUST.
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
                 MOVE 0 TO RET-CODE
                 MOVE SPACES TO CIMSG1O
                 GO TO GET-CUST-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO CIMSG1O
                 MOVE 1 TO RET-CODE
                 GO TO GET-CUST-EXIT
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-NOTFND
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUST-NOTFND
              WHEN OTHER
                 MOVE 'I/O error on Customer file' TO CIMSG1O
                 MOVE RESP-CODE TO EDIT-NUM
                 STRING 'Response code=' DELIMITED SIZE
                        EDIT-NUM DELIMITED SIZE
                        INTO CIMSG2O
                 END-STRING
                 MOVE 3 TO RET-CODE
                 GO TO GET-CUST-EXIT
           END-EVALUATE.
           GO TO GET-CUST-EXIT.

       GET-CUST-NOTFND.
           MOVE 'Customer name not found' TO CIMSG1O.
           MOVE 2 TO RET-CODE.
           GO TO GET-CUST-EXIT.

       GET-CUST-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT A GOOD MESSAGE TO SEND TO THE TERMINAL USER       **
      **************************************************************
       FORMAT-GOOD-CI.
           EXEC CICS SEND MAP('WGRVMCI') MAPSET('WGRVMAP')
                          FROM (WGRVMCIO) ERASE END-EXEC.
           EXEC CICS RECEIVE MAP('WGRVMCI') MAPSET('WGRVMAP')
                             INTO(WGRVMCII) ASIS END-EXEC.


           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.
           EXEC CICS SEND MAP('CLNAME') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

       FORMAT-GOOD-CI-EXIT.
           EXIT.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-ERROR-CI.
           EXEC CICS SEND MAP('WGRVMCI') MAPSET('WGRVMAP')
                          FROM (WGRVMCIO) ERASE END-EXEC.

       FORMAT-ERROR-CI-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS.
           MOVE 'WBCL' TO CLTRANO.
           MOVE SPACES TO CLLOCNO.
           MOVE SPACES TO CLMSG1O.
           MOVE SPACES TO CLMSG2O.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 14
              MOVE SPACES TO CLSELO(I) CLNAMO(I)
           END-PERFORM.

       SET-MAP-DEFAULTS-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS-CI.
           MOVE 'WBCI' TO CITRANO.
           MOVE CUSTOMER-NAME       TO CINAMEO.
           MOVE CUSTOMER-SSN        TO CISSNO.
           MOVE CUSTOMER-STREET     TO CISTREEO.
           MOVE CUSTOMER-CITY       TO CICITYO.
           MOVE CUSTOMER-STATE      TO CISTATEO.
           MOVE CUSTOMER-ZIP        TO CIZIPO.
           MOVE CUSTOMER-PHONE      TO CIPHONEO.
           MOVE CUSTOMER-ACCESS-PIN TO CIPINO CICPINO.
           MOVE SPACES TO CIMSG1O.
           MOVE SPACES TO CIMSG2O.

       SET-MAP-DEFAULTS-CI-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       VALIDATE-INPUT-CI.
           IF CISTREEL = 0 OR CISTREEI = SPACES THEN
              MOVE 'Street must not be blank' TO CIMSG1O
              MOVE SPACES TO CIMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CI-EXIT
           END-IF.
           MOVE CISTREEI(1:ACSTREEL) TO CUSTOMER-STREET.

           IF CICITYL = 0 OR CICITYI = SPACES THEN
              MOVE 'City must not be blank' TO CIMSG1O
              MOVE SPACES TO CIMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CI-EXIT
           END-IF.
           MOVE CICITYI(1:ACCITYL)   TO CUSTOMER-CITY.

           IF CISTATEL = 0 OR CISTATEI = SPACES THEN
              MOVE 'State must not be blank' TO CIMSG1O
              MOVE SPACES TO CIMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CI-EXIT
           END-IF.
           MOVE CISTATEI(1:ACSTATEL) TO CUSTOMER-STATE.

           IF CIZIPL NOT = 5 OR CIZIPI IS NOT NUMERIC THEN
              MOVE 'ZIP must contain all numeric digits' TO CIMSG1O
              MOVE SPACES TO CIMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CI-EXIT
           END-IF.
           MOVE CIZIPI               TO CUSTOMER-ZIP.

           IF CIPHONEL = 0 OR CIPHONEI = SPACES THEN
              MOVE 'Phone must not be blank' TO CIMSG1O
              MOVE SPACES TO CIMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CI-EXIT
           END-IF.
           MOVE CIPHONEI(1:ACPHONEL) TO CUSTOMER-PHONE.

           IF CIPINI IS NOT NUMERIC THEN
              MOVE 'Pin must contain 4 digits' TO CIMSG1O
              MOVE SPACES TO CIMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CI-EXIT
           END-IF.
           IF CIPINL NOT = CICPINL OR
              CIPINI NOT = CICPINI THEN
              MOVE 'Pin and Confirm Pin do not match' TO CIMSG1O
              MOVE SPACES TO CIMSG2O
              MOVE 1 TO RET-CODE
              GO TO VALIDATE-INPUT-CI-EXIT
           END-IF.
           MOVE CIPINI TO CUSTOMER-ACCESS-PIN.

       VALIDATE-INPUT-CI-EXIT.
           EXIT.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       UPDATE-CUST.
           EXEC CICS READ
                     DATASET(WBCUSTDB-DD)
                     INTO(CUSTOMER-RECORD)
                     LENGTH(LENGTH OF CUSTOMER-RECORD)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     RIDFLD(CUST-REC-KEY)
                     RESP(RESP-CODE)
                     UPDATE
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO CIMSG1O
                 MOVE 1 TO RET-CODE
                 GO TO UPDATE-CUST-EXIT
              WHEN DFHRESP(ENDFILE)
                 GO TO UPDATE-CUST-NOTFND
              WHEN DFHRESP(NOTFND)
                 GO TO UPDATE-CUST-NOTFND
              WHEN OTHER
                 MOVE 'I/O error on Customer file' TO CIMSG1O
                 MOVE RESP-CODE TO EDIT-NUM
                 STRING 'Response code=' DELIMITED SIZE
                        EDIT-NUM DELIMITED SIZE
                        INTO CIMSG2O
                 END-STRING
                 MOVE 3 TO RET-CODE
                 GO TO UPDATE-CUST-EXIT
           END-EVALUATE.

           MOVE CISTREEO TO CUSTOMER-STREET.
           MOVE CICITYO  TO CUSTOMER-CITY.
           MOVE CISTATEO TO CUSTOMER-STATE.
           MOVE CIZIPO   TO CUSTOMER-ZIP.
           MOVE CIPHONEO TO CUSTOMER-PHONE.
           MOVE CIPINO   TO CUSTOMER-ACCESS-PIN.

           EXEC CICS REWRITE
                     DATASET(WBCUSTDB-DD)
                     FROM(CUSTOMER-RECORD)
                     LENGTH(LENGTH OF CUSTOMER-RECORD)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 MOVE 'Customer successfully updated' TO CIMSG1O
                 MOVE 0 TO RET-CODE
                 GO TO UPDATE-CUST-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO CIMSG1O
                 MOVE 1 TO RET-CODE
                 GO TO UPDATE-CUST-EXIT
              WHEN OTHER
                 MOVE 'I/O error on Customer file' TO CIMSG1O
                 MOVE RESP-CODE TO EDIT-NUM
                 STRING 'Response code=' DELIMITED SIZE
                        EDIT-NUM DELIMITED SIZE
                        INTO CIMSG2O
                 END-STRING
                 MOVE 3 TO RET-CODE
                 GO TO UPDATE-CUST-EXIT
           END-EVALUATE.

           GO TO UPDATE-CUST-EXIT.

       UPDATE-CUST-NOTFND.
           MOVE 'Customer name not found' TO CIMSG1O.
           MOVE 2 TO RET-CODE.
           GO TO GET-CUST-EXIT.

       UPDATE-CUST-EXIT.
           EXIT.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       GET-CUST-LIST.
           IF CLLOCNI = SPACES THEN
              MOVE LOW-VALUES TO NAME OF CUST-REC-KEY
           ELSE
              MOVE CLLOCNI TO NAME OF CUST-REC-KEY
           END-IF.
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
                 GO TO GET-CUST-LIST-NOTFND-SB
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUST-LIST-NOTFND-SB
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-LIST-ENDFILE-SB
              WHEN OTHER
                 GO TO GET-CUST-LIST-ERROR-SB
           END-EVALUATE.

           MOVE 0 TO CUST-CNT.
       GET-CUST-LIST-NEXT.
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
                 GO TO GET-CUST-LIST-NOTFND
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-LIST-ENDFILE
              WHEN OTHER
                 GO TO GET-CUST-LIST-ERROR
           END-EVALUATE.

           COMPUTE CUST-CNT = CUST-CNT + 1.
           MOVE CUSTOMER-NAME TO CLNAMO(CUST-CNT) CLLOCNO.
           IF CUST-CNT > 14 THEN
              MOVE CUSTOMER-NAME TO CLLOCNO
              COMPUTE CUST-CNT = CUST-CNT - 1
              EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC
              GO TO GET-CUST-LIST-EXIT
           END-IF.
           GO TO GET-CUST-LIST-NEXT.

       GET-CUST-LIST-ENDFILE.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           GO TO GET-CUST-LIST-ENDFILE-SB.

       GET-CUST-LIST-ENDFILE-SB.
           MOVE SPACES TO CLLOCNO.
           GO TO GET-CUST-LIST-EXIT.

       GET-CUST-LIST-NOTFND.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           GO TO GET-CUST-LIST-NOTFND-SB.

       GET-CUST-LIST-NOTFND-SB.
           GO TO GET-CUST-LIST-EXIT.

       GET-CUST-LIST-ERROR.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           GO TO GET-CUST-LIST-ERROR-SB.

       GET-CUST-LIST-ERROR-SB.
           EXEC CICS ABEND ABCODE('WBER') END-EXEC.

       GET-CUST-LIST-EXIT.
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

       XFER-WGRVGCUS.
           EXEC CICS XCTL PROGRAM('WGRVGCUS') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVCUSL.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVCUSL-EXIT.
           EXIT.
