      *****************************************************************
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      *
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WTIADDC.
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

       01 LOG-MSG.
          05 LOG-ID                         PIC X(7)   VALUE 'TASK #'.
          05 TASK-NUMBER                    PIC 9(7).
          05 FILLER                         PIC X      VALUE SPACE.
          05 LOG-MSG-BUFFER                 PIC X(80)  VALUE SPACES.

       01 ENABLE-LOGGING                    PIC X          VALUE 'Y'.
          88 LOGGING-IS-ENABLED                            VALUE 'Y'.
          88 LOGGING-IS-DISABLED                           VALUE 'N'.

       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 HW-LENGTH                   PIC S9(4)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.

       LINKAGE SECTION.

       01 DFHCOMMAREA.
      *      If the entire commarea (32767) is required for user data
      *      consider using CWA, TWA, Temp Storage or other techniques
          05 SCRATCH-PAD-AREA               PIC X(256).
          05 METADATAERRBLK.
             10 LMETADATALEN                PIC 9(9) COMP.
             10 BSTRRUNTIMEVERSION          PIC X(32).
             10 BSTRMETHODNAME              PIC X(32).
             10 BSTRPROGID                  PIC X(40).
             10 BSTRCLSID                   PIC X(40).
             10 USMAJORVERSION              PIC 9(4) COMP.
             10 USMINORVERSION              PIC 9(4) COMP.
             10 SREADYTOCOMMIT              PIC 9(4) COMP.
             10 SWILLINGTODOMORE            PIC 9(4) COMP.
             10 SRETURNERRORTOCLIENT        PIC 9(4) COMP.
             10 SERRORCODE                  PIC 9(4) COMP.
             10 LHELPCONTEXT                PIC 9(9) COMP.
             10 BSTRHELPSTRING              PIC X(256).
          05 USER-DATA.
             10 CUSTOMER-NAME               PIC X(30).
             10 CUSTOMER-SSN                PIC X(9).
             10 CUSTOMER-ADDRESS.
                15 CUSTOMER-STREET          PIC X(20).
                15 CUSTOMER-CITY            PIC X(10).
                15 CUSTOMER-STATE           PIC X(4).
                15 CUSTOMER-ZIP             PIC 9(5).
             10 CUSTOMER-PHONE              PIC X(13).
             10 CUSTOMER-ACCESS-PIN         PIC X(4).

       PROCEDURE DIVISION.
           MOVE 0 TO SERRORCODE RET-CODE
                     SRETURNERRORTOCLIENT.
           MOVE SPACES TO BSTRHELPSTRING.

           PERFORM CHECK-CUST-NAME THRU CHECK-CUST-NAME-EXIT.

           IF RET-CODE = 0 THEN
              PERFORM CHECK-CUST-SSN THRU CHECK-CUST-SSN-EXIT
           END-IF.

           IF RET-CODE = 0 THEN
              PERFORM ADD-CUST THRU ADD-CUST-EXIT
           END-IF.

           IF SERRORCODE NOT = 0 THEN
              MOVE 1 TO SRETURNERRORTOCLIENT
           END-IF.
           EXEC CICS RETURN END-EXEC.

      **************************************************
      *    CHECK TO SEE IF THE CUSTOMER NAME EXISTS
      **************************************************
       CHECK-CUST-NAME.
           MOVE CUSTOMER-NAME OF USER-DATA TO NAME OF CUST-REC-KEY.
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
                 GO TO CHECK-CUST-NAME-FOUND
              WHEN DFHRESP(NOTOPEN)
                 GO TO CHECK-CUST-NAME-NOTOPEN
              WHEN DFHRESP(DISABLED)
                 GO TO CHECK-CUST-NAME-NOTOPEN
              WHEN DFHRESP(ENDFILE)
                 GO TO CHECK-CUST-NAME-NOTFND
              WHEN DFHRESP(NOTFND)
                 GO TO CHECK-CUST-NAME-NOTFND
              WHEN OTHER
                 GO TO CHECK-CUST-NAME-ERROR
           END-EVALUATE.

       CHECK-CUST-NAME-NOTOPEN.
           MOVE 'Customer file not open' TO BSTRHELPSTRING.
           MOVE 5001 TO SERRORCODE RET-CODE.
           GO TO CHECK-CUST-NAME-EXIT.

       CHECK-CUST-NAME-FOUND.
           MOVE 'Customer name already exists' TO BSTRHELPSTRING.
           MOVE 5002 TO SERRORCODE RET-CODE.
           GO TO CHECK-CUST-NAME-EXIT.

       CHECK-CUST-NAME-NOTFND.
           MOVE 0 TO RET-CODE.
           GO TO CHECK-CUST-NAME-EXIT.

       CHECK-CUST-NAME-ERROR.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error one Customer file, response code='
                            DELIMITED SIZE
                  EDIT-NUM  DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE 5003 TO  SERRORCODE RET-CODE.
           GO TO CHECK-CUST-NAME-EXIT.

       CHECK-CUST-NAME-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE MAP                      **
      **************************************************************
       CHECK-CUST-SSN.
           MOVE LOW-VALUES TO CUST-REC-KEY.
           EXEC CICS STARTBR DATASET(WBCUSTDB-DD)
                     RIDFLD(CUST-REC-KEY)
                     KEYLENGTH(LENGTH OF CUST-REC-KEY)
                     GTEQ
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN OTHER
                 GO TO CHECK-CUST-SSN-ERROR-SB
           END-EVALUATE.

       CHECK-CUST-SSN-NEXT.
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
                 IF CUSTOMER-SSN OF CUSTOMER-RECORD NOT =
                    CUSTOMER-SSN OF USER-DATA THEN
                    GO TO CHECK-CUST-SSN-NEXT
                 ELSE
                    EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC
                    MOVE 'Duplicate SSN found' TO BSTRHELPSTRING
                    MOVE 5003 TO  SERRORCODE RET-CODE
                    GO TO CHECK-CUST-SSN-EXIT
                 END-IF
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO BSTRHELPSTRING
                 MOVE 5004 TO  SERRORCODE RET-CODE
                 GO TO CHECK-CUST-SSN-EXIT
              WHEN DFHRESP(ENDFILE)
                 EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC
                 MOVE 0 TO RET-CODE
                 GO TO CHECK-CUST-SSN-EXIT
              WHEN OTHER
                 GO TO CHECK-CUST-SSN-ERROR
           END-EVALUATE.
           GO TO CHECK-CUST-SSN-EXIT.

       CHECK-CUST-SSN-ERROR.
           EXEC CICS ENDBR DATASET(WBCUSTDB-DD) END-EXEC.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error on Customer file: Repsonse Code='
                  DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE BSTRHELPSTRING TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 5005 TO  SERRORCODE RET-CODE
           GO TO CHECK-CUST-SSN-EXIT.

       CHECK-CUST-SSN-ERROR-SB.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error on startbr Customer file: Repsonse Code='
                  DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE BSTRHELPSTRING TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 5006 TO SERRORCODE RET-CODE.
           GO TO CHECK-CUST-SSN-EXIT.

       CHECK-CUST-SSN-EXIT.
           EXIT.

       ADD-CUST.
      **************************************************
      *    ADD THE CUSTOMER RECORD TO THE VSAM DATA SET
      **************************************************
           MOVE CORRESPONDING USER-DATA TO CUSTOMER-RECORD.
           MOVE CUSTOMER-NAME OF CUSTOMER-RECORD TO
                NAME OF CUST-REC-KEY.
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
                 GO TO ADD-CUST-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO BSTRHELPSTRING
                 MOVE 5008 TO SERRORCODE RET-CODE
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
           MOVE 'Customer name already defined' TO BSTRHELPSTRING.
           MOVE 5007 TO SERRORCODE RET-CODE.
           GO TO ADD-CUST-EXIT.

       ADD-CUST-ERROR.
           MOVE 'Error occurred writing the Customer VSAM file'
                 TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Error occurred writing the Customer VSAM file, '
                                   DELIMITED SIZE
                  'Response code=' DELIMITED SIZE
                  EDIT-NUM         DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE 5008 TO SERRORCODE RET-CODE.
           GO TO ADD-CUST-EXIT.

       ADD-CUST-EXIT.
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

