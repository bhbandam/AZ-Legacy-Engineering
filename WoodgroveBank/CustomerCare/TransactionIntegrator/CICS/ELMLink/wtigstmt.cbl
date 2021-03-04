      *****************************************************************
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      *
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WTIGSTMT.
       ENVIRONMENT DIVISION.

       DATA DIVISION.

      *****************************************************************
      ** VARIABLES FOR INTERACTING WITH THE TERMINAL SESSION          *
      *****************************************************************
       WORKING-STORAGE SECTION.

       01 LOG-MSG.
          05 LOG-ID                         PIC X(7)   VALUE 'TASK #'.
          05 TASK-NUMBER                    PIC 9(7).
          05 FILLER                         PIC X      VALUE SPACE.
          05 LOG-MSG-BUFFER                 PIC X(80)  VALUE SPACES.

       01 ENABLE-LOGGING                    PIC X          VALUE 'Y'.
          88 LOGGING-IS-ENABLED                            VALUE 'Y'.
          88 LOGGING-IS-DISABLED                           VALUE 'N'.

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

       01 HW-LENGTH                   PIC S9(4)   COMP  VALUE +0.
       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.

       LINKAGE SECTION.

       01 DFHCOMMAREA.
      *      If the entire commarea (32767) is required for user data
      *      consider using CWA, TWA, Temp Storage or other techniques
          05 SCRATCH-PAD-AREA.
             10 SPA-NEXT-SSN                PIC X(9).
             10 SPA-NEXT-ACCT               PIC X(10).
             10 SPA-NEXT-ITEM-NUM           PIC S9(7)  COMP-3.
             10 FILLER                      PIC X(233).
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
             10 CUST-NAME                   PIC X(30).
             10 MAX-OUT-ACCTS               PIC S9(4) COMP.
             10 MORE-ACCTS                  PIC S9(4) COMP.
             10 STMT-CNT                    PIC S9(4) COMP.
             10 STMT-INFO OCCURS 979 TIMES DEPENDING ON STMT-CNT.
                15 STMT-ACCT-NUM            PIC X(10).
                15 STMT-ITEM-NUM            PIC S9(7)     COMP-3.
                15 STMT-TYPE                PIC X.
                15 STMT-DATE                PIC X(10).
                15 STMT-AMOUNT              PIC S9(13)V99  COMP-3.

       PROCEDURE DIVISION.
           MOVE 0 TO SERRORCODE RET-CODE
                     MORE-ACCTS SRETURNERRORTOCLIENT.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE 0 TO STMT-CNT OF USER-DATA.

           PERFORM GET-CUST-SSN THRU GET-CUST-SSN-EXIT.

           IF RET-CODE = 0 THEN
              PERFORM GET-TXN-DETAILS THRU GET-TXN-DETAILS-EXIT
           END-IF.

           IF SERRORCODE NOT = 0 THEN
              MOVE 1 TO SRETURNERRORTOCLIENT
           END-IF.
           EXEC CICS RETURN END-EXEC.

      **************************************************
      *    READ THE CUSTOMER SSN FROM THE VSAM DATA SET
      **************************************************
       GET-CUST-SSN.
           MOVE CUST-NAME OF USER-DATA TO NAME OF CUST-REC-KEY.
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
                 GO TO GET-CUST-SSN-EXIT
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-CUST-SSN-NOTOPEN
              WHEN DFHRESP(DISABLED)
                 GO TO GET-CUST-SSN-NOTOPEN
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN OTHER
                 GO TO GET-CUST-SSN-ERROR
           END-EVALUATE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-NOTOPEN.
           MOVE 'Customer file not open' TO BSTRHELPSTRING.
           MOVE 5001 TO SERRORCODE RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-NOTFND.
           MOVE 'Customer name not found' TO BSTRHELPSTRING.
           MOVE 5002 TO SERRORCODE RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-ERROR.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error one Customer file, response code='
                            DELIMITED SIZE
                  EDIT-NUM  DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE 5003 TO SERRORCODE RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-EXIT.
           EXIT.

      **************************************************
      *    READ THE TRANSACTION DETAILS FROM VSAM DATA SET
      **************************************************
       GET-TXN-DETAILS.
           IF SCRATCH-PAD-AREA = LOW-VALUES THEN
              MOVE CUSTOMER-SSN TO SSN OF TXN-REC-KEY
              EXEC CICS STARTBR
                        DATASET(WBTXNDB-DD)
                        RIDFLD(TXN-REC-KEY)
                        KEYLENGTH(LENGTH OF SSN OF TXN-REC-KEY)
                        GENERIC
                        RESP(RESP-CODE)
              END-EXEC
           ELSE
              MOVE SPA-NEXT-SSN      TO SSN      OF TXN-REC-KEY
              MOVE SPA-NEXT-ACCT     TO NUM      OF TXN-REC-KEY
              MOVE SPA-NEXT-ITEM-NUM TO ITEM-NUM OF TXN-REC-KEY
              EXEC CICS STARTBR
                        DATASET(WBTXNDB-DD)
                        RIDFLD(TXN-REC-KEY)
                        KEYLENGTH(LENGTH OF TXN-REC-KEY)
                        RESP(RESP-CODE)
                        EQUAL
              END-EXEC
           END-IF.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-TXN-DETAILS-NOTOPEN-SB
              WHEN DFHRESP(DISABLED)
                 GO TO GET-TXN-DETAILS-NOTOPEN-SB
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-TXN-DETAILS-ENDFILE-SB
              WHEN DFHRESP(NOTFND)
                 GO TO GET-TXN-DETAILS-ENDFILE-SB
              WHEN OTHER
                 GO TO GET-TXN-DETAILS-ERROR-SB
           END-EVALUATE.

       GET-TXN-DETAILS-NEXT.
           EXEC CICS READNEXT
                     DATASET(WBTXNDB-DD)
                     INTO(TXN-DETAILS)
                     LENGTH(LENGTH OF TXN-DETAILS)
                     KEYLENGTH(LENGTH OF TXN-REC-KEY)
                     RIDFLD(TXN-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 IF TXN-SSN NOT = CUSTOMER-SSN THEN
                    GO TO GET-TXN-DETAILS-ENDFILE
                 END-IF
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-TXN-DETAILS-ENDFILE
              WHEN OTHER
                 GO TO GET-TXN-DETAILS-ERROR
           END-EVALUATE.

           IF STMT-CNT >= MAX-OUT-ACCTS THEN
              MOVE TXN-SSN      TO SPA-NEXT-SSN
              MOVE TXN-ACCT-NUM TO SPA-NEXT-ACCT
              MOVE TXN-ITEM-NUM TO SPA-NEXT-ITEM-NUM
              MOVE 1 TO MORE-ACCTS
              GO TO GET-TXN-DETAILS-MORE-ACCTS
           END-IF

           ADD 1 TO STMT-CNT OF USER-DATA.
           MOVE TXN-ACCT-NUM TO STMT-ACCT-NUM(STMT-CNT).
           MOVE TXN-ITEM-NUM TO STMT-ITEM-NUM(STMT-CNT).
           MOVE TXN-TYPE     TO STMT-TYPE(STMT-CNT).
           MOVE TXN-DATE     TO STMT-DATE(STMT-CNT).
           MOVE TXN-AMOUNT   TO STMT-AMOUNT(STMT-CNT).
           GO TO GET-TXN-DETAILS-NEXT.

       GET-TXN-DETAILS-MORE-ACCTS.
           EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-ENDFILE.
           EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC.
           GO TO GET-TXN-DETAILS-ENDFILE-SB.

       GET-TXN-DETAILS-ENDFILE-SB.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-ERROR.
           EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC.
           GO TO GET-TXN-DETAILS-ERROR-SB.

       GET-TXN-DETAILS-ERROR-SB.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error one Accounts file, response code='
                            DELIMITED SIZE
                  EDIT-NUM  DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE 5005 TO SERRORCODE RET-CODE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-NOTOPEN-SB.
           MOVE 'Accounts file not open' TO BSTRHELPSTRING.
           MOVE 5006 TO SERRORCODE RET-CODE.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-EXIT.
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

