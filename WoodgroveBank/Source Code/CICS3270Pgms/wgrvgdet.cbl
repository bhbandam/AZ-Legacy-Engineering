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
       PROGRAM-ID. WGRVGDET.
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

       01 DONE                        PIC X       VALUE 'N'.
       01 RESP-CODE                   PIC S9(9)   COMP  VALUE +0.
       01 WBCUSTDB-DD                 PIC X(8)    VALUE 'WBCUSTDB'.
       01 WBACCTDB-DD                 PIC X(8)    VALUE 'WBACCTDB'.
       01 WBTXNDB-DD                  PIC X(8)    VALUE 'WBTXNDB'.
       01 RET-CODE                    PIC S9(4)   COMP    VALUE 0.
       01 EDIT-NUM                    PIC Z,ZZZ,ZZ9.
       01 TEMPDATA                    PIC X(1).
       01 TEMPLENG                    PIC S9(4)   COMP.
       01 PAGEN                       PIC 9(3)            VALUE 1.
       01 OPINSTR                     PIC X(52)
                VALUE 'Press <Enter> and follow with paging commands.'.

      **** COPY THE BMS MAP DEFINITION FOR CEDAR BANK
       COPY WGRVMAP.

       LINKAGE SECTION.

       PROCEDURE DIVISION.
           EXEC CICS HANDLE AID CLEAR(END-WGRVGDET)
                                PF3(END-WGRVGDET)
                                PF4(XFER-WGRVGBAL)
                                PF5(XFER-WGRVGACC)
                                PF6(XFER-WGRVGCUS)
                                PF8(XFER-WGRVADDC)
                                PF9(XFER-WGRVADDA)
                                PF10(XFER-WGRVCUSL) END-EXEC.

           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.
           EXEC CICS SEND MAP('GDNAME') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           PERFORM UNTIL DONE = 'Y'
              EXEC CICS RECEIVE MAP('GDNAME')
                                MAPSET('WGRVMAP')
                                ASIS END-EXEC

              MOVE 0 TO RET-CODE
              PERFORM VALIDATE-INPUT THRU VALIDATE-INPUT-EXIT
              IF RET-CODE = 0 THEN
                 PERFORM GET-CUST-SSN THRU GET-CUST-SSN-EXIT
              END-IF

              IF RET-CODE NOT = 0 THEN
                 PERFORM FORMAT-ERROR-MSG THRU FORMAT-ERROR-MSG-EXIT
              ELSE
                 MOVE 'Y' TO DONE
              END-IF
           END-PERFORM.

           IF RET-CODE = 0 THEN
              MOVE LOW-VALUE TO GDHPAGNA
              MOVE PAGEN TO GDHPAGNO
              EXEC CICS SEND MAP('GDHEAD') MAPSET('WGRVMAP')
                             ACCUM PAGING ERASE
              END-EXEC

              PERFORM GET-TXN-DETAILS THRU GET-TXN-DETAILS-EXIT
              EXEC CICS RECEIVE INTO(TEMPDATA)
                                LENGTH(TEMPLENG) END-EXEC
           END-IF.

           EXEC CICS RETURN END-EXEC.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-ERROR-MSG.
           EXEC CICS SEND MAP('GDNAME') MAPSET('WGRVMAP')
                          FROM (GDNAMEO) ERASE END-EXEC.

       FORMAT-ERROR-MSG-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS.
           MOVE 'WBGD' TO GDTRANO GDNXTTRO.
           MOVE SPACES TO GDNNAMEO.
           MOVE SPACES TO GDNMSG1O.
           MOVE SPACES TO GDNMSG2O.

       SET-MAP-DEFAULTS-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE MAP                      **
      **************************************************************
       VALIDATE-INPUT.
           IF GDNNAMEL = 0 OR GDNNAMEI = SPACES
               MOVE 'Name is invalid' TO GDNMSG1O
               MOVE 1 TO RET-CODE
               MOVE SPACES TO NAME OF CUST-REC-KEY
               GO TO VALIDATE-INPUT-EXIT
           ELSE
               MOVE SPACES TO GDNMSG1O
               MOVE 0 TO RET-CODE
               MOVE GDNNAMEI TO NAME OF CUST-REC-KEY
           END-IF.

       VALIDATE-INPUT-EXIT.
           EXIT.

       GET-CUST-SSN.
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
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-CUST-SSN-NOTOPEN
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN OTHER
                 GO TO GET-CUST-SSN-ERROR
           END-EVALUATE.

           MOVE CUSTOMER-SSN TO SSN OF ACCT-REC-KEY.
           MOVE 0 TO RET-CODE.
           MOVE SPACES TO GDNMSG1O.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-NOTOPEN.
           MOVE 'Customer file not open' TO GDNMSG1O.
           MOVE 1 TO RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-NOTFND.
           MOVE 'Customer name not found' TO GDNMSG1O.
           MOVE 2 TO RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-ERROR.
           MOVE 'I/O Error reading the Customer file' TO GDNMSG1O.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Response code=' DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO GDNMSG2O
           END-STRING.
           MOVE 3 TO RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-EXIT.
           EXIT.

       GET-TXN-DETAILS.
      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
           EXEC CICS HANDLE CONDITION
                           OVERFLOW(GET-TXN-DETAILS-OVERFLOW) END-EXEC.

           MOVE CUSTOMER-SSN TO SSN OF TXN-REC-KEY.

           EXEC CICS STARTBR
                     DATASET(WBTXNDB-DD)
                     RIDFLD(TXN-REC-KEY)
                     KEYLENGTH(LENGTH OF SSN OF TXN-REC-KEY)
                     RESP(RESP-CODE)
                     GENERIC
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTFND)
                 GO TO GET-TXN-DETAILS-ENDFILE-SB
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-TXN-DETAILS-ENDFILE-SB
              WHEN DFHRESP(ENDFILE)
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
                 CONTINUE
              WHEN DFHRESP(NOTOPEN)
                 GO TO GET-TXN-DETAILS-ENDFILE
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-TXN-DETAILS-ENDFILE
              WHEN OTHER
                 GO TO GET-TXN-DETAILS-ERROR
           END-EVALUATE.

           MOVE LOW-VALUE        TO GDLINEO.
           MOVE TXN-ACCT-NUM     TO GDLACCTO.
           MOVE TXN-ITEM-NUM     TO GDLITEMO.
           EVALUATE TXN-TYPE
              WHEN 'B'
                 MOVE 'Init Bal' TO GDLTYPEO
              WHEN 'O'
                 MOVE 'OD Chrg'  TO GDLTYPEO
              WHEN 'S'
                 MOVE 'Svc Chrg' TO GDLTYPEO
              WHEN 'D'
                 MOVE 'Debit'    TO GDLTYPEO
              WHEN 'C'
                 MOVE 'Credit'   TO GDLTYPEO
              WHEN OTHER
                 MOVE '*'        TO GDLTYPEO
           END-EVALUATE.

           MOVE TXN-DATE         TO GDLDATEO.
           MOVE TXN-AMOUNT       TO GDLAMTO.

           PERFORM GET-ACCT-TYPE THRU GET-ACCT-TYPE-EXIT.
           MOVE ACCOUNT-TYPE-NAME TO GDLACTYO.

           EXEC CICS SEND MAP('GDLINE') MAPSET('WGRVMAP')
                          ACCUM PAGING END-EXEC.
           GO TO GET-TXN-DETAILS-NEXT.

       GET-TXN-DETAILS-OVERFLOW.
           EXEC CICS SEND MAP('GDFOOT') MAPSET('WGRVMAP')
                          MAPONLY ACCUM PAGING END-EXEC.
           ADD 1 TO PAGEN.
           MOVE PAGEN TO GAHPAGNO.

           EXEC CICS SEND MAP('GDHEAD') MAPSET('WGRVMAP')
                          ACCUM PAGING ERASE END-EXEC.

           EXEC CICS SEND MAP('GDLINE') MAPSET('WGRVMAP')
                          ACCUM PAGING END-EXEC.

           GO TO GET-TXN-DETAILS-NEXT.

       GET-TXN-DETAILS-ENDFILE.
           EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC.
           GO TO GET-TXN-DETAILS-ENDFILE-SB.

       GET-TXN-DETAILS-ENDFILE-SB.
           EXEC CICS SEND MAP('GDFINAL') MAPSET('WGRVMAP')
                          MAPONLY ACCUM PAGING END-EXEC.
           EXEC CICS SEND PAGE END-EXEC.
           EXEC CICS SEND TEXT FROM(OPINSTR)
                               LENGTH(LENGTH OF OPINSTR)
                               ERASE END-EXEC.
           GO TO GET-TXN-DETAILS-EXIT.

       GET-TXN-DETAILS-ERROR.
           EXEC CICS ENDBR DATASET(WBTXNDB-DD) END-EXEC.
           GO TO GET-TXN-DETAILS-ERROR-SB.

       GET-TXN-DETAILS-ERROR-SB.
           EXEC CICS PURGE MESSAGE END-EXEC.
           EXEC CICS ABEND ABCODE('WBER') END-EXEC.

       GET-TXN-DETAILS-EXIT.
           EXIT.

       GET-ACCT-TYPE.
      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
           EXEC CICS HANDLE CONDITION
                            ERROR(GET-ACCT-TYPE-ERROR) END-EXEC.

           MOVE TXN-SSN TO SSN OF ACCT-REC-KEY.
           MOVE TXN-ACCT-NUM TO NUM OF ACCT-REC-KEY.
           EXEC CICS READ
                     DATASET(WBACCTDB-DD)
                     INTO(ACCOUNT-RECORD)
                     LENGTH(LENGTH OF ACCOUNT-RECORD)
                     RIDFLD(ACCT-REC-KEY)
                     KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           IF RESP-CODE = 0 THEN
              GO TO GET-ACCT-TYPE-EXIT
           END-IF.

           GO TO GET-ACCT-TYPE-ERROR.

       GET-ACCT-TYPE-ERROR.
           EXEC CICS HANDLE CONDITION ERROR END-EXEC.
           MOVE SPACES TO ACCOUNT-TYPE-NAME
           GO TO GET-ACCT-TYPE-EXIT.

       GET-ACCT-TYPE-EXIT.
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

       XFER-WGRVADDC.
           EXEC CICS XCTL PROGRAM('WGRVADDC') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVADDA.
           EXEC CICS XCTL PROGRAM('WGRVADDA') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVCUSL.
           EXEC CICS XCTL PROGRAM('WGRVCUSL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVGDET.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVGDET-EXIT.
           EXIT.
