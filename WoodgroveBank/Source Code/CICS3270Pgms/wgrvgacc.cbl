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
       PROGRAM-ID. WGRVGACC.
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

           EXEC CICS HANDLE AID CLEAR(END-WGRVGACC)
                                PF3(END-WGRVGACC)
                                PF4(XFER-WGRVGBAL)
                                PF6(XFER-WGRVGCUS)
                                PF7(XFER-WGRVGDET)
                                PF8(XFER-WGRVADDC)
                                PF9(XFER-WGRVADDA)
                                PF10(XFER-WGRVCUSL) END-EXEC.

           PERFORM SET-MAP-DEFAULTS THRU SET-MAP-DEFAULTS-EXIT.
           EXEC CICS SEND MAP('GANAME') MAPSET('WGRVMAP')
                          MAPONLY ERASE END-EXEC.

           PERFORM UNTIL DONE = 'Y'
              EXEC CICS RECEIVE MAP('GANAME') MAPSET('WGRVMAP')
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
              MOVE LOW-VALUE TO GAHPAGNA
              MOVE PAGEN TO GAHPAGNO
              EXEC CICS SEND MAP('GAHEAD') MAPSET('WGRVMAP')
                             ACCUM PAGING ERASE
              END-EXEC

              PERFORM GET-ACCTS THRU GET-ACCTS-EXIT
              EXEC CICS RECEIVE INTO(TEMPDATA)
                                LENGTH(TEMPLENG) END-EXEC
           END-IF.

           EXEC CICS RETURN END-EXEC.

      **************************************************************
      ** FORMAT AN ERROR MESSAGE TO SEND TO THE TERMINAL USER     **
      **************************************************************
       FORMAT-ERROR-MSG.
           EXEC CICS SEND MAP('GANAME') MAPSET('WGRVMAP')
                          FROM (GANAMEO) ERASE END-EXEC.

       FORMAT-ERROR-MSG-EXIT.
           EXIT.

      **************************************************************
      ** SET THE DEFAULT DATA ITEMS IN THE CEDAR BANK MAP         **
      **************************************************************
       SET-MAP-DEFAULTS.
           MOVE 'WBGA' TO GATRANO GANXTTRO.
           MOVE SPACES TO GANNAMEO.
           MOVE SPACES TO GANMSG1O.
           MOVE SPACES TO GANMSG2O.

       SET-MAP-DEFAULTS-EXIT.
           EXIT.

      **************************************************************
      ** VALIDATE THE INFORMATION IN THE MAP                      **
      **************************************************************
       VALIDATE-INPUT.
           IF GANNAMEL = 0 OR GANNAMEI = SPACES
               MOVE 'Name is invalid' TO GANMSG1O
               MOVE 1 TO RET-CODE
               MOVE SPACES TO NAME OF CUST-REC-KEY
               GO TO VALIDATE-INPUT-EXIT
           END-IF.
           MOVE SPACES TO GANMSG1O.
           MOVE 0 TO RET-CODE.
           MOVE GANNAMEI TO NAME OF CUST-REC-KEY.

       VALIDATE-INPUT-EXIT.
           EXIT.

      **************************************************
      *    READ THE CUSTOMER SSN FROM THE VSAM DATA SET
      **************************************************
       GET-CUST-SSN.
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
                 MOVE CUSTOMER-SSN TO SSN OF ACCT-REC-KEY
                 MOVE 0 TO RET-CODE
                 MOVE SPACES TO GANMSG1O
                 GO TO GET-CUST-SSN-EXIT
              WHEN DFHRESP(NOTOPEN)
                 MOVE 'Customer file not open' TO GANMSG1O
                 MOVE 1 TO RET-CODE
                 GO TO GET-CUST-SSN-EXIT
              WHEN DFHRESP(NOTFND)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-CUST-SSN-NOTFND
              WHEN OTHER
                 GO TO GET-CUST-SSN-ERROR
           END-EVALUATE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-NOTFND.
           MOVE 'Customer name not found' TO GANMSG1O.
           MOVE 2 TO RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-ERROR.
           MOVE 'Error occurred reading the Customer VSAM file'
                 TO GANMSG1O.
           MOVE RESP-CODE TO EDIT-NUM.
           STRING 'Response code=' DELIMITED SIZE
                  EDIT-NUM DELIMITED SIZE
                  INTO GANMSG2O
           END-STRING.
           MOVE 3 TO RET-CODE.
           GO TO GET-CUST-SSN-EXIT.

       GET-CUST-SSN-EXIT.
           EXIT.

      **************************************************
      *    READ THE ACCOUNT INFO FROM VSAM DATA SET
      **************************************************
       GET-ACCTS.
           EXEC CICS HANDLE CONDITION
                            OVERFLOW(GET-ACCTS-OVERFLOW) END-EXEC.

           EXEC CICS STARTBR
                     DATASET(WBACCTDB-DD)
                     RIDFLD(ACCT-REC-KEY)
                     KEYLENGTH(LENGTH OF SSN OF ACCT-REC-KEY)
                     RESP(RESP-CODE)
                     GENERIC
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 CONTINUE
              WHEN DFHRESP(NOTFND)
                 GO TO GET-ACCTS-ENDFILE-SB
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-ACCTS-ENDFILE-SB
              WHEN OTHER
                 GO TO GET-ACCTS-ERROR-SB
           END-EVALUATE.

       GET-ACCTS-NEXT.
           EXEC CICS READNEXT
                     DATASET(WBACCTDB-DD)
                     INTO(ACCOUNT-RECORD)
                     LENGTH(LENGTH OF ACCOUNT-RECORD)
                     KEYLENGTH(LENGTH OF ACCT-REC-KEY)
                     RIDFLD(ACCT-REC-KEY)
                     RESP(RESP-CODE)
           END-EXEC.

           EVALUATE RESP-CODE
              WHEN 0
                 IF ACCOUNT-SSN NOT = CUSTOMER-SSN THEN
                    GO TO GET-ACCTS-ENDFILE
                 END-IF
                 CONTINUE
              WHEN DFHRESP(ENDFILE)
                 GO TO GET-ACCTS-ENDFILE
              WHEN OTHER
                 GO TO GET-ACCTS-ERROR
           END-EVALUATE.

           MOVE LOW-VALUE TO GALINEO.
           MOVE ACCOUNT-NUMBER      TO GALACCTO.
           MOVE ACCOUNT-TYPE-NAME   TO GALTYPEO.

           EVALUATE ACCOUNT-TYPE-CODE
              WHEN 'C'
                 MOVE ACCOUNT-CHK-OD-CHG       TO GALODCHO
                 MOVE ACCOUNT-CHK-OD-LIMIT     TO GALODLMO
                 MOVE ACCOUNT-CHK-OD-LINK-ACCT TO GALODLAO
                 MOVE ACCOUNT-CHK-LAST-STMT    TO GALLSDO
                 MOVE ZERO                     TO GALINTRO
                 MOVE ZERO                     TO GALSCHGO
                 EXEC CICS SEND MAP('GALINE') MAPSET('WGRVMAP')
                                ACCUM PAGING END-EXEC
                 GO TO GET-ACCTS-NEXT

              WHEN 'S'
                 MOVE ZERO                  TO GALODCHO
                 MOVE ZERO                  TO GALODLMO
                 MOVE SPACES                TO GALODLAO
                 MOVE ACCOUNT-SAV-LAST-STMT TO GALLSDO
                 MOVE ACCOUNT-SAV-INT-RATE  TO GALINTRO
                 MOVE ACCOUNT-SAV-SVC-CHRG  TO GALSCHGO
                 EXEC CICS SEND MAP('GALINE') MAPSET('WGRVMAP')
                                ACCUM PAGING END-EXEC
                 GO TO GET-ACCTS-NEXT

              WHEN OTHER
                 GO TO GET-ACCTS-NEXT

           END-EVALUATE.

       GET-ACCTS-OVERFLOW.
           EXEC CICS SEND MAP('GAFOOT') MAPSET('WGRVMAP')
                          MAPONLY ACCUM PAGING END-EXEC.
           ADD 1 TO PAGEN.
           MOVE PAGEN TO GAHPAGNO.

           EXEC CICS SEND MAP('GAHEAD') MAPSET('WGRVMAP')
                          ACCUM PAGING ERASE END-EXEC.

           EXEC CICS SEND MAP('GALINE') MAPSET('WGRVMAP')
                          ACCUM PAGING END-EXEC.

           GO TO GET-ACCTS-NEXT.

       GET-ACCTS-ENDFILE.
           EXEC CICS ENDBR DATASET(WBACCTDB-DD) END-EXEC.
           GO TO GET-ACCTS-ENDFILE-SB.

       GET-ACCTS-ENDFILE-SB.
           EXEC CICS SEND MAP('GAFINAL') MAPSET('WGRVMAP')
                          MAPONLY ACCUM PAGING END-EXEC.
           EXEC CICS SEND PAGE END-EXEC.
           EXEC CICS SEND TEXT FROM(OPINSTR)
                               LENGTH(LENGTH OF OPINSTR)
                               ERASE END-EXEC.
           GO TO GET-ACCTS-EXIT.

       GET-ACCTS-ERROR.
              EXEC CICS ENDBR DATASET(WBACCTDB-DD) END-EXEC.
              GO TO GET-ACCTS-ERROR-SB.

       GET-ACCTS-ERROR-SB.
              EXEC CICS PURGE MESSAGE END-EXEC.
              EXEC CICS ABEND ABCODE('WBER') END-EXEC.

       GET-ACCTS-EXIT.
           EXIT.

       XFER-WGRVGBAL.
           EXEC CICS XCTL PROGRAM('WGRVGBAL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       XFER-WGRVGCUS.
           EXEC CICS XCTL PROGRAM('WGRVGCUS') END-EXEC.
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

       XFER-WGRVCUSL.
           EXEC CICS XCTL PROGRAM('WGRVCUSL') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVGACC.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       END-WGRVGACC-EXIT.
           EXIT.
