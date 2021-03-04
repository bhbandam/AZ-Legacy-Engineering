      *****************************************************************
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      *
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      ** THE INPUT TO THIS CICS PROGRAM IS PROVIDED THROUGH A BMS MAP *
      ** THAT IS NAMED WGRVMAP.                                       *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WBXFER.
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
           05 FILLER REDEFINES TXN-DATE.
              10 TXN-DATE-MONTH           PIC 99.
              10 FILLER                   PIC X.
              10 TXN-DATE-DAY             PIC 99.
              10 FILLER                   PIC X.
              10 TXN-DATE-YEAR            PIC 9999.
           05 TXN-AMOUNT                  PIC S9(13)V99  COMP-3.

       01 XFER-ACCT-REC-KEY.
           05 SSN                         PIC X(9)   VALUE SPACES.
           05 NUM                         PIC X(10)  VALUE SPACES.

       01  XFER-TO-ACCT-RECORD.
           05 XFER-TO-SSN                 PIC X(9).
           05 XFER-TO-NUMBER              PIC X(10).
           05 XFER-TO-TYPE.
              10 XFER-TO-TYPE-CODE        PIC X.
                 88 XFER-TO-TYPE-CHK            VALUE 'C'.
                 88 XFER-TO-TYPE-SAV            VALUE 'S'.
              10 XFER-TO-TYPE-NAME        PIC X(10).
           05 XFER-TO-AREA                PIC X(39).
           05 XFER-TO-TYPE-CHECKING REDEFINES XFER-TO-AREA.
              10 XFER-TO-CHK-OD-CHG       PIC S9(3)V99   COMP-3.
              10 XFER-TO-CHK-OD-LIMIT     PIC S9(5)V99   COMP-3.
              10 XFER-TO-CHK-OD-LINK-ACCT PIC X(10).
              10 XFER-TO-CHK-LAST-STMT    PIC X(10).
              10 XFER-TO-CHK-DETAIL-ITEMS PIC S9(7)      COMP-3.
              10 XFER-TO-CHK-BAL          PIC S9(13)V99  COMP-3.
           05 XFER-TO-TYPE-SAVINGS  REDEFINES XFER-TO-AREA.
              10 XFER-TO-SAV-INT-RATE     PIC S9(1)V99   COMP-3.
              10 XFER-TO-SAV-SVC-CHRG     PIC S9(3)V99   COMP-3.
              10 XFER-TO-SAV-LAST-STMT    PIC X(10).
              10 XFER-TO-SAV-DETAIL-ITEMS PIC S9(7)      COMP-3.
              10 XFER-TO-SAV-BAL          PIC S9(13)V99  COMP-3.
              10 FILLER                   PIC X(12).

       01 INPUT-AREA.
          05 IA-TRAN                  PIC X(4).
          05 IA-FROM-ACCT-NUM         PIC X(10).
          05 IA-SSN                   PIC X(9).
          05 IA-AMOUNT                PIC 9(3).
          05 IA-TO-ACCT-NUM           PIC X(10).

       01 OUTPUT-AREA.
          05 OA-HEADER.
             10 OA-FMH                PIC X(3)   VALUE X'034000'.
             10 OA-STATUS-CODE        PIC X      VALUE SPACES.
          05 OA-DATA.
             10 OA-BALANCE            PIC +9(9).99.

       01 ERROR-CODES.
          05 EC-OK                    PIC X      VALUE '0'.
          05 EC-INVALID-ACCT          PIC X      VALUE '1'.
          05 EC-INVALID-PIN           PIC X      VALUE '2'.
          05 EC-INVALID-SSN           PIC X      VALUE '3'.
          05 EC-WOULD-OVERDRAW        PIC X      VALUE '4'.
          05 EC-INVALID-XFER-ACCT     PIC X      VALUE '5'.

       01 DONE                        PIC X      VALUE 'N'.
       01 UTIME-YEAR                  PIC S9(8)  VALUE 0.
       01 UTIME                       PIC S9(15) COMP-3.
       01 WBCUSTDB-DD                 PIC X(8)   VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)   VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)   VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)  COMP    VALUE 0.
       01 RESP-CODE                   PIC S9(8)  COMP    VALUE 0.
       01 INPUT-AREA-LEN              PIC S9(4)  COMP    VALUE 0.
       01 OUTPUT-AREA-LEN             PIC S9(4)  COMP    VALUE 0.
       01 HW-LENGTH                   PIC 9(4)   COMP.
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

       LINKAGE SECTION.

       PROCEDURE DIVISION.
           EXEC CICS RECEIVE INTO(INPUT-AREA)
                     MAXLENGTH (LENGTH OF INPUT-AREA)
                     LENGTH (INPUT-AREA-LEN)
                     RESP(RESP-CODE)
                     END-EXEC.

           EVALUATE RESP-CODE
              WHEN DFHRESP(EOC)
                 CONTINUE
              WHEN DFHRESP(EODS)
                 GO TO WBXFER-EOC
              WHEN DFHRESP(INBFMH)
                 GO TO WBXFER-INBFMH
              WHEN DFHRESP(LENGERR)
                 GO TO WBXFER-LENGERR
              WHEN DFHRESP(SIGNAL)
                 GO TO WBXFER-SIGNAL-RECV
              WHEN DFHRESP(TERMERR)
                 GO TO WBXFER-TERMERR-RECV
              WHEN OTHER
                 GO TO WBXFER-RECV-ERROR
           END-EVALUATE.

           MOVE SPACES TO LOG-MSG-BUFFER.
           STRING 'Input Area:' DELIMITED SIZE
                  INPUT-AREA DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.

           PERFORM GET-ACCT THRU GET-ACCT-EXIT.
           IF RET-CODE = 0 THEN
              PERFORM GET-XFER-ACCT THRU GET-XFER-ACCT-EXIT
           END-IF.

           IF RET-CODE = 0 THEN
              PERFORM UPDATE-ACCT THRU UPDATE-ACCT-EXIT
           END-IF.

           IF RET-CODE = 0 THEN
              PERFORM UPDATE-XFER-ACCT THRU UPDATE-XFER-ACCT-EXIT
           END-IF.

           IF RET-CODE = 0 THEN
              PERFORM ADD-TX-DETAIL THRU ADD-TX-DETAIL-EXIT
           END-IF.

           IF RET-CODE = 0 THEN
              MOVE LENGTH OF OUTPUT-AREA TO OUTPUT-AREA-LEN
              MOVE EC-OK TO OA-STATUS-CODE
           ELSE
              MOVE LENGTH OF OA-HEADER OF OUTPUT-AREA TO
                   OUTPUT-AREA-LEN
           END-IF.

           EXEC CICS SEND FROM(OUTPUT-AREA)
                          FMH LAST LENGTH (OUTPUT-AREA-LEN)
                          END-EXEC.

           GO TO END-WBXFER.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       GET-ACCT.
           MOVE IA-SSN TO SSN OF ACCT-REC-KEY.
           MOVE IA-FROM-ACCT-NUM TO NUM OF ACCT-REC-KEY.
           EXEC CICS READ
                     DATASET(WBACCTDB-DD)
                     INTO(ACCOUNT-RECORD)
                     LENGTH(LENGTH OF ACCOUNT-RECORD)
                     RIDFLD(ACCT-REC-KEY)
                     KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                     RESP(RESP-CODE)
                     UPDATE
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 EVALUATE ACCOUNT-TYPE-CODE
                    WHEN 'C'
                       COMPUTE ACCOUNT-CHK-BAL =
                               ACCOUNT-CHK-BAL - IA-AMOUNT
                       END-COMPUTE
                       ADD 1 TO ACCOUNT-CHK-DETAIL-ITEMS
                       MOVE ACCOUNT-CHK-BAL TO OA-BALANCE
                    WHEN 'S'
                       COMPUTE ACCOUNT-SAV-BAL =
                               ACCOUNT-SAV-BAL - IA-AMOUNT
                       END-COMPUTE
                       ADD 1 TO ACCOUNT-SAV-DETAIL-ITEMS
                       MOVE ACCOUNT-SAV-BAL TO OA-BALANCE
                    WHEN OTHER
                       MOVE EC-INVALID-ACCT TO OA-STATUS-CODE
                       MOVE 1 TO RET-CODE
                       GO TO GET-ACCT-EXIT
                 END-EVALUATE
                 IF OA-BALANCE >= 0 THEN
                    GO TO GET-ACCT-EXIT
                 ELSE
                    GO TO GET-ACCT-EXIT
                    MOVE EC-WOULD-OVERDRAW TO OA-STATUS-CODE
                    MOVE 1 TO RET-CODE
                 END-IF

              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-ACCT-NOTOPEN

              WHEN OTHER
                 GO TO GET-ACCT-ERROR
           END-EVALUATE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-ERROR.
           EXEC CICS HANDLE CONDITION ERROR END-EXEC.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error reading Accounts file: Response code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-NOTOPEN.
           EXEC CICS HANDLE CONDITION ERROR END-EXEC.
           MOVE 'Account file not open' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-EXIT.
           EXIT.

      **************************************************
      *    UPDATE THE ACCOUNT INFO IN VSAM DATA SET
      **************************************************
       UPDATE-ACCT.
           EXEC CICS REWRITE
                     DATASET(WBACCTDB-DD)
                     FROM(ACCOUNT-RECORD)
                     LENGTH(LENGTH OF ACCOUNT-RECORD)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 MOVE 0 TO RET-CODE
                 GO TO UPDATE-ACCT-EXIT
              WHEN OTHER
                 MOVE SPACES  TO LOG-MSG-BUFFER
                 MOVE '"From" Acct Update Failed' TO LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT
                 GO TO UPDATE-ACCT-ERROR
           END-EVALUATE.
           GO TO UPDATE-ACCT-EXIT.

       UPDATE-ACCT-ERROR.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error updating Accounts file: Response code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO UPDATE-ACCT-EXIT.

       UPDATE-ACCT-EXIT.
           EXIT.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       GET-XFER-ACCT.
           MOVE IA-SSN TO SSN OF XFER-ACCT-REC-KEY.
           MOVE IA-TO-ACCT-NUM TO NUM OF XFER-ACCT-REC-KEY.
           EXEC CICS READ
                     DATASET(WBACCTDB-DD)
                     INTO(XFER-TO-ACCT-RECORD)
                     LENGTH(LENGTH OF XFER-TO-ACCT-RECORD)
                     RIDFLD(XFER-ACCT-REC-KEY)
                     KEYLENGTH(LENGTH OF XFER-ACCT-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 MOVE SPACES  TO LOG-MSG-BUFFER
              WHEN OTHER
                 GO TO GET-XFER-ACCT-ERROR
           END-EVALUATE.
           GO TO GET-XFER-ACCT-EXIT.

       GET-XFER-ACCT-ERROR.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error reading "to" ACCT file: Response code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-XFER-ACCT-EXIT.

       GET-XFER-ACCT-EXIT.
           EXIT.

      **************************************************
      *    UPDATE THE ACCOUNT INFO IN VSAM DATA SET
      **************************************************
       UPDATE-XFER-ACCT.
           MOVE IA-SSN TO SSN OF XFER-ACCT-REC-KEY.
           MOVE IA-TO-ACCT-NUM TO NUM OF XFER-ACCT-REC-KEY.
           EXEC CICS READ
                     DATASET(WBACCTDB-DD)
                     INTO(XFER-TO-ACCT-RECORD)
                     LENGTH(LENGTH OF XFER-TO-ACCT-RECORD)
                     RIDFLD(XFER-ACCT-REC-KEY)
                     KEYLENGTH(LENGTH OF XFER-ACCT-REC-KEY)
                     RESP(RESP-CODE)
                     UPDATE
           END-EXEC.
           IF RESP-CODE NOT = 0 THEN
              GO TO UPDATE-XFER-ACCT-ERROR
           END-IF.

           EVALUATE XFER-TO-TYPE-CODE
              WHEN 'C'
                 COMPUTE XFER-TO-CHK-BAL =
                         XFER-TO-CHK-BAL + IA-AMOUNT
                 END-COMPUTE
                 ADD 1 TO XFER-TO-CHK-DETAIL-ITEMS
              WHEN 'S'
                 COMPUTE XFER-TO-SAV-BAL =
                         XFER-TO-SAV-BAL + IA-AMOUNT
                 END-COMPUTE
                 ADD 1 TO XFER-TO-SAV-DETAIL-ITEMS
              WHEN OTHER
                 MOVE EC-INVALID-ACCT TO OA-STATUS-CODE
                 MOVE 1 TO RET-CODE
                 GO TO GET-XFER-ACCT-EXIT
           END-EVALUATE

           EXEC CICS REWRITE
                     DATASET(WBACCTDB-DD)
                     FROM(XFER-TO-ACCT-RECORD)
                     LENGTH(LENGTH OF XFER-TO-ACCT-RECORD)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 MOVE 0 TO RET-CODE
                 GO TO UPDATE-XFER-ACCT-EXIT
              WHEN OTHER
                 MOVE SPACES  TO LOG-MSG-BUFFER
                 MOVE '"To" Acct Update Failed' TO LOG-MSG-BUFFER
                 MOVE SPACES  TO LOG-MSG-BUFFER
                 MOVE RESP-CODE TO EDIT-NUM
                 STRING '"To" Acct Update Response=' DELIMITED SIZE
                        EDIT-NUM DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT
                 GO TO UPDATE-XFER-ACCT-ERROR
           END-EVALUATE.
           GO TO UPDATE-XFER-ACCT-EXIT.

       UPDATE-XFER-ACCT-ERROR.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error updating Accounts file: Response code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-XFER-ACCT TO OA-STATUS-CODE.
           GO TO UPDATE-XFER-ACCT-EXIT.

       UPDATE-XFER-ACCT-EXIT.
           EXIT.

      **************************************************
      *    ADD THE CUSTOMER RECORD TO THE VSAM DATA SET
      **************************************************
       ADD-TX-DETAIL.
           EXEC CICS ASKTIME ABSTIME(UTIME) END-EXEC.
           MOVE SPACES TO TXN-DATE.
           EXEC CICS FORMATTIME ABSTIME(UTIME)
                                DATESEP('/')
                                YEAR(UTIME-YEAR)
                                MMDDYY(TXN-DATE) END-EXEC.
           MOVE ACCOUNT-SSN    TO TXN-SSN.
           MOVE UTIME-YEAR     TO TXN-DATE-YEAR.
           MOVE IA-AMOUNT      TO TXN-AMOUNT.

       ADD-TXN-DETAIL-FROM.
           MOVE ACCOUNT-NUMBER TO TXN-ACCT-NUM.
           MOVE 'D' TO TXN-TYPE.
           EVALUATE ACCOUNT-TYPE-CODE
              WHEN 'C'
                 MOVE ACCOUNT-CHK-DETAIL-ITEMS TO TXN-ITEM-NUM
              WHEN 'S'
                 MOVE ACCOUNT-SAV-DETAIL-ITEMS TO TXN-ITEM-NUM
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
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO ADD-TX-DETAIL-NOTOPEN
              WHEN DFHRESP(DUPKEY)
                 GO TO ADD-TX-DETAIL-DUPLICATE
              WHEN DFHRESP(DUPREC)
                 GO TO ADD-TX-DETAIL-DUPLICATE
              WHEN OTHER
                 GO TO ADD-TX-DETAIL-ERROR
           END-EVALUATE.

       ADD-TXN-DETAIL-TO.
           MOVE XFER-TO-NUMBER TO TXN-ACCT-NUM.
           MOVE 'C' TO TXN-TYPE.
           EVALUATE XFER-TO-TYPE-CODE
              WHEN 'C'
                 MOVE XFER-TO-CHK-DETAIL-ITEMS TO TXN-ITEM-NUM
              WHEN 'S'
                 MOVE XFER-TO-SAV-DETAIL-ITEMS TO TXN-ITEM-NUM
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
                 MOVE 0 TO RET-CODE
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN DFHRESP(DUPKEY)
                 GO TO ADD-TX-DETAIL-DUPLICATE
              WHEN DFHRESP(DUPREC)
                 GO TO ADD-TX-DETAIL-DUPLICATE
              WHEN OTHER
                 GO TO ADD-TX-DETAIL-ERROR
           END-EVALUATE.
           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-DUPLICATE.
           MOVE 'Duplicate "To" Txn Detail' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           EXEC CICS HANDLE CONDITION ERROR DUPREC DUPKEY END-EXEC.
           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-ERROR.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error "To" Txn Detail: Response Code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 2 TO RET-CODE.
           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-NOTOPEN.
           MOVE 'TxnDetail file not open' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 2 TO RET-CODE.
           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-EXIT.
           EXIT.

       WBXFER-EOC.
           MOVE 'Receive Condition: EOC' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-EOC-EXIT.
           EXIT.

       WBXFER-EODS.
           MOVE 'Receive Condition: EODS' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-EODS-EXIT.
           EXIT.

       WBXFER-INBFMH.
           MOVE 'Receive Condition: INBFMH' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-INBFMH-EXIT.
           EXIT.

       WBXFER-LENGERR.
           MOVE 'Receive Condition: LENGERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-LENGERR-EXIT.
           EXIT.

       WBXFER-SIGNAL-RECV.
           MOVE 'Receive Condition: SIGNAL' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-SIGNAL-RECV-EXIT.
           EXIT.

       WBXFER-TERMERR-RECV.
           MOVE 'Receive Condition: TERMERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-TERMERR-RECV-EXIT.
           EXIT.

       WBXFER-RECV-ERROR.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Receive error: Response Code=' DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-RECV-ERROR-EXIT.
           EXIT.

       WBXFER-SIGNAL-SEND.
           MOVE 'Send Condition: SIGNAL' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-SIGNAL-SEND-EXIT.
           EXIT.

       WBXFER-TERMERR-SEND.
           MOVE 'Send Condition: TERMERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBXFER.

       WBXFER-TERMERR-SEND-EXIT.
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

       END-WBXFER.
           EXEC CICS RETURN END-EXEC.

       END-WBXFER-EXIT.
           EXIT.
