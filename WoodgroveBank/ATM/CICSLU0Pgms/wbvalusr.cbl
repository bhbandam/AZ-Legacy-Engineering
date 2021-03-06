      *****************************************************************
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      *
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      ** THE INPUT TO THIS CICS PROGRAM IS PROVIDED THROUGH A BMS MAP *
      ** THAT IS NAMED WGRVMAP.                                       *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WBVALUSR.
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
          05 IA-ACCT-NUM              PIC X(10).
          05 IA-PIN                   PIC X(4).

       01 OUTPUT-AREA.
          05 OA-HEADER.
             10 OA-FMH                PIC X(3)   VALUE X'034000'.
             10 OA-STATUS-CODE        PIC X      VALUE SPACES.
          05 OA-DATA.
             10 OA-SSN                PIC X(9)   VALUE SPACES.
             10 OA-NAME               PIC X(30)  VALUE SPACES.

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
                 GO TO WBVALUSR-EOC
              WHEN DFHRESP(INBFMH)
                 GO TO WBVALUSR-INBFMH
              WHEN DFHRESP(LENGERR)
                 GO TO WBVALUSR-LENGERR
              WHEN DFHRESP(SIGNAL)
                 GO TO WBVALUSR-SIGNAL-RECV
              WHEN DFHRESP(TERMERR)
                 GO TO WBVALUSR-TERMERR-RECV
              WHEN OTHER
                 GO TO WBVALUSR-RECV-ERROR
           END-EVALUATE.

           MOVE SPACES TO LOG-MSG-BUFFER.
           STRING 'Input Area:' DELIMITED SIZE
                  INPUT-AREA DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.

           PERFORM GET-ACCT THRU GET-ACCT-EXIT.
           IF RET-CODE = 0 THEN
              PERFORM GET-CUST THRU GET-CUST-EXIT
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

           GO TO END-WBVALUSR.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       GET-ACCT.
           MOVE LOW-VALUES TO ACCT-REC-KEY.
           EXEC CICS STARTBR
                     DATASET(WBACCTDB-DD)
                     RIDFLD(ACCT-REC-KEY)
                     KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                     RESP(RESP-CODE)
                     GTEQ
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-ACCT-NOTOPEN-SB
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-ACCT-ENDFILE-SB
              WHEN OTHER
                 GO TO GET-ACCT-ERROR-SB
           END-EVALUATE.

       GET-ACCT-NEXT.
           EXEC CICS READNEXT
                     DATASET(WBACCTDB-DD)
                     INTO(ACCOUNT-RECORD)
                     LENGTH(LENGTH OF ACCOUNT-RECORD)
                     RIDFLD(ACCT-REC-KEY)
                     KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 IF ACCOUNT-NUMBER NOT = IA-ACCT-NUM THEN
                    GO TO GET-ACCT-NEXT
                 ELSE
                    MOVE ACCOUNT-SSN TO OA-SSN
                    EXEC CICS ENDBR DATASET(WBACCTDB-DD) END-EXEC
                 END-IF
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-ACCT-ENDFILE
              WHEN OTHER
                 GO TO GET-ACCT-ERROR
           END-EVALUATE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-ENDFILE.
           EXEC CICS ENDBR DATASET(WBACCTDB-DD) END-EXEC.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-ERROR.
           EXEC CICS ENDBR DATASET(WBACCTDB-DD) END-EXEC.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error on Account file: Response Code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-ENDFILE-SB.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-NOTOPEN-SB.
           MOVE 'Account file not open' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-ERROR-SB.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error startbr on Account file: Response Code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 1 TO RET-CODE.
           MOVE EC-INVALID-ACCT TO OA-STATUS-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-EXIT.
           EXIT.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       GET-CUST.
           MOVE LOW-VALUES TO CUST-REC-KEY.
           EXEC CICS STARTBR
                     DATASET(WBCUSTDB-DD)
                     RIDFLD(CUST-REC-KEY)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     RESP(RESP-CODE)
                     GTEQ
           END-EXEC.
           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-CUST-NOTOPEN-SB
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-ENDFILE-SB
              WHEN OTHER
                 GO TO GET-CUST-ERROR-SB
           END-EVALUATE.


       GET-CUST-NEXT.
           EXEC CICS READNEXT
                     DATASET(WBCUSTDB-DD)
                     INTO(CUSTOMER-RECORD)
                     LENGTH(LENGTH OF CUSTOMER-RECORD)
                     RIDFLD(CUST-REC-KEY)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.
           EVALUATE RESP-CODE
              WHEN 0
                 IF CUSTOMER-SSN NOT = OA-SSN THEN
                    GO TO GET-CUST-NEXT
                 ELSE
                    EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC
                    IF CUSTOMER-ACCESS-PIN NOT = IA-PIN THEN
                       MOVE 2 TO RET-CODE
                       MOVE EC-INVALID-PIN TO OA-STATUS-CODE
                    ELSE
                       MOVE CUSTOMER-NAME TO OA-NAME
                    END-IF
                    GO TO GET-CUST-EXIT
                 END-IF
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-ENDFILE
              WHEN OTHER
                 GO TO GET-CUST-ERROR
           END-EVALUATE.
           GO TO GET-CUST-EXIT.

       GET-CUST-ENDFILE.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           MOVE 2 TO RET-CODE.
           MOVE EC-INVALID-PIN TO OA-STATUS-CODE.
           GO TO GET-CUST-EXIT.

       GET-CUST-ERROR.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error on Customer file: Response Code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 2 TO RET-CODE.
           MOVE EC-INVALID-PIN TO OA-STATUS-CODE.
           GO TO GET-CUST-EXIT.

       GET-CUST-ENDFILE-SB.
           MOVE 2 TO RET-CODE.
           MOVE EC-INVALID-PIN TO OA-STATUS-CODE.
           GO TO GET-CUST-EXIT.

       GET-CUST-ERROR-SB.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O error startbr on Customer file: Response Code='
                           DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 2 TO RET-CODE.
           MOVE EC-INVALID-PIN TO OA-STATUS-CODE.
           GO TO GET-CUST-EXIT.

       GET-CUST-NOTOPEN-SB.
           MOVE 'Account file not open' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 2 TO RET-CODE.
           MOVE EC-INVALID-PIN TO OA-STATUS-CODE.
           GO TO GET-CUST-EXIT.

       GET-CUST-EXIT.
           EXIT.

       WBVALUSR-EOC.
           MOVE 'Receive Condition: EOC' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-EOC-EXIT.
           EXIT.

       WBVALUSR-EODS.
           MOVE 'Receive Condition: EODS' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-EODS-EXIT.
           EXIT.

       WBVALUSR-INBFMH.
           MOVE 'Receive Condition: INBFMH' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-INBFMH-EXIT.
           EXIT.

       WBVALUSR-LENGERR.
           MOVE 'Receive Condition: LENGERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-LENGERR-EXIT.
           EXIT.

       WBVALUSR-SIGNAL-RECV.
           MOVE 'Receive Condition: SIGNAL' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-SIGNAL-RECV-EXIT.
           EXIT.

       WBVALUSR-TERMERR-RECV.
           MOVE 'Receive Condition: TERMERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-TERMERR-RECV-EXIT.
           EXIT.

       WBVALUSR-RECV-ERROR.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Receive error: Response Code=' DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO LOG-MSG-BUFFER
           END-STRING.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-RECV-ERROR-EXIT.
           EXIT.

       WBVALUSR-SIGNAL-SEND.
           MOVE 'Send Condition: SIGNAL' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-SIGNAL-SEND-EXIT.
           EXIT.

       WBVALUSR-TERMERR-SEND.
           MOVE 'Send Condition: TERMERR' to LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           GO TO END-WBVALUSR.

       WBVALUSR-TERMERR-SEND-EXIT.
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

       END-WBVALUSR.
           EXEC CICS RETURN END-EXEC.

       END-WBVALUSR-EXIT.
           EXIT.
