       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBJSON.
       AUTHOR. ADO DEMO.
       DATE-WRITTEN. 14-APR-2023.
       DATE-COMPILED.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT WS-INFILE ASSIGN TO INPUT01
           FILE STATUS IS WS-INFILE-SW.

           SELECT WS-OUTFILE ASSIGN TO OUTFL01
           FILE STATUS IS WS-OUTFILE-SW.

       DATA DIVISION.
       FILE SECTION.
       FD WS-INFILE.
       01 INP-CUST-REC.
          COPY AALFATS.

       FD WS-OUTFILE.
       01 OUT-CUST-REC   PIC X(5000).

       WORKING-STORAGE SECTION.
       01 JSON-TEXT                     PIC N(15000) NATIONAL.
       01 I                             PIC S9(09) COMP.
       01 WS-SWITCH.
          05 WS-INFILE-SW           PIC X(02) VALUE SPACES.
             88 WS-INFILE-SUCESS              VALUE '00'.
             88 WS-INFILE-EOF                 VALUE '10'.
          05 WS-OUTFILE-SW          PIC X(02) VALUE SPACES.
             88 WS-OUTFILE-SUCCESS            VALUE '00'.
          05 WS-DATA-MOVE-SW        PIC X(01) VALUE SPACE.
             88 WS-DATA-MOVE-DONE             VALUE 'Y'.
          05 WS-EOF-SW              PIC X(01) VALUE 'N'.
             88 WS-EOF-NO                     VALUE 'N'.
             88 WS-EOF-YES                    VALUE 'Y'.
       01 WS-SUBSCRIPTS.
          05 WS-PROD-SUB            PIC S9(04) COMP VALUE +0.
          05 WS-ORDR-SUB            PIC S9(04) COMP VALUE +0.
          05 WS-SUB                 PIC S9(04) COMP VALUE +0.
          05 WS-SUB2                PIC S9(04) COMP VALUE +0.
       01 WS-COUNTERS.
          05 WS-INP-REC-CNT         PIC  9(09) COMP VALUE  0.
          05 WS-OUT-REC             PIC S9(09) COMP VALUE +0.
          05 WS-OUT-REC-CNT         PIC  9(09) COMP VALUE  0.

       01 WS-CONSTANT.
          05 WS-ORDID               PIC 9(08) VALUE 10000000.
          05 WS-CUSTID              PIC 9(09) VALUE 50000000.
       01 WS-VARIABLES.
          05 WS-INTEGER-DATE        PIC 9(08).
          05 WS-INTEGER-DATE2       PIC 9(08).
          05 WS-INTEGER-DATE5       PIC 9(08).
          05 WS-CURRENT-DATE-DATA.
             10 WS-CURRENT-DATE.
                15 WS-CURRENT-YEAR  PIC 9(04).
                15 WS-CURRENT-MONTH PIC 9(02).
                15 WS-CURRENT-DAY   PIC 9(02).
              10 WS-CURRENT-TIME.
                15 WS-CURRENT-HOURS PIC 9(02).
                15 WS-CURRENT-MINUTE PIC 9(02).
                15 WS-CURRENT-SECOND PIC 9(02).
                15 WS-CURRENT-MILLIS PIC 9(02).
          05 WS-CURRENT-DATE-ALPHA.
             10 WS-CURRENT-YYYY     PIC X(04).
             10 WS-CURRENT-DASH1    PIC X(01) VALUE "-".
             10 WS-CURRENT-MM       PIC X(02).
             10 WS-CURRENT-DASH2    PIC X(01) VALUE "-".
             10 WS-CURRENT-DD       PIC X(02).
          05 WS-FUTURE-DATE2        PIC 9(08).
          05 WS-FUTURE-DATE2-DATA REDEFINES WS-FUTURE-DATE2.
             10 WS-FUTURE2-YEAR     PIC 9(04).
             10 WS-FUTURE2-MONTH    PIC 9(02).
             10 WS-FUTURE2-DAY      PIC 9(02).
          05 WS-FUTURE-DATE2-ALPHA.
             10 WS-FUTURE2-YYYY     PIC X(04).
             10 WS-FUTURE2-DASH1    PIC X(01) VALUE "-".
             10 WS-FUTURE2-MM       PIC X(02).
             10 WS-FUTURE2-DASH2    PIC X(01) VALUE "-".
             10 WS-FUTURE2-DD       PIC X(02).
          05 WS-FUTURE-DATE5        PIC 9(08).
          05 WS-FUTURE-DATE5-DATA REDEFINES WS-FUTURE-DATE5.
             10 WS-FUTURE5-YEAR     PIC 9(04).
             10 WS-FUTURE5-MONTH    PIC 9(02).
             10 WS-FUTURE5-DAY      PIC 9(02).
          05 WS-FUTURE-DATE5-ALPHA.
             10 WS-FUTURE5-YYYY     PIC X(04).
             10 WS-FUTURE5-DASH1    PIC X(01) VALUE "-".
             10 WS-FUTURE5-MM       PIC X(02).
             10 WS-FUTURE5-DASH2    PIC X(01) VALUE "-".
             10 WS-FUTURE5-DD       PIC X(02).


      ******************************************************************
      *            P R O C E D U R E     D I V I S I O N
      ******************************************************************
       PROCEDURE DIVISION.

       A1000-MAIN-PARA.

           PERFORM B1000-INIT-PARA
              THRU B1000-EXIT.

           PERFORM C1000-PROCESS-DATA
              THRU C1000-EXIT
              UNTIL WS-EOF-SW = 'Y'.

           PERFORM Z1000-CLOSE-PARA
              THRU Z1000-EXIT.

           PERFORM Z9000-STOP-RUN
              THRU Z9000-EXIT.

       A1000-EXIT.
           EXIT.

      ******************************************************************
      *                  O P E N    F I L E S
      ******************************************************************

       B1000-INIT-PARA.
           INITIALIZE WS-INFILE-SW
                      WS-OUTFILE-SW
                      WS-EOF-SW.

           OPEN INPUT  WS-INFILE
           OPEN OUTPUT WS-OUTFILE

           IF WS-INFILE-SUCESS
              DISPLAY 'INFILE OPEN SUCCESSFUL'
           ELSE
              DISPLAY 'INFILE OPENING ERROR STATUS IS :'
                      WS-INFILE-SW
              GO TO Z9000-STOP-RUN
           END-IF.

           IF WS-OUTFILE-SUCCESS
              DISPLAY 'OUTFILE OPEN SUCCESSFUL'
           ELSE
              DISPLAY 'OUTFILE OPENING ERROR STATUS IS :'
                      WS-OUTFILE-SW
              GO TO Z9000-STOP-RUN
           END-IF.

           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA.
           DISPLAY 'WS-CURRENT-DATE :' WS-CURRENT-DATE

           .
       B1000-EXIT.
           EXIT.

      ******************************************************************
      *                P R O C E S S    D A T A
      ******************************************************************

       C1000-PROCESS-DATA.

           PERFORM R1000-READ-INPUT
              THRU R1000-EXIT

           PERFORM C2000-MOVE-DATA
              THRU C2000-EXIT

           .
       C1000-EXIT.
           EXIT.
      ******************************************************************
      *                 M O V E    D A T A
      ******************************************************************

       C2000-MOVE-DATA.

           ADD +1           TO WS-OUT-REC
      *    INSPECT FATS-REC    REPLACING ALL X'00' BY X'40'.
      *
           EVALUATE RECORD-TYPE
               WHEN 'AA'
                   JSON GENERATE JSON-TEXT FROM AA-REC-TYPE
                      COUNT IN I
                      ON EXCEPTION
                       DISPLAY 'JSON GENERATE ERRORS: ' JSON-CODE
                   END-JSON

               WHEN 'HI'
                   JSON GENERATE JSON-TEXT FROM HI-REC-TYPE
                      COUNT IN I
                      ON EXCEPTION
                       DISPLAY 'JSON GENERATE ERRORS: ' JSON-CODE
                   END-JSON

           END-EVALUATE.

           PERFORM W1000-WRITE-DATA
              THRU W1000-EXIT
           .
       C2000-EXIT.
           EXIT.


      ******************************************************************
      *                 W R I T E   O U T F I L E
      ******************************************************************
       W1000-WRITE-DATA.

           ADD  1      TO WS-OUT-REC-CNT.
           MOVE FUNCTION DISPLAY-OF(JSON-TEXT(1:I), 1140)
           TO OUT-CUST-REC
           WRITE OUT-CUST-REC.
           INITIALIZE JSON-TEXT.
           INITIALIZE OUT-CUST-REC.

       W1000-EXIT.
           EXIT.

       Z1000-CLOSE-PARA.
           CLOSE WS-INFILE.
           DISPLAY '*******************************************'
           DISPLAY '* TOTAL INPUT RECORDS READ     :' WS-INP-REC-CNT
           DISPLAY '* TOTAL OUTPUT RECORDS WRITTEN :' WS-OUT-REC-CNT
           DISPLAY '*******************************************'
           .

       Z1000-EXIT.
           EXIT.
      ******************************************************************
      *                      R E A D    F I L E
      ******************************************************************
       R1000-READ-INPUT.

           READ WS-INFILE
             AT END MOVE 'Y' TO WS-EOF-SW
             NOT AT END ADD  1 TO WS-INP-REC-CNT
           END-READ.


       R1000-EXIT.
           EXIT.
      ******************************************************************
      *                     S T O P   R U N
      ******************************************************************
       Z9000-STOP-RUN.
           STOP RUN.
       Z9000-EXIT.
           EXIT.
