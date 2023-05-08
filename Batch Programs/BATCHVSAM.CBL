000100*------------------------                                         00010000
000200 IDENTIFICATION DIVISION.                                         00020000
000300*------------------------                                         00030000
000400 PROGRAM-ID. BATCHVSAM.                                            00040000
      ****************************************************************  00202000
      * This program reads vsam file and creates book report         *  00203000
      ****************************************************************  00205000
002100*---------------------                                            00210000
002200 ENVIRONMENT DIVISION.                                            00220000
002300*---------------------                                            00230000
002400 INPUT-OUTPUT SECTION.                                            00240000
002500 FILE-CONTROL.                                                    00250000
002600*----------------------------------------*                        00260000
002700*---------- FILE       --------- JCL    -*                        00270000
002800*---------- DESCRIPTOR --------- DDNAME -*                        00280000
002900*----------------------------------------*                        00290000
003220     SELECT VSAMBOOK                                              00322000
003230         ASSIGN       TO VSAMBOOK                                 00323000
003240         ORGANIZATION IS INDEXED                                  00324000
003250         ACCESS MODE  IS SEQUENTIAL                               00325000
003260         RECORD KEY   IS BOOKS-BOOK-ID                            00326000
003291         FILE STATUS  IS VSAMBOOK-FILE-STATUS VSAM-CODE.          00329100
003292                                                                  00329200
003293     SELECT REP-OP     ASSIGN TO REPOP                            00329300
003294                       ACCESS MODE IS SEQUENTIAL                  00329400
003295                       FILE STATUS IS REPOP-STAT.                 00329500
003296                                                                  00329600
003300*--------------                                                   00330000
003400 DATA DIVISION.                                                   00340000
003500*--------------                                                   00350000
003600 FILE SECTION.                                                    00360000
003710                                                                  00371000
003717 FD  VSAMBOOK.                                                    00371700
003718 01 VSAMBOOK-RECORD.                                              00371800
003719    10 BOOKS-BOOK-ID        PIC S9(9) USAGE COMP.                 00371900
003720    10 BOOKS-TITLE.                                               00372000
003730       49 BOOKS-TITLE-LEN   PIC S9(4) USAGE COMP.                 00373000
003740       49 BOOKS-TITLE-TEXT  PIC X(255).                           00374000
003742    10 BOOKS-TOTAL-PAGES    PIC S9(9) USAGE COMP.                 00374200
003743    10 FILLER               PIC X.                                00374300
003745    10 BOOKS-RATING         PIC S9(2)V9(2) USAGE COMP-3.          00374500
003746    10 FILLER               PIC X.                                00374600
003748    10 BOOKS-ISBN.                                                00374800
003749       49 BOOKS-ISBN-LEN    PIC S9(4) USAGE COMP.                 00374900
003750       49 BOOKS-ISBN-TEXT   PIC X(13).                            00375000
003751    10 FILLER               PIC X.                                00375100
003752    10 BOOKS-PUBLISHED-DATE PIC X(10).                            00375200
003753    10 FILLER               PIC X.                                00375300
003754    10 BOOKS-PUBLISHER-ID   PIC S9(9) USAGE COMP.                 00375400
003755    10 FILLER               PIC X.                                00375500
003760                                                                  00376000
003800 FD  REP-OP                                                       00380000
003900     RECORD CONTAINS 132                                          00390000
004000     RECORDING MODE F.                                            00400000
004100 01  REP-OP-FIELDS.                                               00410000
004200     05 OP-BOOKID    PIC X(08).                                   00420000
004300     05 FILLER       PIC X(01).                                   00430000
004400     05 OP-TITLE     PIC X(77).                                   00440000
004500     05 FILLER       PIC X(02).                                   00450000
004600     05 OP-PAGES     PIC X(04).                                   00460000
004700     05 FILLER       PIC X(02).                                   00470000
004800     05 OP-RATING    PIC X(04).                                   00480000
004900     05 FILLER       PIC X(02).                                   00490000
005000     05 OP-ISBN      PIC X(13).                                   00500000
005100     05 FILLER       PIC X(02).                                   00510000
005200     05 OP-PUBDATE   PIC X(10).                                   00520000
005300     05 FILLER       PIC X(02).                                   00530000
005400     05 OP-PUBID     PIC X(04).                                   00540000
005500     05 FILLER       PIC X(01).                                   00550000
005600                                                                  00560000
005700 WORKING-STORAGE SECTION.                                         00570000
005750                                                                  00575000
005792*                                                                 00579200
005793 01  VSAMBOOK-FILE-STATUS.                                        00579300
005794     05  STA-IN-STAT1              PIC  X(01).                    00579400
005795     05  STA-IN-STAT2              PIC  X(01).                    00579500
005796 01 VSAM-CODE.                                                    00579600
005797    05 VSAM-RETURN-CODE      PIC S9(2) Usage Binary.              00579700
005798    05 VSAM-COMPONENT-CODE   PIC S9(1) Usage Binary.              00579800
005799    05 VSAM-REASON-CODE      PIC S9(3) Usage Binary.              00579900
005800                                                                  00580000
005801 01  WS-VSAM-CODE-DISPLAY.                                        00580100
005802     05 VSAM-RETURN-CODE-DIS     PIC Z(2)9.                       00580200
005803     05 VSAM-COMPONENT-CODE-DIS  PIC Z(2)9.                       00580300
005804     05 VSAM-REASON-CODE-DIS     PIC Z(3)9.                       00580400
005806                                                                  00580600
005807*                                                                 00580700
005808 01  WS-CURRENT-COLLID   PIC  X(18).                              00580800
005809 01  DELAY-MILLISECS     PIC S9(9) BINARY.                        00580900
005810*                                                                 00581000
005811 01  FC.                                                          00581100
005812     02  Condition-Token-Value.                                   00581200
005813     COPY  CEEIGZCT.                                              00581300
005814         03  Case-1-Condition-ID.                                 00581400
005815             04  Severity    PIC S9(4) BINARY.                    00581500
005816             04  Msg-No      PIC S9(4) BINARY.                    00581600
005817         03  Case-2-Condition-ID                                  00581700
005818                   REDEFINES Case-1-Condition-ID.                 00581800
005819             04  Class-Code  PIC S9(4) BINARY.                    00581900
005820             04  Cause-Code  PIC S9(4) BINARY.                    00582000
005821         03  Case-Sev-Ctl    PIC X.                               00582100
005822         03  Facility-ID     PIC XXX.                             00582200
005823     02  I-S-Info            PIC S9(9) BINARY.                    00582300
005824*                                                                 00582400
005830 01  WS-LABELS.                                                   00583000
005900     05 WS-SPACE.                                                 00590000
006000        10 FILLER        PIC X(1) VALUE SPACE.                    00600000
006100                                                                  00610000
006200     05 WS-HEADER-TITLE.                                          00620000
006300        10 FILLER        PIC X(50)  VALUE SPACES.                 00630000
006400        10 FILLER        PIC X(29)  VALUE 'GENERATED BOOK REPORT'.00640000
006500        10 FILLER        PIC X(42)  VALUE SPACES.                 00650000
006600        10 WS-DATE-R     PIC X(10)  VALUE SPACES.                 00660000
006700        10 FILLER        PIC X(01)  VALUE SPACES.                 00670000
006800                                                                  00680000
006900     05 WS-HEADER-TIME.                                           00690000
007000        10 FILLER        PIC X(009) VALUE 'PAGE NO. '.            00700000
007100        10 WS-PAGE-NO    PIC 9(04)  VALUE ZERO.                   00710000
007200        10 FILLER        PIC X(106) VALUE SPACES.                 00720000
007300        10 WS-TIME-R     PIC X(12)  VALUE '-'.                    00730000
007400        10 FILLER        PIC X(01)  VALUE SPACES.                 00740000
007500                                                                  00750000
007600     05 WS-HEADER-LABEL.                                          00760000
007700        10 FILLER        PIC X(09)  VALUE 'BOOK ID'.              00770000
007800        10 FILLER        PIC X(79)  VALUE 'TITLE'.                00780000
007900        10 FILLER        PIC X(06)  VALUE 'PAGE'.                 00790000
008000        10 FILLER        PIC X(06)  VALUE 'RATE'.                 00800000
008100        10 FILLER        PIC X(15)  VALUE 'ISBN NO.'.             00810000
008200        10 FILLER        PIC X(12)  VALUE 'P.DATE'.               00820000
008300        10 FILLER        PIC X(05)  VALUE 'P.ID'.                 00830000
008400                                                                  00840000
008500     05 WS-HEADER-LINE.                                           00850000
008600        10 FILLER        PIC X(08)  VALUE ALL '-'.                00860000
008700        10 FILLER        PIC X(01)  VALUE SPACES.                 00870000
008800        10 FILLER        PIC X(77)  VALUE ALL '-'.                00880000
008900        10 FILLER        PIC X(02)  VALUE SPACES.                 00890000
009000        10 FILLER        PIC X(04)  VALUE ALL '-'.                00900000
009100        10 FILLER        PIC X(02)  VALUE SPACES.                 00910000
009200        10 FILLER        PIC X(04)  VALUE ALL '-'.                00920000
009300        10 FILLER        PIC X(02)  VALUE SPACES.                 00930000
009400        10 FILLER        PIC X(13)  VALUE ALL '-'.                00940000
009500        10 FILLER        PIC X(02)  VALUE SPACES.                 00950000
009600        10 FILLER        PIC X(10)  VALUE ALL '-'.                00960000
009700        10 FILLER        PIC X(02)  VALUE SPACES.                 00970000
009800        10 FILLER        PIC X(04)  VALUE ALL '-'.                00980000
009900        10 FILLER        PIC X(01)  VALUE SPACES.                 00990000
010000                                                                  01000000
010100     05 WS-PAGE-BREAK.                                            01010000
010200        10 FILLER        PIC X(131) VALUE ALL '-'.                01020000
010300        10 FILLER        PIC X(001) VALUE SPACES.                 01030000
010400                                                                  01040000
010500     05 WS-FOOTER.                                                01050000
010600        10 FILLER        PIC X(58)  VALUE ALL '='.                01060000
010700        10 FILLER        PIC X(15)  VALUE ' END OF REPORT '.      01070000
010800        10 FILLER        PIC X(59)  VALUE ALL '='.                01080000
010900                                                                  01090000
011000 01  WS-VARS.                                                     01100000
011100     05 WS-TIMESTAMP     PIC X(23)  VALUE SPACES.                 01110000
011200     05 WS-BOOKID        PIC 9(08)  VALUE ZERO.                   01120000
011300     05 WS-RATING        PIC 9.99   VALUE ZERO.                   01130000
011400     05 WS-PAGES         PIC 9(04)  VALUE ZERO.                   01140000
011500     05 WS-PUBID         PIC 9(04)  VALUE ZERO.                   01150000
011600     05 WS-REC-COUNT     PIC 9(02)  VALUE ZERO.                   01160000
011700     05 WS-REC-BUFFER    PIC X(132) VALUE SPACES.                 01170000
011800                                                                  01180000
011900 01  WS-DISPLAY-VARS.                                             01190000
012000     05 ERR-PGM          PIC X(06)  VALUE 'VSMREP'.               01200000
012100     05 ERR-LOC          PIC X(20)  VALUE SPACES.                 01210000
012200     05 ERR-MSG          PIC X(30)  VALUE SPACES.                 01220000
012300     05 ERR-CODE         PIC 9(09)  VALUE ZERO.                   01230000
012400                                                                  01240000
013100                                                                  01310000
013200 01  WS-FLAG-VARS.                                                01320000
013300     05 REPOP-STAT       PIC 9(02)  VALUE ZERO.                   01330000
013400     05 CONT-FLAG        PIC X(01)  VALUE 'N'.                    01340000
013500        88 CONT-STRING              VALUE 'Y'.                    01350000
013600     05 EOF-FLAG         PIC X(01)  VALUE 'N'.                    01360000
013700        88 END-OF-FILE              VALUE 'Y'.                    01370000
013800     05 FIRST-TIME-FLAG  PIC X(01)  VALUE 'Y'.                    01380000
013900        88 FIRST-TIME               VALUE 'Y'.                    01390000
014000        88 NOT-FIRST-TIME           VALUE 'N'.                    01400000
014010     05 WS-WRITE-REC     PIC  9 VALUE 0.                          01401000
014020        88 88-WRITE-REC       VALUE 0.                            01402000
014030        88 88-DONT-WRITE-REC  VALUE 1.                            01403000
014100                                                                  01410000
016100 PROCEDURE DIVISION.                                              01610000
016110*                                                                 01611000
016120* THIS IS A COBOL-VSAM PROGRAM FOR A CREATING REPORT ON VSAM BOOKS01612000
016130* WITH THE FOLLOWING FIELDS:                                      01613000
016140*   - BOOK ID                                                     01614000
016150*   - TITLE                                                       01615000
016160*        - MULTIPLE LINES ARE PROVIDED FOR LONG TITLES (MAX IS 4) 01616000
016170*   - PAGE                                                        01617000
016180*   - RATE                                                        01618000
016190*   - ISBN. NO                                                    01619000
016191*   - PUBLISHED DATE                                              01619100
016192*   - PUBLISHER ID                                                01619200
016193* PAGEBREAK IS PRINTED AFTER EVERY 30 RECORDS                     01619300
016194*                                                                 01619400
016200 0000-MAIN.                                                       01620000
016300      PERFORM 1000-INITIALIZE   THRU 1000-EXIT                    01630000
016301                                                                  01630100
016302      MOVE    1                          TO WS-PAGE-NO            01630200
016303      PERFORM 1100-WRITE-HEADER        THRU 1100-EXIT             01630300
016304                                                                  01630400
016305* Extract all books from database and generate report             01630500
016306                                                                  01630600
016320      MOVE SPACES TO EOF-FLAG                                     01632000
016330      OPEN INPUT VSAMBOOK                                         01633000
016340                                                                  01634000
016360      MOVE       'ERROR OPENING VSAMBOOK'   TO ERR-MSG            01636000
016370      PERFORM 9999-VSAM-ERR-CHK           THRU 9999-EXIT          01637000
016380                                                                  01638000
016381      MOVE 0  TO BOOKS-BOOK-ID                                    01638100
016382      START VSAMBOOK KEY >=  BOOKS-BOOK-ID                        01638200
016383      MOVE       'ERROR POSITIONING VSAMBOOK'   TO ERR-MSG        01638300
016384      PERFORM 9999-VSAM-ERR-CHK           THRU 9999-EXIT          01638400
016390                                                                  01639000
016398      PERFORM 1200-READ-BOOK              THRU 1200-EXIT          01639800
016399*                                                                 01639900
016400      PERFORM 2000-READ-ALL-BOOKS                                 01640000
016401         THRU 2000-EXIT                                           01640100
016402         UNTIL END-OF-FILE                                        01640200
016403*                                                                 01640300
016408      CLOSE VSAMBOOK                                              01640800
016409*                                                                 01640900
016410      MOVE      'ERROR CLOSING VSAMBOOK' TO ERR-MSG               01641000
016411      PERFORM 9999-VSAM-ERR-CHK        THRU 9999-EXIT             01641100
016420*                                                                 01642000
016500      PERFORM 3000-HOUSEKEEPING THRU 3000-EXIT                    01650000
016600      STOP RUN.                                                   01660000
016700*-----------------------------------------------------------------01670000
016800 1000-INITIALIZE.                                                 01680000
016801      MOVE '1000-INITALIZE'              TO ERR-LOC               01680100
017000                                                                  01700000
018010      MOVE '2021-10-13'                  TO WS-DATE-R             01801000
018020      MOVE '15.51.03.325'                TO WS-TIME-R             01802000
018100                                                                  01810000
018200      OPEN OUTPUT REP-OP                                          01820000
018300      MOVE    'ERROR OPENING REP-OP'     TO ERR-MSG               01830000
018400      PERFORM 9998-FILE-ERR-CHK        THRU 9998-EXIT             01840000
018500      MOVE SPACES TO BOOKS-TITLE-TEXT BOOKS-ISBN-TEXT             01850000
018600      MOVE 0      TO BOOKS-TITLE-LEN BOOKS-ISBN-LEN               01860000
019600                                                                  01960000
019700      .                                                           01970000
019800 1000-EXIT.                                                       01980000
019900      EXIT.                                                       01990000
020000*-----------------------------------------------------------------02000000
020100 1100-WRITE-HEADER.                                               02010000
020110* Write Header records                                            02011000
020200      MOVE '1100-WRITE-HEADER'       TO ERR-LOC                   02020000
020300                                                                  02030000
020400      WRITE REP-OP-FIELDS          FROM WS-HEADER-TITLE           02040000
020500      WRITE REP-OP-FIELDS          FROM WS-HEADER-TIME            02050000
020600      WRITE REP-OP-FIELDS          FROM WS-SPACE                  02060000
020700      WRITE REP-OP-FIELDS          FROM WS-SPACE                  02070000
020800      WRITE REP-OP-FIELDS          FROM WS-HEADER-LABEL           02080000
020900      WRITE REP-OP-FIELDS          FROM WS-HEADER-LINE            02090000
021000                                                                  02100000
021100      MOVE    'ERROR WRITING HEADER' TO ERR-MSG                   02110000
021200      PERFORM 9998-FILE-ERR-CHK    THRU 9998-EXIT                 02120000
021300      .                                                           02130000
021400 1100-EXIT.                                                       02140000
021500      EXIT.                                                       02150000
021600*-----------------------------------------------------------------02160000
021700 1200-READ-BOOK.                                                  02170000
021800      MOVE '1200-READ-BOOK' TO ERR-LOC                            02180000
021900                                                                  02190000
022010      READ VSAMBOOK NEXT                                          02201000
022011      END-READ                                                    02201100
022020                                                                  02202000
023000      MOVE    'ERROR READING VSAMBOOK' TO ERR-MSG                 02300000
023100      PERFORM 9999-VSAM-ERR-CHK THRU 9999-EXIT                    02310000
023200      .                                                           02320000
023300 1200-EXIT.                                                       02330000
023400      EXIT.                                                       02340000
023500*-----------------------------------------------------------------02350000
023600 2000-READ-ALL-BOOKS.                                             02360000
023700      MOVE '2000-READ-ALL-BOOKS' TO ERR-LOC                       02370000
023800                                                                  02380000
023810      MOVE SPACES               TO REP-OP-FIELDS                  02381000
023900      MOVE BOOKS-BOOK-ID        TO WS-BOOKID                      02390000
024000      MOVE WS-BOOKID            TO OP-BOOKID                      02400000
024100      MOVE BOOKS-TOTAL-PAGES    TO WS-PAGES                       02410000
024200      MOVE WS-PAGES             TO OP-PAGES                       02420000
024300      MOVE BOOKS-RATING         TO WS-RATING                      02430000
024400      MOVE WS-RATING            TO OP-RATING                      02440000
024500      MOVE BOOKS-ISBN-TEXT      TO OP-ISBN                        02450000
024600      MOVE BOOKS-PUBLISHED-DATE TO OP-PUBDATE                     02460000
024700      MOVE BOOKS-PUBLISHER-ID   TO WS-PUBID                       02470000
024800      MOVE WS-PUBID             TO OP-PUBID                       02480000
024900                                                                  02490000
025000      EVALUATE TRUE                                               02500000
025100      WHEN BOOKS-TITLE-LEN > 228                                  02510000
025200           STRING BOOKS-TITLE-TEXT(1:76) DELIMITED BY SIZE        02520000
025300                  '-' DELIMITED BY SIZE                           02530000
025400                  INTO OP-TITLE                                   02540000
025500           END-STRING                                             02550000
025600           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02560000
025700                                                                  02570000
025800           STRING BOOKS-TITLE-TEXT(77:76) DELIMITED BY SIZE       02580000
025900                  '-' DELIMITED BY SIZE                           02590000
026000                  INTO OP-TITLE                                   02600000
026100           END-STRING                                             02610000
026200           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02620000
026300                                                                  02630000
026400           STRING BOOKS-TITLE-TEXT(153:76) DELIMITED BY SIZE      02640000
026500                  '-' DELIMITED BY SIZE                           02650000
026600                  INTO OP-TITLE                                   02660000
026700           END-STRING                                             02670000
026800           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02680000
026900                                                                  02690000
027000           MOVE    BOOKS-TITLE-TEXT(229:27) TO OP-TITLE           02700000
027100           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02710000
027200                                                                  02720000
027300      WHEN BOOKS-TITLE-LEN > 152                                  02730000
027400           STRING BOOKS-TITLE-TEXT(1:76) DELIMITED BY SIZE        02740000
027500                  '-' DELIMITED BY SIZE                           02750000
027600                  INTO OP-TITLE                                   02760000
027700           END-STRING                                             02770000
027800           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02780000
027900                                                                  02790000
028000           STRING BOOKS-TITLE-TEXT(77:76) DELIMITED BY SIZE       02800000
028100                  '-' DELIMITED BY SIZE                           02810000
028200                  INTO OP-TITLE                                   02820000
028300           END-STRING                                             02830000
028400           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02840000
028500                                                                  02850000
028600           MOVE    BOOKS-TITLE-TEXT(153:77) TO OP-TITLE           02860000
028700           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02870000
028800                                                                  02880000
028900      WHEN BOOKS-TITLE-LEN > 77                                   02890000
029000           STRING BOOKS-TITLE-TEXT(1:76) DELIMITED BY SIZE        02900000
029100                  '-' DELIMITED BY SIZE                           02910000
029200                  INTO OP-TITLE                                   02920000
029300           END-STRING                                             02930000
029400           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02940000
029500                                                                  02950000
029600           MOVE    BOOKS-TITLE-TEXT(77:77) TO OP-TITLE            02960000
029700           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               02970000
029800                                                                  02980000
029900      WHEN OTHER                                                  02990000
030000           MOVE    BOOKS-TITLE-TEXT(1:77) TO OP-TITLE             03000000
030100           PERFORM 2100-WRITE-RECORD THRU 2100-EXIT               03010000
030200      END-EVALUATE                                                03020000
030300                                                                  03030000
030400      MOVE SPACES TO BOOKS-TITLE-TEXT BOOKS-ISBN-TEXT             03040000
030500      MOVE 0      TO BOOKS-TITLE-LEN BOOKS-ISBN-LEN               03050000
030600                                                                  03060000
030700      PERFORM 1200-READ-BOOK THRU 1200-EXIT.                      03070000
030800                                                                  03080000
031000 2000-EXIT.                                                       03100000
031100      EXIT.                                                       03110000
031200*-----------------------------------------------------------------03120000
031300 2100-WRITE-RECORD.                                               03130000
031400      MOVE '2100-WRITE-RECORD'       TO ERR-LOC                   03140000
031500                                                                  03150000
031510      IF 88-DONT-WRITE-REC THEN                                   03151000
031520         GO TO 2100-EXIT.                                         03152000
031530                                                                  03153000
031600      IF WS-REC-COUNT = 30                                        03160000
031700         MOVE    0                   TO WS-REC-COUNT              03170000
031800         ADD     1                   TO WS-PAGE-NO                03180000
031900         MOVE    REP-OP-FIELDS       TO WS-REC-BUFFER             03190000
032000         WRITE   REP-OP-FIELDS     FROM WS-PAGE-BREAK             03200000
032100         WRITE   REP-OP-FIELDS     FROM WS-SPACE                  03210000
032200         PERFORM 1100-WRITE-HEADER THRU 1100-EXIT                 03220000
032300         MOVE    WS-REC-BUFFER       TO REP-OP-FIELDS             03230000
032400      END-IF                                                      03240000
032500                                                                  03250000
032600      WRITE   REP-OP-FIELDS                                       03260000
032700      MOVE    'ERROR WRITING REP-OP' TO ERR-MSG                   03270000
032800      PERFORM 9998-FILE-ERR-CHK    THRU 9998-EXIT                 03280000
032900      ADD     1                      TO WS-REC-COUNT              03290000
033000      MOVE    SPACES                 TO REP-OP-FIELDS             03300000
033100      .                                                           03310000
033200 2100-EXIT.                                                       03320000
033300      EXIT.                                                       03330000
033400*-----------------------------------------------------------------03340000
033500 3000-HOUSEKEEPING.                                               03350000
033510* Write Footer record and close the Report file                   03351000
033600      MOVE '3000-HOUSEKEEPING' TO ERR-LOC                         03360000
033770*                                                                 03377000
033800      WRITE REP-OP-FIELDS FROM WS-FOOTER                          03380000
034500                                                                  03450000
034600      CLOSE  REP-OP                                               03460000
034700      MOVE   'ERROR CLOSING REP-OP' TO ERR-MSG                    03470000
034800      PERFORM 9998-FILE-ERR-CHK   THRU 9998-EXIT                  03480000
034900      .                                                           03490000
035000 3000-EXIT.                                                       03500000
035100     EXIT.                                                        03510000
035200*-----------------------------------------------------------------03520000
035300 9998-FILE-ERR-CHK.                                               03530000
035400      EVALUATE TRUE                                               03540000
035500          WHEN REPOP-STAT = 0                                     03550000
035600               CONTINUE                                           03560000
035700                                                                  03570000
035800          WHEN OTHER                                              03580000
035900               DISPLAY 'FILE ERROR'                               03590000
036000               DISPLAY 'PROG: ' ERR-PGM                           03600000
036100               DISPLAY '  IN: ' ERR-LOC                           03610000
036200               DISPLAY ' MSG: ' ERR-MSG                           03620000
036300               DISPLAY 'CODE: ' REPOP-STAT                        03630000
036400               STOP RUN                                           03640000
036500      END-EVALUATE                                                03650000
036600      .                                                           03660000
036700 9998-EXIT.                                                       03670000
036800      EXIT.                                                       03680000
036900*-----------------------------------------------------------------03690000
037000 9999-VSAM-ERR-CHK.                                               03700000
037100      MOVE VSAMBOOK-FILE-STATUS TO ERR-CODE                       03710000
037200      EVALUATE TRUE                                               03720000
037300          WHEN VSAMBOOK-FILE-STATUS = '00'                        03730000
037400               CONTINUE                                           03740000
037500                                                                  03750000
037600          WHEN VSAMBOOK-FILE-STATUS = '10'                        03760000
037700               MOVE 'Y' TO EOF-FLAG                               03770000
037710               DISPLAY 'VSAMBOOK-FILE-STATUS = '                  03771000
037711                        VSAMBOOK-FILE-STATUS                      03771100
037720               MOVE VSAM-RETURN-CODE                              03772000
037730                 TO VSAM-RETURN-CODE-DIS                          03773000
037740               MOVE VSAM-COMPONENT-CODE                           03774000
037750                 TO VSAM-COMPONENT-CODE-DIS                       03775000
037760               MOVE VSAM-REASON-CODE                              03776000
037770                 TO VSAM-REASON-CODE-DIS                          03777000
037780               DISPLAY                                            03778000
037790                   ' VSAM-CODE ==>'                               03779000
037791                   ' RETURN: '  VSAM-RETURN-CODE-DIS              03779100
037792                   ' COMPONENT: '  VSAM-COMPONENT-CODE-DIS        03779200
037793                   ' REASON: '  VSAM-REASON-CODE-DIS              03779300
037800                                                                  03780000
037900          WHEN OTHER                                              03790000
038000               DISPLAY '---VSAM ERROR---'                         03800000
038100               DISPLAY 'PROG: ' ERR-PGM                           03810000
038200               DISPLAY '  IN: ' ERR-LOC                           03820000
038300               DISPLAY ' MSG: ' ERR-MSG                           03830000
038400               DISPLAY 'CODE: ' ERR-CODE                          03840000
038410               MOVE VSAM-RETURN-CODE                              03841000
038411                 TO VSAM-RETURN-CODE-DIS                          03841100
038420               MOVE VSAM-COMPONENT-CODE                           03842000
038421                 TO VSAM-COMPONENT-CODE-DIS                       03842100
038430               MOVE VSAM-REASON-CODE                              03843000
038431                 TO VSAM-REASON-CODE-DIS                          03843100
038450               DISPLAY                                            03845000
038460                   ' VSAM-CODE ==>'                               03846000
038470                   ' RETURN: '  VSAM-RETURN-CODE-DIS              03847000
038480                   ' COMPONENT: '  VSAM-COMPONENT-CODE-DIS        03848000
038490                   ' REASON: '  VSAM-REASON-CODE-DIS              03849000
038491               MOVE 16 TO RETURN-CODE                             03849100
038500               STOP RUN                                           03850000
038600      END-EVALUATE                                                03860000
038700      .                                                           03870000
038800 9999-EXIT.                                                       03880000
038900      EXIT.                                                       03890000
039000*-----------------------------------------------------------------03900000
