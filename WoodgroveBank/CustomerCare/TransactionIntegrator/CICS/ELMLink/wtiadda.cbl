      *****************************************************************
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      *
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WTIADDA.
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

       01 CURRENT-DATE.
          05 CURRENT-DATE-MM              PIC XX.
          05 FILLER                       PIC X.
          05 CURRENT-DATE-DD              PIC XX.
          05 FILLER                       PIC X.
          05 CURRENT-DATE-YYYY            PIC 9999.

       01 GOT-ACCT                    PIC X             VALUE 'N'.
       01 ACCT-NUMBER-NUMERIC         PIC 9(10).
       01 UTIME                       PIC S9(15) COMP-3.
       01 FILLER REDEFINES UTIME.
          05 FILLER                   PIC X(3).
          05 UTIME-X                  PIC S9(9)   COMP-3.
       01 UTIME-YEAR                  PIC S9(8)   COMP VALUE 0.
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
             10 ACCOUNT-TYPE-CODE           PIC X.
             10 ACCOUNT-AREA                PIC X(39).
             10 ACCOUNT-NUMBER-RETURN       PIC X(10).

       PROCEDURE DIVISION.
           MOVE 0 TO SERRORCODE RET-CODE
                     SRETURNERRORTOCLIENT.
           MOVE SPACES TO BSTRHELPSTRING.

           PERFORM GET-DATE THRU GET-DATE-EXIT.
           PERFORM CHECK-CUST-NAME THRU CHECK-CUST-NAME-EXIT.

           IF RET-CODE = 0 THEN
              PERFORM ADD-ACCT THRU ADD-ACCT-EXIT
           END-IF.

           IF RET-CODE = 0 THEN
              PERFORM ADD-TX-DETAIL THRU ADD-TX-DETAIL-EXIT
           END-IF.

           MOVE ACCOUNT-NUMBER OF ACCOUNT-RECORD TO
                ACCOUNT-NUMBER-RETURN.

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
                 MOVE 0 TO SERRORCODE RET-CODE
                 GO TO CHECK-CUST-NAME-EXIT
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

       CHECK-CUST-NAME-NOTFND.
           MOVE 5002 TO SERRORCODE RET-CODE.
           MOVE 'Customer does not exist' TO BSTRHELPSTRING.
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

       ADD-ACCT.
      **************************************************
      *    ADD THE CUSTOMER RECORD TO THE VSAM DATA SET
      **************************************************
           MOVE ACCOUNT-AREA OF USER-DATA TO
                ACCOUNT-AREA OF ACCOUNT-RECORD.
           MOVE CUSTOMER-SSN TO ACCOUNT-SSN.
           PERFORM GET-NEW-ACCT-NUM THRU GET-NEW-ACCT-NUM-EXIT.
           MOVE ACCOUNT-TYPE-CODE OF USER-DATA TO
                ACCOUNT-TYPE-CODE OF ACCOUNT-RECORD.
           EVALUATE ACCOUNT-TYPE-CODE OF ACCOUNT-RECORD
              WHEN 'C'
                 MOVE 'Checking' TO ACCOUNT-TYPE-CODE OF ACCOUNT-RECORD
              WHEN 'S'
                 MOVE 'Savings'  TO ACCOUNT-TYPE-CODE OF ACCOUNT-RECORD
              WHEN OTHER
                 MOVE 'Invalid Account Type code, use "C" or "S"' TO
                      BSTRHELPSTRING
                 MOVE 5004 TO SERRORCODE RET-CODE
                 GO TO ADD-ACCT
           END-EVALUATE.
           MOVE ACCOUNT-AREA OF USER-DATA TO
                ACCOUNT-AREA OF ACCOUNT-RECORD.

           MOVE ACCOUNT-SSN OF ACCOUNT-RECORD TO SSN OF ACCT-REC-KEY.
           MOVE ACCOUNT-NUMBER OF ACCOUNT-RECORD TO
                NUM OF ACCT-REC-KEY.
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
                 GO TO ADD-ACCT-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Account file not open' TO BSTRHELPSTRING
                 MOVE 5005 TO SERRORCODE RET-CODE
                 GO TO ADD-ACCT-EXIT
              WHEN DFHRESP(DUPREC)
                 GO TO ADD-ACCT-DUPLICATE
              WHEN DFHRESP(DUPKEY)
                 GO TO ADD-ACCT-DUPLICATE
              WHEN OTHER
                 GO TO ADD-ACCT-ERROR
           END-EVALUATE.

           GO TO ADD-ACCT-EXIT.

       ADD-ACCT-DUPLICATE.
           MOVE 'Customer account already defined' TO BSTRHELPSTRING.
           MOVE 5006 TO SERRORCODE RET-CODE.
           GO TO ADD-ACCT-EXIT.

       ADD-ACCT-ERROR.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Error occurred writing the Account VSAM file, '
                                   DELIMITED SIZE
                  'Response code=' DELIMITED SIZE
                  EDIT-NUM         DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE 5007 TO SERRORCODE RET-CODE.
           GO TO ADD-ACCT-EXIT.

       ADD-ACCT-EXIT.
           EXIT.

      **************************************************
      *    ADD THE TRANSACTION DETAIL TO THE VSAM DATA SET
      **************************************************
       ADD-TX-DETAIL.
           MOVE CURRENT-DATE   TO TXN-DATE.
           MOVE ACCOUNT-SSN    OF ACCOUNT-RECORD TO TXN-SSN.
           MOVE ACCOUNT-NUMBER OF ACCOUNT-RECORD TO TXN-ACCT-NUM.
           MOVE 1              TO TXN-ITEM-NUM
           MOVE 'B'            TO TXN-TYPE.
           EVALUATE ACCOUNT-TYPE-CODE OF ACCOUNT-RECORD
              WHEN 'C'
                 MOVE ACCOUNT-CHK-BAL OF ACCOUNT-RECORD TO TXN-AMOUNT
              WHEN 'S'
                 MOVE ACCOUNT-SAV-BAL OF ACCOUNT-RECORD TO TXN-AMOUNT
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
                 MOVE 5008 TO SERRORCODE RET-CODE
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN DFHRESP(DUPKEY)
                 MOVE 5009 TO SERRORCODE RET-CODE
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 5010 TO SERRORCODE RET-CODE
                 GO TO ADD-TX-DETAIL-EXIT
              WHEN OTHER
                 GO TO ADD-TX-DETAIL-ERROR
           END-EVALUATE.

           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-ERROR.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Error writing Txn Detail, response code='
                              DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE BSTRHELPSTRING TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT.
           MOVE 5011 TO SERRORCODE RET-CODE
           GO TO ADD-TX-DETAIL-EXIT.

       ADD-TX-DETAIL-EXIT.
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
              MOVE ACCT-NUMBER-NUMERIC TO
                   NUM            OF ACCT-REC-KEY
                   ACCOUNT-NUMBER OF ACCOUNT-RECORD
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
                         BSTRHELPSTRING
                    MOVE 5012 TO SERRORCODE RET-CODE
                    GO TO GET-NEW-ACCT-NUM-EXIT

                 WHEN OTHER
                    MOVE SPACES  TO BSTRHELPSTRING
                    MOVE RESP-CODE TO EDIT-NUM
                    STRING 'Error getting acct #: RESP-CODE='
                            DELIMITED SIZE
                           EDIT-NUM  DELIMITED SIZE
                           INTO BSTRHELPSTRING
                    END-STRING
                    MOVE BSTRHELPSTRING TO LOG-MSG-BUFFER
                    PERFORM WRITE-LOG-MSG THRU WRITE-LOG-MSG-EXIT
                    MOVE 5013 TO SERRORCODE RET-CODE
                    GO TO GET-NEW-ACCT-NUM-EXIT

              END-EVALUATE
           END-PERFORM.

       GET-NEW-ACCT-NUM-EXIT.
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

