      *****************************************************************
      ** THIS PROGRAM IS A SAMPLE CICS CLIENT FOR DEMONSTRATING A 3270*
      ** APPLICATION THAT READS AND WRITE TO A VSAM DATA SET FOR      *
      ** BANKING TYPE OF INFORMATION.                                 *
      **                                                              *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WTIGBAL.
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
             10 ACCT-BAL                    PIC S9(13)V99  COMP-3.
             10 CUST-NAME                   PIC X(30).
             10 CUST-ACCT                   PIC X(10).

       PROCEDURE DIVISION.

           MOVE 0 TO SERRORCODE RET-CODE
                     SRETURNERRORTOCLIENT.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE 0 TO ACCT-BAL OF USER-DATA.
           PERFORM GET-CUST-SSN THRU GET-CUST-SSN-EXIT.

           IF RET-CODE = 0 THEN
              PERFORM GET-ACCT THRU GET-ACCT-EXIT
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
           MOVE 5002 TO  SERRORCODE RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-ERROR.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error one Customer file, response code='
                            DELIMITED SIZE
                  EDIT-NUM  DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE 5003 TO  SERRORCODE RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-EXIT.
           EXIT.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       GET-ACCT.
           MOVE CUSTOMER-SSN           TO SSN OF ACCT-REC-KEY.
           MOVE CUST-ACCT OF USER-DATA TO NUM OF ACCT-REC-KEY.

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
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-ACCT-NOTOPEN
              WHEN DFHRESP(DISABLED)
                 GO TO GET-ACCT-NOTOPEN
              WHEN DFHRESP(NOTFND)
                 GO TO GET-ACCT-NOTFND
              WHEN OTHER
                 GO TO GET-ACCT-ERROR
           END-EVALUATE.

           EVALUATE ACCOUNT-TYPE-CODE
              WHEN 'C'
                 MOVE ACCOUNT-CHK-BAL TO ACCT-BAL OF USER-DATA

              WHEN 'S'
                 MOVE ACCOUNT-SAV-BAL TO ACCT-BAL OF USER-DATA

              WHEN OTHER
                 MOVE 0 TO ACCT-BAL OF USER-DATA
                 MOVE 'Invalid Account type' TO BSTRHELPSTRING
                 MOVE 5004 TO  SERRORCODE RET-CODE

           END-EVALUATE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-NOTFND.
           MOVE 'Customer account not found' TO BSTRHELPSTRING.
           MOVE 5005 TO  SERRORCODE RET-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-ERROR.
           MOVE SPACES TO BSTRHELPSTRING.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'I/O Error one Accounts file, response code='
                            DELIMITED SIZE
                  EDIT-NUM  DELIMITED SIZE
                  INTO BSTRHELPSTRING
           END-STRING.
           MOVE 5006 TO  SERRORCODE RET-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-NOTOPEN.
           MOVE 'Accounts file not open' TO BSTRHELPSTRING.
           MOVE 5004 TO  SERRORCODE RET-CODE.
           GO TO GET-ACCT-EXIT.

       GET-ACCT-EXIT.
           EXIT.
