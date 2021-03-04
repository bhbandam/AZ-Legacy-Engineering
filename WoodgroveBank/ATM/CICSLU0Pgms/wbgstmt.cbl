      *****************************************************************
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      *
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      ** THE INPUT TO THIS CICS PROGRAM IS PROVIDED THROUGH A BMS MAP *
      ** THAT IS NAMED WGRVMAP.                                       *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WBGSTMT.
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

       01 INPUT-AREA.
          05 IA-TRAN                  PIC X(4).
          05 IA-SSN                   PIC X(9).
          05 IA-LAST-REC.
             10 IA-LR-ACCT-NUM        PIC X(10).
             10 IA-LR-SEQ-NUM         PIC 9(7).
          05 IA-CNT                   PIC 9.

       01 OUTPUT-AREA.
          05 OA-HEADER.
             10 OA-FMH                PIC X(3)   VALUE X'034000'.
             10 OA-STATUS-CODE        PIC X      VALUE SPACES.
          05 OA-DATA.
             10 OA-LAST-REC.
                15 OA-LR-ACCT-NUM     PIC X(10).
                15 OA-LR-SEQ-NUM      PIC 9(7).
             10 OA-CNT                PIC 9      VALUE 0.
             10 OA-TXN-DETAIL OCCURS 5 TIMES DEPENDING ON OA-CNT.
                15 OA-TD-NUM          PIC X(10).
                15 OA-TD-TYPE         PIC X.
                15 OA-TD-DATE         PIC X(10).
                15 OA-TD-AMOUNT       PIC +9(9).99.

       01 ERROR-CODES.
          05 EC-OK                    PIC X      VALUE '0'.
          05 EC-INVALID-ACCT          PIC X      VALUE '1'.
          05 EC-INVALID-PIN           PIC X      VALUE '2'.
          05 EC-INVALID-SSN           PIC X      VALUE '3'.
          05 EC-WOULD-OVERDRAW        PIC X      VALUE '4'.
          05 EC-INVALID-XFER-ACCT     PIC X      VALUE '5'.

       01 DONE                        PIC X      VALUE 'N'.
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
                 GO TO WBGSTMT-EOC
              WHEN DFHRESP(INBFMH)
                 GO TO WBGSTMT-INBFMH
              WHEN DFHRESP(LENGERR)
                 GO TO WBGSTMT-LENGERR
              WHEN DFHRESP(SIGNAL)
                 GO TO WBGSTMT-SIGNAL-RECV
              WHEN DFHRESP(TERMERR)
                 GO TO WBGSTMT-TERMERR-RECV
              WHEN OTHER
                 GO TO WBGSTMT-RECV-ERROR
           END-EVALUATE.

           MOVE SPACES TO LOG-MSG-BUFFER.
           STRING 'Input Area:' DELIMITED SIZE
                  INPUT-AREA DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.

           PERFORM GET-TXN-DETAILS THRU GET-TXN-DETAILS-EXIT.

           IF RET-CODE = 0 THEN
              COMPUTE OUTPUT-AREA-LEN =
                      LENGTH OF OA-HEADER +
                      LENGTH OF OA-LAST-REC +
                      LENGTH OF OA-CNT +
                      (OA-CNT * LENGTH OF OA-TXN-DETAIL(1))
              MOVE EC-OK TO OA-STATUS-CODE
           ELSE
              MOVE LENGTH OF OA-HEADER OF OUTPUT-AREA TO
                   OUTPUT-AREA-LEN
           END-IF.

           EXEC CICS SEND FROM(OUTPUT-AREA)
                          FMH LAST LENGTH (OUTPUT-AREA-LEN)
                          END-EXEC.

           GO TO END-WBGSTMT.

      ************************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      *    IF THE INPUT AREA LAST RECORD PROCESSED FIELD IS BLANK
      *    THEN THIS IS THE FIRST TIOME WE ARE BEING CALLED. IF
      *    IT IS NOT BLANK THEN THIS WAS THE LAST RECORD PROCESSED
      *    WE MUST LOCATE IT, READ IT AND THEN COLLECT NEW RECORDS
      *    STARTING AT THAT POINT.
      ************************************************************
       GET-TXN-DETAILS.
           MOVE 0 TO OA-CNT.

           IF IA-LR-ACCT-NUM = SPACES AND IA-LR-SEQ-NUM = 0 THEN
              MOVE IA-SSN TO SSN OF TXN-REC-KEY
              EXEC CICS STARTBR
                        DATASET(WBTXNDB-DD)
                        RIDFLD(TXN-REC-KEY)
                        KEYLENGTH(LENGTH OF SSN OF TXN-REC-KEY)
                        GENERIC
                        RESP(RESP-CODE)
              END-EXEC
              EVALUATE RESP-CODE
                 WHEN 0
                    CONTINUE
                 WHEN DFHRESP(NOTOPEN)
                    GO TO GET-TXN-DETAILS-NOTOPEN-SB
                 WHEN DFHRESP(NOTFND)
                    GO TO GET-TXN-DETAILS-ENDFILE-SB
                 WHEN DFHRESP(ENDFILE)
                    GO TO GET-TXN-DETAILS-ENDFILE-SB
                 WHEN OTHER
                    GO TO GET-TXN-DETAILS-ERROR-SB
              END-EVALUATE
           ELSE
              MOVE IA-SSN         TO SSN      OF TXN-REC-KEY
              MOVE IA-LR-ACCT-NUM TO NUM      OF TXN-REC-KEY
              MOVE IA-LR-SEQ-NUM  TO ITEM-NUM OF TXN-REC-KEY

              EXEC CICS STARTBR
                        DATASET(WBTXNDB-DD)
                        RIDFLD(TXN-REC-KEY)
                        KEYLENGTH(LENGTH OF TXN-REC-KEY)
                        RESP(RESP-CODE)
              END-EXEC

              EVALUATE RESP-CODE
                 WHEN 0
                    CONTINUE
                 WHEN DFHRESP(NOTOPEN)
                    GO TO GET-TXN-DETAILS-NOTOPEN-SB
                 WHEN DFHRESP(NOTFND)
                    GO TO GET-TXN-DETAILS-ENDFILE-SB
                 WHEN DFHRESP(ENDFILE)
                    GO TO GET-TXN-DETAILS-ENDFILE-SB
                 WHEN OTHER
                    GO TO GET-TXN-DETAILS-ERROR-SB
              END-EVALUATE
              EXEC CICS READNEXT
                        DATASET(WBTXNDB-DD)
                        INTO(TXN-DETAILS)
                        LENGTH(LENGTH OF TXN-DETAILS)
                        RIDFLD(TXN-REC-KEY)
                        KEYLENGTH(LENGTH OF TXN-REC-KEY)
                        RESP(RESP-CODE)
              END-EXEC
              IF RESP-CODE NOT = 0 THEN
                 GO TO GET-TXN-DETAILS-ERROR
              END-IF
           END-IF.

       GET-TXN-DETAILS-NEXT.
           EXEC CICS READNEXT
                     DATASET(WBTXNDB-DD)
                     INTO(TXN-DETAILS)
                     LENGTH(LENGTH OF TXN-DETAILS)
                     RIDFLD(TXN-REC-KEY)
                     KEYLENGTH(LENGTH OF TXN-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 IF TXN-SSN = IA-SSN THEN
                    IF OA-CNT >= IA-CNT THEN
                       GO TO GET-TXN-DETAILS-NEXT
                    END-IF
                    MOVE TXN-ACCT-NUM TO OA-LR-ACCT-NUM
                    MOVE TXN-ITEM-NUM TO OA-LR-SEQ-NUM
                    COMPUTE OA-CNT = OA-CNT + 1
                    MOVE TXN-ACCT-NUM TO OA-TD-NUM(OA-CNT)
                    MOVE TXN-TYPE     TO OA-TD-TYPE(OA-CNT)
                    MOVE TXN-DATE     TO OA-TD-DATE(OA-CNT)
                    MOVE TXN-AMOUNT   TO OA-TD-AMOUNT(OA-CNT)
                    GO TO GET-TXN-DETAILS-NEXT
                 ELSE
                    EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC
                    GO TO GET-TXN-DETAILS-EXIT
                 END-IF
              WHEN DFHRESP(ENDFILE)
                 EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC
                 GO TO GET-TXN-DETAILS-EXIT
              WHEN OTHER
                 GO TO GET-TXN-DETAILS-ERROR
           END-EVALUATE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-ENDFILE.
           EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC.
           MOVE SPACES TO OA-LR-ACCT-NUM.
           MOVE 0 TO OA-LR-SEQ-NUM.
           MOVE 0 TO RET-CODE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-ERROR.
           EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM
           STRING 'I/O error reading TxnDetails: Response Code='
                        DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           MOVE 0 TO OA-LR-SEQ-NUM
           MOVE 0 TO RET-CODE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-NOTOPEN-SB.
           MOVE 'Account file not open' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 2 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           MOVE 0 TO OA-LR-SEQ-NUM
           MOVE 0 TO RET-CODE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-ERROR-SB.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM
           STRING 'I/O error startbr TxnDetails: Response Code='
                        DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 2 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           MOVE 0 TO OA-LR-SEQ-NUM
           MOVE 0 TO RET-CODE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-ENDFILE-SB.
           MOVE SPACES TO OA-LR-ACCT-NUM
           MOVE 0      TO OA-LR-SEQ-NUM
           MOVE 0 TO RET-CODE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-EXIT.
           EXIT.

       WBGSTMT-EOC.
           MOVE 'Receive Condition: EOC' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-EOC-EXIT.
           EXIT.

       WBGSTMT-EODS.
           MOVE 'Receive Condition: EODS' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-EODS-EXIT.
           EXIT.

       WBGSTMT-INBFMH.
           MOVE 'Receive Condition: INBFMH' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-INBFMH-EXIT.
           EXIT.

       WBGSTMT-LENGERR.
           MOVE 'Receive Condition: LENGERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-LENGERR-EXIT.
           EXIT.

       WBGSTMT-SIGNAL-RECV.
           MOVE 'Receive Condition: SIGNAL' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-SIGNAL-RECV-EXIT.
           EXIT.

       WBGSTMT-TERMERR-RECV.
           MOVE 'Receive Condition: TERMERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-TERMERR-RECV-EXIT.
           EXIT.

       WBGSTMT-RECV-ERROR.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Receive error: Response Code=' DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-RECV-ERROR-EXIT.
           EXIT.

       WBGSTMT-SIGNAL-SEND.
           MOVE 'Send Condition: SIGNAL' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-SIGNAL-SEND-EXIT.
           EXIT.

       WBGSTMT-TERMERR-SEND.
           MOVE 'Send Condition: TERMERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBGSTMT.

       WBGSTMT-TERMERR-SEND-EXIT.
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

       END-WBGSTMT.
           EXEC CICS RETURN END-EXEC.

       END-WBGSTMT-EXIT.
           EXIT.
