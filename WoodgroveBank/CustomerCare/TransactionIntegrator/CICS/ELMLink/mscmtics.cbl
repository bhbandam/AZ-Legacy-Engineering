       IDENTIFICATION DIVISION.
       PROGRAM-ID. MSCMTICS.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *****************************************************************
      ** MVS TCP/IP REQUIRED DEFINITIONS                              *
      *****************************************************************
       01 SOKET-FUNCTIONS.
          05 SOKET-CLOSE           PIC X(16) VALUE 'CLOSE           '.
          05 SOKET-RECV            PIC X(16) VALUE 'RECV            '.
          05 SOKET-SHUTDOWN        PIC X(16) VALUE 'SHUTDOWN        '.
          05 SOKET-TAKESOCKET      PIC X(16) VALUE 'TAKESOCKET      '.
          05 SOKET-WRITE           PIC X(16) VALUE 'WRITE           '.

       01 TCP-FLAGS-CONSTANTS.
          05 TCP-FLAGS-NO-FLAG              PIC S9(4) COMP VALUE 0.
          05 TCP-FLAGS-OOB                  PIC S9(4) COMP VALUE 1.
          05 TCP-FLAGS-PEEK                 PIC S9(4) COMP VALUE 2.

       01 TCP-HOW                           PIC 9(8) COMP.
       01 TCP-HOW-CODES.
          05 THC-END-FROM                   PIC 9(8) COMP VALUE 0.
          05 THC-END-TO                     PIC 9(8) COMP VALUE 1.
          05 THC-END-BOTH                   PIC 9(8) COMP VALUE 2.

       01 TCPSOCKET-PARM.
          05 ENHANCED-LISTENER-TIM.
             10 STANDARD-LISTENER-TIM.
                15 GIVE-TAKE-SOCKET         PIC 9(8) COMP.
                15 LSTN-NAME                PIC X(8).
                15 LSTN-SUBTASKNAME         PIC X(8).
                15 LSTN-CLIENT-IN-DATA      PIC X(35).
                15 FILLER                   PIC X(1).
                15 SOCKADDR-IN.
                   20 SIN-FAMILY            PIC 9(4)  COMP.
                   20 SIN-PORT              PIC 9(4)  COMP.
                   20 SIN-ADDR              PIC 9(8)  COMP.
                   20 SIN-ZERO              PIC X(8).
             10 FILLER                      PIC X(80).
             10 DATA-AREA-2-LEN             PIC 9(4) COMP.
             10 DATA-AREA-2.
                15 DA2-CLIENT-IN-DATA       PIC X(35).

       01 AF-INET                           PIC 9(8)  COMP VALUE 2.
       01 LISTENER-ID.
          05 LI-DOMAIN                      PIC 9(8)  COMP.
          05 LI-NAME                        PIC X(8).
          05 LI-SUBTASKNAME                 PIC X(8).
          05 LI-RESERVED                    PIC X(20).

       01 TCP-IDENT.
          05 TCP-IDENT-TCPNAME              PIC X(8)  VALUE 'TCPIP31'.
          05 TCP-IDENT-ADSNAME              PIC X(8)  VALUE SPACES.

       01 TCP-SUBTASK.
          05 TCP-SUBTASK-NUM                PIC 9(7).
          05 TCP-SUBTASK-CHAR               PIC X.

       01 TCP-MAXSNO                        PIC 9(8)  COMP.
       01 TCP-MAXSOC                        PIC 9(4)  COMP  VALUE 50.
       01 TCP-SOCKET                        PIC 9(4)  COMP.
       01 TCP-FLAGS                         PIC 9(8)  COMP.
       01 TCP-NBYTES                        PIC 9(8)  COMP.
       01 TCP-ERRNO                         PIC 9(8)  COMP.
       01 TCP-RETCODE                       PIC S9(8) COMP.

       01 TCP-BUF                           PIC X(33800)  VALUE SPACES.
       01 FILLER REDEFINES TCP-BUF.
          05 TCP-BUF-CHAR OCCURS 33800 TIMES PIC X.
       01 FILLER REDEFINES TCP-BUF.
          05 TCP-BUF-TRMREPLY-LEN           PIC S9(9) COMP.
          05 FILLER                         PIC X(33796).

       01 TRACE-ID                      PIC S9(4) COMP VALUE 0.
       01 TRACE-POINTS-IDS.
          05 TP-VALIDATE-1              PIC S9(4) COMP VALUE 1.
          05 TP-VALIDATE-2              PIC S9(4) COMP VALUE 2.
          05 TP-TAKESOC-1               PIC S9(4) COMP VALUE 3.
          05 TP-TRMREPLY-1              PIC S9(4) COMP VALUE 4.
          05 TP-TRMREPLY-2              PIC S9(4) COMP VALUE 5.
          05 TP-RECVREQ-1               PIC S9(4) COMP VALUE 6.
          05 TP-RECV-1                  PIC S9(4) COMP VALUE 7.
          05 TP-RECV-2                  PIC S9(4) COMP VALUE 8.
          05 TP-RECV-3                  PIC S9(4) COMP VALUE 9.
          05 TP-LINKTO-1                PIC S9(4) COMP VALUE 10.
          05 TP-LINKTO-2                PIC S9(4) COMP VALUE 11.
          05 TP-WRI2SOC-2               PIC S9(4) COMP VALUE 12.
          05 TP-WRI2SOC-3               PIC S9(4) COMP VALUE 13.
          05 TP-BUF2SOC-1               PIC S9(4) COMP VALUE 14.
          05 TP-SHUTDOWN-1              PIC S9(4) COMP VALUE 15.
          05 TP-CLOSE-1                 PIC S9(4) COMP VALUE 16.
          05 TP-RECVCID-1               PIC S9(4) COMP VALUE 17.
          05 TP-RECVCID-2               PIC S9(4) COMP VALUE 18.
          05 TP-RECVCID-3               PIC S9(4) COMP VALUE 19.
          05 TP-BAD-CID-VERSION-1       PIC S9(4) COMP VALUE 20.
          05 TP-BAD-PERSISTENT-TYPE-1   PIC S9(4) COMP VALUE 21.
          05 TP-NPTRM-PGM-INVALID       PIC S9(4) COMP VALUE 22.
          05 TP-NPTRM-PGM-ABEND         PIC S9(4) COMP VALUE 23.
          05 TP-BAD-CID-FORMAT          PIC S9(4) COMP VALUE 24.

      ***********************************************
      ******** CID COMMON AREA USED FOR PGM EXECUTION
      ***********************************************
       01 CLIENT-IN-DATA.
          05 CID-USERID                     PIC X(8).
          05 CID-PASSWORD                   PIC X(8).
          05 CID-LINK-TO-PROG               PIC X(8).
          05 CID-COMMAREA-LEN               PIC S9(4) COMP.
          05 CID-DATA-LEN                   PIC S9(8) COMP.
          05 CID-VERSION                    PIC X.
             88 CID-VERSION-1               VALUE X'00'.
             88 CID-VERSION-2               VALUE X'01'.
          05 CID-FLAGS                      PIC X(2).
             88 CID-USE-TICS-WORK-AREA      VALUE X'0100'.
             88 CID-FLAGS-PERSISTENT-NONE   VALUE X'0001'.
             88 CID-FLAGS-PERSISTENT-OPEN   VALUE X'0002'.
             88 CID-FLAGS-PERSISTENT-USE    VALUE X'0004'.
             88 CID-FLAGS-PERSISTENT-CLOSE  VALUE X'0008'.
             88 CID-FLAGS-NO-OBJ-PERSIST    VALUE X'0010'.
          05 CID-RESERVED                   PIC X(1).
          05 CID-FORMAT                     PIC X(1).
             88 CID-FORMAT-NOTSET           VALUE X'00'.
             88 CID-FORMAT-MS               VALUE X'01'.
             88 CID-FORMAT-IBM              VALUE X'02'.

      *************************************************************
      ******** CID RECEIVED INTO THIS AREA TO PROVIDE SUPPORT FOR
      ******** DIFFERENT FORMATS OF THE CID BASED ON SECURITY NEEDS
      *************************************************************
       01 CLIENT-IN-DATA-RECV-AREA          PIC X(35).
       01 FILLER REDEFINES CLIENT-IN-DATA-RECV-AREA.
          05 CID-VARIABLE-PART              PIC X(34).
          05 CID-MS REDEFINES CID-VARIABLE-PART.
             10 CID-MS-USERID               PIC X(8).
             10 CID-MS-PASSWORD             PIC X(8).
             10 CID-MS-LINK-TO-PROG         PIC X(8).
             10 CID-MS-COMMAREA-LEN         PIC S9(4) COMP.
             10 CID-MS-DATA-LEN             PIC S9(8) COMP.
             10 CID-MS-VERSION              PIC X.
             10 CID-MS-FLAGS                PIC X(2).
             10 CID-MS-RESERVED             PIC X.
          05 CID-IBM REDEFINES CID-VARIABLE-PART.
             10 CID-IBM-SECURITY-FLAG       PIC X.
             10 CID-IBM-PASSWORD            PIC X(8).
             10 CID-IBM-USERID              PIC X(8).
             10 CID-IBM-LINK-TO-PROG        PIC X(8).
             10 CID-IBM-COMMAREA-LEN        PIC S9(4) COMP.
             10 CID-IBM-DATA-LEN            PIC S9(8) COMP.
             10 CID-IBM-VERSION             PIC X.
             10 CID-IBM-FLAGS               PIC X(2).
          05 CID-RA-FORMAT                  PIC X.

       01 PERSISTENCE-TYPE                  PIC S9(4) COMP.
          88 PT-NONE                        VALUE 1.
          88 PT-OPEN                        VALUE 2.
          88 PT-USE                         VALUE 4.
          88 PT-CLOSE                       VALUE 8.
       01 PERSISTENCE-TYPE-BYTES REDEFINES PERSISTENCE-TYPE PIC X(2).

       01 USE-TICS-WORKAREA                 PIC S9(4) COMP.
          88 UTWA-FALSE                     VALUE 0.
          88 UTWA-TRUE                      VALUE 1.
       01 USE-TICS-WORKAREA-BYTE REDEFINES
                        USE-TICS-WORKAREA   PIC X(2).

       01 LISTENER-TYPE                     PIC X     VALUE SPACE.
          88 LISTENER-WAS-NOT-DEFINED                 VALUE SPACE.
          88 LISTENER-WAS-STANDARD                    VALUE 'S'.
          88 LISTENER-WAS-ENHANCED                    VALUE 'E'.

       01 ENABLE-LOGGING                    PIC X          VALUE 'Y'.
          88 LOGGING-IS-ENABLED                            VALUE 'Y'.
          88 LOGGING-IS-DISABLED                           VALUE 'N'.
       01 SOCKET-OPENED                     PIC X          VALUE 'N'.
          88 SOCKET-IS-OPENED                              VALUE 'Y'.
          88 SOCKET-IS-CLOSED                              VALUE 'N'.

       01 HW-LENGTH                         PIC 9(4)  COMP.
       01 BUF-BYTE-INDEX                    PIC S9(8) COMP VALUE 0.
       01 COMMAREA-BUF-BYTE-INDEX           PIC S9(8) COMP VALUE 0.
       01 RECV-COMMAREA-LEN                 PIC S9(5) COMP.
       01 BYTES-RECEIVED                    PIC S9(8) COMP.
       01 SNDRCV-BUF-LEN                    PIC S9(8) COMP.
       01 SNDRCV-BUF-AT-BYTE                PIC S9(8) COMP VALUE 0.

       01 CALLING-COMMAREA-LEN               PIC S9(4) COMP.
       01 COMMAREA-DATA                     PIC X(32767).
       01 COMMAREA-WITH-TWA REDEFINES COMMAREA-DATA.
      *      IF THE ENTIRE COMMAREA (32767) IS REQUIRED FOR USER DATA
      *      CONSIDER USING CWA, TWA, TEMP STORAGE OR OTHER TECHNIQUES
          05 TICS-WORK-AREA                 PIC X(00256).
          05 COMMAREA-DATA-TWA              PIC X(32511).

       01 BYTE-TO-NUMBER.
          05 BTN-NUMBER                     PIC S9(4) COMP.
          05 BTN-BYTES REDEFINES BTN-NUMBER PIC X(2).
          05 FILLER REDEFINES BTN-NUMBER.
             10 FILLER                      PIC X.
             10 BTN-BYTE                    PIC X.

       01 EDIT-NUM-1                        PIC +9(4).
       01 EDIT-NUM-2                        PIC +9(4).
       01 EDIT-NUM-3                        PIC +9(8).
       01 EDIT-NUM-3-1                      PIC +9(8).
       01 EDIT-NUM-3-NS                     PIC 9(8).
       01 EDIT-NUM-4                        PIC +9(12).
       01 STATUS-PROGID                     PIC S9(8) COMP.
       01 CMD-RESP                          PIC S9(8) COMP.

       01 LOG-MSG.
          05 LOG-ID                         PIC X(7)   VALUE 'TASK #'.
          05 TASK-NUMBER                    PIC 9(7).
          05 FILLER                         PIC X      VALUE SPACE.
          05 LOG-MSG-BUFFER                 PIC X(80) VALUE SPACES.

       01 TCP-ERROR-INFO.
          05  TCP-ERROR-MSG             PIC X(24).
          05  FILLER                    PIC X(9) VALUE ' RETCODE='.
          05  TCP-ERROR-RETCODE         PIC +9(4).
          05  FILLER                    PIC X(7) VALUE ' ERRNO='.
          05  TCP-ERROR-ERRNO           PIC +9(6).

       01 CURRENT-STATE                 PIC S9(4) COMP VALUE 0.
       01 NEXT-STATE                    PIC S9(4) COMP VALUE 9.
       01 SERVER-STATES.
          05 SS-RETR-TIM                PIC S9(4) COMP VALUE 0.
          05 SS-TAKE-SOCKET             PIC S9(4) COMP VALUE 1.
          05 SS-BUILD-TRM-REPLY         PIC S9(4) COMP VALUE 2.
          05 SS-SEND-TRM-REPLY          PIC S9(4) COMP VALUE 3.
          05 SS-RECV-REQUEST            PIC S9(4) COMP VALUE 4.
          05 SS-RECV-CID                PIC S9(4) COMP VALUE 5.
          05 SS-LINK-TO-USERPROG        PIC S9(4) COMP VALUE 6.
          05 SS-SEND-REPLY              PIC S9(4) COMP VALUE 7.
          05 SS-SHUTDOWN                PIC S9(4) COMP VALUE 8.
          05 SS-CLOSE-SOCKET            PIC S9(4) COMP VALUE 9.
          05 SS-DONE                    PIC S9(4) COMP VALUE 10.

       01 CHILD-SERVER-ERROR            PIC S9(4) COMP VALUE 0.
       01 CS-ERRORS.
          05 CS-ERROR-NO-ERROR          PIC S9(4) COMP VALUE 0.
          05 CS-ERROR-UNKNOWN-STATE     PIC S9(4) COMP VALUE -1.
          05 CS-ERROR-BAD-RETRIEVE      PIC S9(4) COMP VALUE -2.
          05 CS-ERROR-TAKESOCKET-FAILED PIC S9(4) COMP VALUE -3.
          05 CS-ERROR-WRITE-FAILED      PIC S9(4) COMP VALUE -4.
          05 CS-ERROR-RECV-FAILED       PIC S9(4) COMP VALUE -5.
          05 CS-ERROR-CICS-INVREQ       PIC S9(4) COMP VALUE -6.
          05 CS-ERROR-CICS-IOREQ        PIC S9(4) COMP VALUE -7.
          05 CS-ERROR-CICS-LENGERR      PIC S9(4) COMP VALUE -8.
          05 CS-ERROR-CICS-ENDDATA      PIC S9(4) COMP VALUE -9.
          05 CS-ERROR-INQ-FAILED        PIC S9(4) COMP VALUE -10.
          05 CS-ERROR-INQ-STATUS        PIC S9(4) COMP VALUE -11.
          05 CS-ERROR-SHUTDOWN          PIC S9(4) COMP VALUE -12.
          05 CS-ERROR-CICS-TRUE         PIC S9(4) COMP VALUE -13.
          05 CS-ERROR-BAD-CID           PIC S9(4) COMP VALUE -14.
          05 CS-NPTRM-PGM-INVALID       PIC S9(4) COMP VALUE -15.
          05 CS-NPTRM-PGM-ABEND         PIC S9(4) COMP VALUE -16.

       01 FORMATTED-FIELD-LEN.
          05 FFL-COMP                       PIC S9(8) COMP.
          05 FFL-CHAR REDEFINES FFL-COMP    PIC X(4).

       01 BUFFER-LENGTH.
          05 BUF-LEN                        PIC S9(8) COMP.
          05 BUF-LEN-CHAR REDEFINES BUF-LEN PIC X(4).

       01 FORMATTED-FIELD-CODES.
          05 FFC-VERSION-ID                 PIC X     VALUE X'01'.
          05 FFC-USER-DATA                  PIC X     VALUE X'02'.
          05 FFC-PROGID-INVALID             PIC X     VALUE X'03'.
          05 FFC-TRANID-INVALID             PIC X     VALUE X'04'.
          05 FFC-INQ-FAILED                 PIC X     VALUE X'05'.
          05 FFC-INQ-STATUS                 PIC X     VALUE X'06'.
          05 FFC-EXECUTION-OK               PIC X     VALUE X'07'.
          05 FFC-PROGRAM-ABEND              PIC X     VALUE X'08'.
          05 FFC-EXECUTION-FAILED           PIC X     VALUE X'09'.
          05 FFC-TRM-INVALID                PIC X     VALUE X'0A'.
          05 FFC-SERVER-GEND-AN-EXCEPTION   PIC X     VALUE X'0B'.

       01 FF-EXECUTION-OK.
          05 FF-EO-LENGTH                   PIC S9(8) COMP VALUE 1.
          05 FF-EO-CODE                     PIC X.

       01 FF-PROGRAM-ABEND.
          05 FF-PA-LENGTH                   PIC S9(8) COMP VALUE 9.
          05 FF-PA-CODE                     PIC X.
          05 FF-PA-PROGRAM                  PIC X(8).

       01 FF-PROGRAM-INVALID.
          05 FF-PI-LENGTH                   PIC S9(8) COMP VALUE 9.
          05 FF-PI-CODE                     PIC X.
          05 FF-PI-PROGRAM                  PIC X(8).

       01 FF-INQUIRE-FAILED.
          05 FF-IF-LENGTH                   PIC S9(8) COMP VALUE 4.
          05 FF-IF-CODE                     PIC X.
          05 FF-IF-CMDRESP                  PIC 9(3).

       01 FF-MSCMTICS-VERSION.
          05 FF-MV-LENGTH                   PIC S9(8) COMP VALUE 47.
          05 FF-MV-CODE                     PIC X.
          05 FF-MV-DESCRIPTION              PIC X(46)
              VALUE 'MSCMTICS: MICROSOFT LINK CONCURRENT SERVER 4.0'.

       01 FF-INQUIRE-STATUS.
          05 FF-IS-LENGTH                   PIC S9(8) COMP VALUE 9.
          05 FF-IS-CODE                     PIC X.
          05 FF-IS-DISABLED                 PIC X(8) VALUE 'DISABLED'.


      *****************************************************************
      *  PROCEDURE DIVISION AND MAINLINE CODE                         *
      *****************************************************************
       PROCEDURE DIVISION.
           EXEC CICS HANDLE CONDITION INVREQ  (INVREQ-ERR-SEC)
                                      IOERR   (IOERR-SEC)
                                      ENDDATA (ENDDATA-SEC)
                                      LENGERR (LENGERR-SEC)
                                      END-EXEC.

           MOVE 'MSCMTICS: CONCURRENT SERVER STARTED' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG.

           MOVE LENGTH OF TCPSOCKET-PARM TO HW-LENGTH.
           EXEC CICS RETRIEVE INTO(TCPSOCKET-PARM)
                              LENGTH(HW-LENGTH)
                              END-EXEC.

           PERFORM TAKE-THE-SOCKET THRU TAKE-THE-SOCKET-EXIT
           IF CHILD-SERVER-ERROR < 0 THEN
              PERFORM CLOSE-THE-SOCKET THRU CLOSE-THE-SOCKET-EXIT
              GO TO EXIT-THE-PROGRAM
           END-IF.

           PERFORM VALIDATE-THE-TIM THRU VALIDATE-THE-TIM-EXIT.
           IF CHILD-SERVER-ERROR < 0 THEN
              PERFORM CLOSE-THE-SOCKET THRU CLOSE-THE-SOCKET-EXIT
              GO TO EXIT-THE-PROGRAM
           END-IF.

           MOVE SS-BUILD-TRM-REPLY TO CURRENT-STATE.

           IF LISTENER-WAS-STANDARD THEN
              PERFORM STANDARD-LISTENER THRU STANDARD-LISTENER-EXIT
           ELSE
              PERFORM ENHANCED-LISTENER THRU ENHANCED-LISTENER-EXIT
           END-IF.

           GO TO EXIT-THE-PROGRAM.

      *****************************************************************
      *  STANDARD LISTENER PROCESSING SEQUENCE                        *
      *****************************************************************
       STANDARD-LISTENER.
           PERFORM UNTIL CURRENT-STATE = SS-DONE
              EVALUATE CURRENT-STATE
                 WHEN SS-BUILD-TRM-REPLY
                      PERFORM BUILD-TRM-REPLY THRU BUILD-TRM-REPLY-EXIT
                      MOVE SS-SEND-TRM-REPLY TO NEXT-STATE

                 WHEN SS-SEND-TRM-REPLY
                      PERFORM SEND-TRM-REPLY THRU SEND-TRM-REPLY-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         MOVE SS-RECV-REQUEST TO NEXT-STATE
                      END-IF

                 WHEN SS-RECV-CID
                      PERFORM RECEIVE-CID THRU
                              RECEIVE-CID-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         MOVE SS-RECV-REQUEST TO NEXT-STATE
                      END-IF

                 WHEN SS-RECV-REQUEST
                      MOVE 1 TO COMMAREA-BUF-BYTE-INDEX
                      PERFORM RECEIVE-REQUEST THRU
                              RECEIVE-REQUEST-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         MOVE SS-LINK-TO-USERPROG  TO NEXT-STATE
                      END-IF

                 WHEN SS-LINK-TO-USERPROG
                      PERFORM LINK-TO-USERPROG THRU
                              LINK-TO-USERPROG-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         MOVE SS-SEND-REPLY TO NEXT-STATE
                      END-IF

                 WHEN SS-SEND-REPLY
                      IF CID-VERSION-1 OR
                        (CID-VERSION-2 AND PT-NONE) THEN
      *********************************************************
      *****   THIS IS THE NON-PERSISTENT CASE FOR TRM AND ELM *
      *********************************************************
                         COMPUTE SNDRCV-BUF-AT-BYTE = 1
                         COMPUTE SNDRCV-BUF-LEN = CID-COMMAREA-LEN
                      ELSE
      *********************************************************
      *****   THIS IS THE PERSISTENT CASE FOR TRM AND ELM     *
      *********************************************************
                         COMPUTE SNDRCV-BUF-AT-BYTE = 1
                         COMPUTE SNDRCV-BUF-LEN =
                                       LENGTH OF TCP-BUF-TRMREPLY-LEN +
                                       TCP-BUF-TRMREPLY-LEN +
                                       CID-COMMAREA-LEN
                      END-IF

                      PERFORM WRITE-BUF-TO-SOCKET THRU
                              WRITE-BUF-TO-SOCKET-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         IF CID-VERSION-1 OR
                            (CID-VERSION-2 AND PT-CLOSE) OR
                            (CID-VERSION-2 AND PT-NONE) THEN
                            MOVE SS-SHUTDOWN TO NEXT-STATE
                         ELSE
                            IF CID-VERSION-2 AND
                               (PT-OPEN OR PT-USE) THEN
                               MOVE SS-RECV-CID TO NEXT-STATE
                            END-IF
                         END-IF
                      END-IF

                 WHEN SS-SHUTDOWN
                      PERFORM SHUTDOWN-SOCKET THRU
                              SHUTDOWN-SOCKET-EXIT
                      MOVE SS-CLOSE-SOCKET TO NEXT-STATE

                 WHEN SS-CLOSE-SOCKET
                      PERFORM CLOSE-THE-SOCKET THRU
                              CLOSE-THE-SOCKET-EXIT
                      MOVE SS-DONE TO NEXT-STATE

                 WHEN OTHER
                      MOVE CS-ERROR-UNKNOWN-STATE TO CHILD-SERVER-ERROR
                      MOVE SS-CLOSE-SOCKET TO NEXT-STATE
              END-EVALUATE

              MOVE NEXT-STATE TO CURRENT-STATE
           END-PERFORM.

       STANDARD-LISTENER-EXIT.
           EXIT.

      *****************************************************************
      *  ENHANCED LISTENER PROCESSING SEQUENCE                        *
      *****************************************************************
       ENHANCED-LISTENER.
           PERFORM UNTIL CURRENT-STATE = SS-DONE
              EVALUATE CURRENT-STATE
                 WHEN SS-BUILD-TRM-REPLY
                      PERFORM BUILD-TRM-REPLY THRU BUILD-TRM-REPLY-EXIT

                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE ZERO TO CID-COMMAREA-LEN
                         MOVE SS-SEND-REPLY TO NEXT-STATE
                      ELSE
                         MOVE SS-RECV-REQUEST TO NEXT-STATE
                      END-IF

                 WHEN SS-RECV-REQUEST
                      MOVE BUF-BYTE-INDEX TO COMMAREA-BUF-BYTE-INDEX
                      PERFORM RECEIVE-REQUEST THRU
                              RECEIVE-REQUEST-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         MOVE SS-LINK-TO-USERPROG  TO NEXT-STATE
                      END-IF

                 WHEN SS-RECV-CID
                      PERFORM RECEIVE-CID THRU
                              RECEIVE-CID-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         MOVE SS-BUILD-TRM-REPLY TO NEXT-STATE
                      END-IF

                 WHEN SS-LINK-TO-USERPROG
                      PERFORM LINK-TO-USERPROG THRU
                              LINK-TO-USERPROG-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         MOVE SS-SEND-REPLY TO NEXT-STATE
                      END-IF

                 WHEN SS-SEND-REPLY
                      COMPUTE SNDRCV-BUF-AT-BYTE = 1
                      COMPUTE SNDRCV-BUF-LEN = BUF-BYTE-INDEX - 1

                      PERFORM WRITE-BUF-TO-SOCKET THRU
                              WRITE-BUF-TO-SOCKET-EXIT
                      IF CHILD-SERVER-ERROR < 0 THEN
                         MOVE SS-CLOSE-SOCKET TO NEXT-STATE
                      ELSE
                         IF CID-VERSION-1 OR
                            (CID-VERSION-2 AND PT-CLOSE) OR
                            (CID-VERSION-2 AND PT-NONE) THEN
                            MOVE SS-SHUTDOWN TO NEXT-STATE
                         ELSE
                            IF CID-VERSION-2 AND
                               (PT-OPEN OR PT-USE) THEN
                               MOVE SS-RECV-CID TO NEXT-STATE
                            END-IF
                         END-IF
                      END-IF

                 WHEN SS-SHUTDOWN
                      PERFORM SHUTDOWN-SOCKET THRU
                              SHUTDOWN-SOCKET-EXIT
                      MOVE SS-CLOSE-SOCKET TO NEXT-STATE

                 WHEN SS-CLOSE-SOCKET
                      PERFORM CLOSE-THE-SOCKET THRU
                              CLOSE-THE-SOCKET-EXIT
                      MOVE SS-DONE TO NEXT-STATE

                 WHEN OTHER
                      MOVE CS-ERROR-UNKNOWN-STATE TO CHILD-SERVER-ERROR
                      MOVE SS-CLOSE-SOCKET TO NEXT-STATE
              END-EVALUATE

              MOVE NEXT-STATE TO CURRENT-STATE
           END-PERFORM.

       ENHANCED-LISTENER-EXIT.
           EXIT.

      *****************************************************************
      *  RETEIVE THE TRANSACTION REQUEST MESSAGE FROM THE CONCURRENT  *
      *  SERVER (LISTENER)                                            *
      *****************************************************************
       VALIDATE-THE-TIM.
           MOVE ZERO TO CHILD-SERVER-ERROR.
           IF HW-LENGTH NOT = LENGTH OF STANDARD-LISTENER-TIM AND
              HW-LENGTH NOT = LENGTH OF ENHANCED-LISTENER-TIM THEN
              MOVE TP-VALIDATE-1 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-BAD-RETRIEVE TO CHILD-SERVER-ERROR
              GO TO VALIDATE-THE-TIM-EXIT
           END-IF.

           IF HW-LENGTH = LENGTH OF STANDARD-LISTENER-TIM THEN
              MOVE 'S' TO LISTENER-TYPE
              MOVE LSTN-CLIENT-IN-DATA TO CLIENT-IN-DATA-RECV-AREA
           ELSE
              MOVE 'E' TO LISTENER-TYPE
              MOVE DA2-CLIENT-IN-DATA TO CLIENT-IN-DATA-RECV-AREA
           END-IF.

           MOVE CID-RA-FORMAT        TO CID-FORMAT.
           IF CID-FORMAT-IBM THEN
              MOVE CID-IBM-USERID       TO CID-USERID
              MOVE CID-IBM-PASSWORD     TO CID-PASSWORD
              MOVE CID-IBM-LINK-TO-PROG TO CID-LINK-TO-PROG
              MOVE CID-IBM-COMMAREA-LEN TO CID-COMMAREA-LEN
              MOVE CID-IBM-DATA-LEN     TO CID-DATA-LEN
              MOVE CID-IBM-VERSION      TO CID-VERSION
              MOVE CID-IBM-FLAGS        TO CID-FLAGS
           ELSE
              MOVE CID-MS-USERID        TO CID-USERID
              MOVE CID-MS-PASSWORD      TO CID-PASSWORD
              MOVE CID-MS-LINK-TO-PROG  TO CID-LINK-TO-PROG
              MOVE CID-MS-COMMAREA-LEN  TO CID-COMMAREA-LEN
              MOVE CID-MS-DATA-LEN      TO CID-DATA-LEN
              MOVE CID-MS-VERSION       TO CID-VERSION
              MOVE CID-MS-FLAGS         TO CID-FLAGS
           END-IF.

           PERFORM VALIDATE-THE-CID THRU VALIDATE-THE-CID-EXIT.
           IF CHILD-SERVER-ERROR < 0 THEN
              GO TO VALIDATE-THE-TIM-EXIT
           END-IF.

       VALIDATE-THE-TIM-EXIT.
           EXIT.

      *****************************************************************
      *  RETEIVE THE TRANSACTION REQUEST MESSAGE FROM THE CONCURRENT  *
      *  SERVER (LISTENER)                                            *
      *****************************************************************
       VALIDATE-THE-CID.
           IF CID-FORMAT-IBM THEN
              MOVE TP-BAD-CID-FORMAT TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-BAD-CID TO CHILD-SERVER-ERROR
              GO TO VALIDATE-THE-CID-EXIT
           END-IF.
           
           IF NOT CID-VERSION-1 AND NOT CID-VERSION-2 THEN
              MOVE  TP-BAD-CID-VERSION-1 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-BAD-CID TO CHILD-SERVER-ERROR
              GO TO VALIDATE-THE-CID-EXIT
           END-IF.           

           IF CID-VERSION-2 THEN
      *       EVALUATE CID-FLAGS AND EXTRACT PERSISTENCE
      *       TYPE INDICATOR
              MOVE CID-FLAGS TO PERSISTENCE-TYPE-BYTES
              MOVE LOW-VALUES TO PERSISTENCE-TYPE-BYTES(1:1)
              COMPUTE PERSISTENCE-TYPE = PERSISTENCE-TYPE * 16
                      END-COMPUTE
              MOVE LOW-VALUES TO PERSISTENCE-TYPE-BYTES(1:1)
              COMPUTE PERSISTENCE-TYPE = PERSISTENCE-TYPE / 16
                      END-COMPUTE

      *       EVALUATE CID-FLAGS AND USE TICS WORK AREA INDICATOR
              MOVE CID-FLAGS TO USE-TICS-WORKAREA-BYTE
              COMPUTE USE-TICS-WORKAREA = USE-TICS-WORKAREA / 16
                      END-COMPUTE
              MOVE LOW-VALUES TO USE-TICS-WORKAREA-BYTE(1:1)
              COMPUTE USE-TICS-WORKAREA = USE-TICS-WORKAREA / 16
                      END-COMPUTE

           END-IF.

           MOVE TP-VALIDATE-2 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

       VALIDATE-THE-CID-EXIT.
           EXIT.

      *****************************************************************
      *   ISSUE 'TAKESOCKET' CALL TO ACQUIRE A SOCKET WHICH WAS       *
      *   GIVEN BY THE LISTENER PROGRAM.                              *
      *****************************************************************
       TAKE-THE-SOCKET.
           MOVE AF-INET          TO LI-DOMAIN.
           MOVE LSTN-NAME        TO LI-NAME.
           MOVE LSTN-SUBTASKNAME TO LI-SUBTASKNAME.
           MOVE LOW-VALUES       TO LI-RESERVED.

           MOVE GIVE-TAKE-SOCKET TO TCP-SOCKET.
           MOVE ZERO             TO TCP-ERRNO TCP-RETCODE.
           CALL 'EZASOKET' USING SOKET-TAKESOCKET
                                 TCP-SOCKET
                                 LISTENER-ID
                                 TCP-ERRNO
                                 TCP-RETCODE.

           IF TCP-RETCODE < 0 THEN
              MOVE TP-TAKESOC-1 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-TAKESOCKET-FAILED TO CHILD-SERVER-ERROR
              GO TO TAKE-THE-SOCKET-EXIT
           END-IF.

           MOVE 'Y'         TO SOCKET-OPENED.
           MOVE TCP-RETCODE TO TCP-SOCKET.

       TAKE-THE-SOCKET-EXIT.
           EXIT.

      *****************************************************************
      * CHECK THAT THE CONTENT OF THE CLIENT IN DATA IS VALID AND     *
      * WILL THEREFORE ALLOW THE SERVER PROGRAM TO BE EXECUTED.       *
      *****************************************************************
       BUILD-TRM-REPLY.
           MOVE 5 TO BUF-BYTE-INDEX.
           MOVE 0 TO TCP-BUF-TRMREPLY-LEN.

           EXEC CICS INQUIRE PROGRAM(CID-LINK-TO-PROG)
                             STATUS(STATUS-PROGID)
                             RESP(CMD-RESP)
                             END-EXEC.

           MOVE FFC-VERSION-ID TO FF-MV-CODE.
           MOVE FF-MSCMTICS-VERSION TO
                TCP-BUF(BUF-BYTE-INDEX:LENGTH OF FF-MSCMTICS-VERSION).
           COMPUTE BUF-BYTE-INDEX = BUF-BYTE-INDEX +
                                     LENGTH OF FF-MSCMTICS-VERSION.

           IF CMD-RESP NOT = DFHRESP(NORMAL) THEN
              MOVE TP-TRMREPLY-1 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-INQ-FAILED TO CHILD-SERVER-ERROR

              MOVE FFC-INQ-FAILED TO FF-IF-CODE
              MOVE CMD-RESP TO FF-IF-CMDRESP
              MOVE FF-INQUIRE-FAILED TO
                   TCP-BUF(BUF-BYTE-INDEX:LENGTH OF FF-INQUIRE-FAILED)
              COMPUTE BUF-BYTE-INDEX = BUF-BYTE-INDEX +
                                     LENGTH OF FF-INQUIRE-FAILED
           ELSE
              IF DFHVALUE(DISABLED) = STATUS-PROGID THEN
                 MOVE TP-TRMREPLY-2 TO TRACE-ID
                 PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
                 MOVE CS-ERROR-INQ-STATUS TO CHILD-SERVER-ERROR

                 MOVE FFC-INQ-STATUS TO FF-IS-CODE
                 MOVE FF-INQUIRE-STATUS TO
                   TCP-BUF(BUF-BYTE-INDEX:LENGTH OF FF-INQUIRE-STATUS)
                 COMPUTE BUF-BYTE-INDEX = BUF-BYTE-INDEX +
                                     LENGTH OF FF-INQUIRE-STATUS
              ELSE
                 CONTINUE
              END-IF
           END-IF.

           COMPUTE TCP-NBYTES  = BUF-BYTE-INDEX - 1.
           COMPUTE TCP-BUF-TRMREPLY-LEN =
                 TCP-NBYTES - LENGTH OF TCP-BUF-TRMREPLY-LEN.

       BUILD-TRM-REPLY-EXIT.
           EXIT.

      *****************************************************************
      *   ISSUE 'WRITE' TO SEND THE TRM REPLY                         *
      *****************************************************************
       SEND-TRM-REPLY.
           COMPUTE SNDRCV-BUF-LEN = TCP-BUF-TRMREPLY-LEN +
                                    LENGTH OF TCP-BUF-TRMREPLY-LEN.
           COMPUTE SNDRCV-BUF-AT-BYTE = 1.
           PERFORM WRITE-BUF-TO-SOCKET THRU
                   WRITE-BUF-TO-SOCKET-EXIT.
           IF CHILD-SERVER-ERROR < 0 THEN
              GO TO SEND-TRM-REPLY-EXIT
           END-IF.

       SEND-TRM-REPLY-EXIT.
           EXIT.

      *****************************************************************
      *  SHUTDOWN THE SENDING SIDE OF THE SOCKET                      *
      *****************************************************************
       SHUTDOWN-SOCKET.
           MOVE THC-END-TO TO TCP-HOW.
           CALL 'EZASOKET' USING SOKET-SHUTDOWN
                                 TCP-SOCKET
                                 TCP-HOW
                                 TCP-ERRNO
                                 TCP-RETCODE.

           IF TCP-RETCODE < 0 THEN
              MOVE TP-SHUTDOWN-1 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-SHUTDOWN TO CHILD-SERVER-ERROR
              GO TO SHUTDOWN-SOCKET-EXIT
           END-IF.

       SHUTDOWN-SOCKET-EXIT.
           EXIT.

      *****************************************************************
      *  ISSUE 'RECV' SOCKET TO RECEIVE INPUT THE CLIENT IN DATA      *
      *****************************************************************
       RECEIVE-CID.
           MOVE TP-RECVCID-1 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

           MOVE LENGTH OF CLIENT-IN-DATA-RECV-AREA TO SNDRCV-BUF-LEN.
           MOVE 1 TO SNDRCV-BUF-AT-BYTE.

           PERFORM RECV-BUF-FROM-SOCKET THRU
                   RECV-BUF-FROM-SOCKET-EXIT.
           IF CHILD-SERVER-ERROR < 0 THEN
              GO TO RECEIVE-CID-EXIT
           END-IF.

           IF LENGTH OF CLIENT-IN-DATA-RECV-AREA NOT =
              BYTES-RECEIVED THEN
              MOVE TP-RECVCID-2 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-BAD-CID TO CHILD-SERVER-ERROR
              GO TO RECEIVE-CID-EXIT
           END-IF.

           MOVE TP-RECVCID-3 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

           MOVE TCP-BUF TO CLIENT-IN-DATA-RECV-AREA.

           MOVE CID-RA-FORMAT        TO CID-FORMAT.
           IF CID-FORMAT-IBM THEN
              MOVE CID-IBM-USERID       TO CID-USERID
              MOVE CID-IBM-PASSWORD     TO CID-PASSWORD
              MOVE CID-IBM-LINK-TO-PROG TO CID-LINK-TO-PROG
              MOVE CID-IBM-COMMAREA-LEN TO CID-COMMAREA-LEN
              MOVE CID-IBM-DATA-LEN     TO CID-DATA-LEN
              MOVE CID-IBM-VERSION      TO CID-VERSION
              MOVE CID-IBM-FLAGS        TO CID-FLAGS
           ELSE
              MOVE CID-MS-USERID        TO CID-USERID
              MOVE CID-MS-PASSWORD      TO CID-PASSWORD
              MOVE CID-MS-LINK-TO-PROG  TO CID-LINK-TO-PROG
              MOVE CID-MS-COMMAREA-LEN  TO CID-COMMAREA-LEN
              MOVE CID-MS-DATA-LEN      TO CID-DATA-LEN
              MOVE CID-MS-VERSION       TO CID-VERSION
              MOVE CID-MS-FLAGS         TO CID-FLAGS
           END-IF.

           PERFORM VALIDATE-THE-CID THRU VALIDATE-THE-CID-EXIT.
           IF CHILD-SERVER-ERROR < 0 THEN
              GO TO RECEIVE-CID-EXIT
           END-IF.

       RECEIVE-CID-EXIT.
           EXIT.

      *****************************************************************
      *  ISSUE 'RECV' SOCKET TO RECEIVE INPUT DATA FROM CLIENT        *
      *****************************************************************
       RECEIVE-REQUEST.
           IF CID-VERSION-1 THEN
              MOVE CID-COMMAREA-LEN TO SNDRCV-BUF-LEN
           ELSE
              MOVE CID-DATA-LEN TO SNDRCV-BUF-LEN
           END-IF.
           MOVE 0 TO RECV-COMMAREA-LEN.
           MOVE COMMAREA-BUF-BYTE-INDEX TO SNDRCV-BUF-AT-BYTE.

           PERFORM RECV-BUF-FROM-SOCKET THRU
                   RECV-BUF-FROM-SOCKET-EXIT.
           IF CHILD-SERVER-ERROR < 0 THEN
              GO TO RECEIVE-REQUEST-EXIT
           END-IF.

           MOVE BYTES-RECEIVED TO RECV-COMMAREA-LEN.

           MOVE TP-RECVREQ-1 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

       RECEIVE-REQUEST-EXIT.
           EXIT.

      *****************************************************************
      *  LINK TO THE USER PROGRAM TO PROCESS THE REQUEST DATA         *
      *****************************************************************
       LINK-TO-USERPROG.
           IF CID-VERSION-2 AND UTWA-TRUE THEN
              IF CID-FLAGS-PERSISTENT-NONE OR
                 CID-FLAGS-PERSISTENT-OPEN THEN
      *          FOR PERSISTENT CALLS: INIT TWA ON OPEN, LEAVE TWA
      *                                ALONE ON USE AND CLOSE
      *          FOR NON PERSISTENT:   TWA IS NOT USED SO INIT IT
                 MOVE LOW-VALUES TO TICS-WORK-AREA
              END-IF

              MOVE LOW-VALUES TO COMMAREA-DATA-TWA
              COMPUTE CALLING-COMMAREA-LEN = LENGTH OF TICS-WORK-AREA +
                                             CID-COMMAREA-LEN
              END-COMPUTE
              MOVE TCP-BUF(COMMAREA-BUF-BYTE-INDEX:RECV-COMMAREA-LEN)
                   TO COMMAREA-DATA-TWA(1:RECV-COMMAREA-LEN)
           ELSE
              MOVE LOW-VALUES TO COMMAREA-DATA
              COMPUTE CALLING-COMMAREA-LEN = CID-COMMAREA-LEN
              END-COMPUTE
              MOVE TCP-BUF(COMMAREA-BUF-BYTE-INDEX:RECV-COMMAREA-LEN)
                   TO COMMAREA-DATA(1:RECV-COMMAREA-LEN)
           END-IF.
           MOVE TP-LINKTO-1 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

           IF LISTENER-WAS-STANDARD AND
              (CID-VERSION-1 OR
               (CID-VERSION-2 AND PT-NONE)) THEN
      *********************************************************
      *****   THIS IS THE NON-PERSISTENT CASE FOR STD TRM     *
      *********************************************************
              MOVE COMMAREA-BUF-BYTE-INDEX TO BUF-BYTE-INDEX
              EXEC CICS HANDLE ABEND
                        LABEL(LINK-TO-USERPROG-ABEND-NPTRM)
                        END-EXEC

              EXEC CICS LINK COMMAREA(COMMAREA-DATA)
                             LENGTH(CALLING-COMMAREA-LEN)
                             PROGRAM(CID-LINK-TO-PROG)
                             END-EXEC

              IF CMD-RESP = DFHRESP(PGMIDERR) THEN
                  GO TO LINK-TO-USERPROG-INVALID-NPTRM
              END-IF

              EXEC CICS HANDLE ABEND CANCEL END-EXEC

           ELSE IF CID-VERSION-2 AND PT-NONE THEN
      *********************************************************
      *****   THIS IS THE NON-PERSISTENT CASE FOR ELM         *
      *********************************************************
              MOVE COMMAREA-BUF-BYTE-INDEX TO BUF-BYTE-INDEX
              EXEC CICS HANDLE ABEND LABEL(LINK-TO-USERPROG-ABEND)
                                     END-EXEC

              EXEC CICS LINK COMMAREA(COMMAREA-DATA)
                             LENGTH(CALLING-COMMAREA-LEN)
                             PROGRAM(CID-LINK-TO-PROG)
                             END-EXEC

              IF CMD-RESP = DFHRESP(PGMIDERR) THEN
                  GO TO LINK-TO-USERPROG-INVALID
              END-IF

              EXEC CICS HANDLE ABEND CANCEL END-EXEC

           ELSE
      *********************************************************
      *****   THIS IS THE PERSISTENT CASE
      *********************************************************
              IF LISTENER-WAS-STANDARD THEN
      *          FOR STANDARD, NOTHING IS IN THE TCP BUFFER YET
                 COMPUTE BUF-BYTE-INDEX = COMMAREA-BUF-BYTE-INDEX +
                                         LENGTH OF TCP-BUF-TRMREPLY-LEN
              ELSE
      *          FOR ENHANCED, THE TRM REPLY IS ALREADY IN THE TCP BUF
                 COMPUTE BUF-BYTE-INDEX = COMMAREA-BUF-BYTE-INDEX
              END-IF

              EXEC CICS HANDLE ABEND LABEL(LINK-TO-USERPROG-ABEND)
                                     END-EXEC

              EXEC CICS LINK COMMAREA(COMMAREA-DATA)
                             LENGTH(CALLING-COMMAREA-LEN)
                             PROGRAM(CID-LINK-TO-PROG)
                             RESP(CMD-RESP)
                             END-EXEC

              IF CMD-RESP = DFHRESP(PGMIDERR) THEN
                  GO TO LINK-TO-USERPROG-INVALID
              END-IF

              PERFORM BUILD-STATUS-EXECUTION-OK THRU
                      BUILD-STATUS-EXECUTION-OK-EXIT

              EXEC CICS HANDLE ABEND CANCEL END-EXEC
           END-IF.

           MOVE TP-LINKTO-2 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

           IF CID-VERSION-2 AND UTWA-TRUE THEN
              MOVE COMMAREA-DATA-TWA(1:CID-COMMAREA-LEN) TO
                   TCP-BUF(COMMAREA-BUF-BYTE-INDEX:CID-COMMAREA-LEN)
           ELSE
              MOVE COMMAREA-DATA(1:CID-COMMAREA-LEN) TO
                   TCP-BUF(COMMAREA-BUF-BYTE-INDEX:CID-COMMAREA-LEN)
           END-IF.
           COMPUTE BUF-BYTE-INDEX = COMMAREA-BUF-BYTE-INDEX +
                                    CID-COMMAREA-LEN.
           GO TO LINK-TO-USERPROG-EXIT.

       LINK-TO-USERPROG-ABEND.
           PERFORM BUILD-STATUS-PGM-ABEND THRU
                   BUILD-STATUS-PGM-ABEND-EXIT.

           EXEC CICS HANDLE ABEND CANCEL END-EXEC.

           GO TO LINK-TO-USERPROG-EXIT.

       LINK-TO-USERPROG-ABEND-NPTRM.
           MOVE TP-NPTRM-PGM-ABEND TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.
           MOVE CS-NPTRM-PGM-ABEND TO CHILD-SERVER-ERROR.

           EXEC CICS HANDLE ABEND CANCEL END-EXEC.

           GO TO LINK-TO-USERPROG-EXIT.

       LINK-TO-USERPROG-INVALID.
           PERFORM BUILD-STATUS-PGM-INVALID THRU
                   BUILD-STATUS-PGM-INVALID-EXIT.

           EXEC CICS HANDLE ABEND CANCEL END-EXEC.

           GO TO LINK-TO-USERPROG-EXIT.

       LINK-TO-USERPROG-INVALID-NPTRM.
           MOVE TP-NPTRM-PGM-INVALID TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.
           MOVE CS-NPTRM-PGM-INVALID TO CHILD-SERVER-ERROR.

           EXEC CICS HANDLE ABEND CANCEL END-EXEC.

           GO TO LINK-TO-USERPROG-EXIT.

       LINK-TO-USERPROG-EXIT.
           EXIT.

      *****************************************************************
      *   BUILD THE PERSISTENT CONNECTION EXECUTION OK STATUS HEADER  *
      *****************************************************************
       BUILD-STATUS-EXECUTION-OK.
           MOVE FFC-EXECUTION-OK TO FF-EO-CODE.
           MOVE FF-EXECUTION-OK TO
                TCP-BUF(BUF-BYTE-INDEX:LENGTH OF FF-EXECUTION-OK).
           COMPUTE BUF-BYTE-INDEX = BUF-BYTE-INDEX +
                                     LENGTH OF FF-EXECUTION-OK.

           IF LISTENER-WAS-STANDARD THEN
              COMPUTE TCP-BUF-TRMREPLY-LEN =
                   BUF-BYTE-INDEX - 1 - LENGTH OF TCP-BUF-TRMREPLY-LEN
           ELSE
              COMPUTE TCP-BUF-TRMREPLY-LEN = TCP-BUF-TRMREPLY-LEN +
                                             LENGTH OF FF-EXECUTION-OK
           END-IF.

           COMPUTE COMMAREA-BUF-BYTE-INDEX = BUF-BYTE-INDEX.

       BUILD-STATUS-EXECUTION-OK-EXIT.
           EXIT.

      *****************************************************************
      *   BUILD THE PERSISTENT CONNECTION PROGRAM ABEND HEADER        *
      *****************************************************************
       BUILD-STATUS-PGM-ABEND.
           MOVE FFC-PROGRAM-ABEND TO FF-PA-CODE.
           MOVE CID-LINK-TO-PROG TO FF-PA-PROGRAM.
           MOVE FF-PROGRAM-ABEND TO
                TCP-BUF(BUF-BYTE-INDEX:LENGTH OF FF-PROGRAM-ABEND).
           COMPUTE BUF-BYTE-INDEX = BUF-BYTE-INDEX +
                                     LENGTH OF FF-PROGRAM-ABEND.

           IF LISTENER-WAS-STANDARD THEN
              COMPUTE TCP-BUF-TRMREPLY-LEN =
                   BUF-BYTE-INDEX - 1 - LENGTH OF TCP-BUF-TRMREPLY-LEN
           ELSE
              COMPUTE TCP-BUF-TRMREPLY-LEN = TCP-BUF-TRMREPLY-LEN +
                                             LENGTH OF FF-PROGRAM-ABEND
           END-IF.

           COMPUTE COMMAREA-BUF-BYTE-INDEX = BUF-BYTE-INDEX.

       BUILD-STATUS-PGM-ABEND-EXIT.
           EXIT.

      *****************************************************************
      *   BUILD THE PERSISTENT CONNECTION PROGRAM INVALID HEADER      *
      *****************************************************************
       BUILD-STATUS-PGM-INVALID.
           MOVE FFC-PROGID-INVALID TO FF-PI-CODE.
           MOVE CID-LINK-TO-PROG TO FF-PI-PROGRAM.
           MOVE FF-PROGRAM-INVALID TO
                TCP-BUF(BUF-BYTE-INDEX:LENGTH OF FF-PROGRAM-INVALID).
           COMPUTE BUF-BYTE-INDEX = BUF-BYTE-INDEX +
                                     LENGTH OF FF-PROGRAM-INVALID.

           IF LISTENER-WAS-STANDARD THEN
              COMPUTE TCP-BUF-TRMREPLY-LEN =
                   BUF-BYTE-INDEX - 1 - LENGTH OF TCP-BUF-TRMREPLY-LEN
           ELSE
              COMPUTE TCP-BUF-TRMREPLY-LEN = TCP-BUF-TRMREPLY-LEN +
                                          LENGTH OF FF-PROGRAM-INVALID
           END-IF.

           COMPUTE COMMAREA-BUF-BYTE-INDEX = BUF-BYTE-INDEX.


       BUILD-STATUS-PGM-INVALID-EXIT.
           EXIT.

      *****************************************************************
      *   ISSUE 'CLOSE' SOCKET TO CLOSE THE SOCKET DESCRIPTOR         *
      *****************************************************************
       CLOSE-THE-SOCKET.
           IF SOCKET-IS-CLOSED THEN
              GO TO CLOSE-THE-SOCKET-EXIT
           END-IF.

           CALL 'EZASOKET' USING SOKET-CLOSE
                                 TCP-SOCKET
                                 TCP-ERRNO
                                 TCP-RETCODE.

           IF TCP-RETCODE < 0 THEN
              MOVE TP-CLOSE-1 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
           END-IF.

           MOVE 'N' TO SOCKET-OPENED.

       CLOSE-THE-SOCKET-EXIT.
           EXIT.

      *****************************************************************
      ** WRITE SOME DATA IN TCP-BUF TO THE SOCKET                     *
      *****************************************************************
       WRITE-BUF-TO-SOCKET.
           MOVE TP-BUF2SOC-1 TO TRACE-ID
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT

           MOVE SNDRCV-BUF-LEN TO TCP-NBYTES.

           PERFORM UNTIL TCP-NBYTES <= 0
              PERFORM WRITE-TO-SOCKET THRU
                      WRITE-TO-SOCKET-EXIT

              IF CHILD-SERVER-ERROR < 0 THEN
                 GO TO WRITE-BUF-TO-SOCKET-EXIT
              END-IF

              COMPUTE TCP-NBYTES = TCP-NBYTES - TCP-RETCODE
              COMPUTE SNDRCV-BUF-AT-BYTE = SNDRCV-BUF-AT-BYTE +
                                           TCP-RETCODE
           END-PERFORM.

       WRITE-BUF-TO-SOCKET-EXIT.
           EXIT.

      *****************************************************************
      ** WRITE TO THE SOCKET                                          *
      *****************************************************************
       WRITE-TO-SOCKET.
           MOVE ZERO TO TCP-ERRNO TCP-RETCODE.
           CALL 'EZASOKET' USING SOKET-WRITE
                                 TCP-SOCKET
                                 TCP-NBYTES
                                 TCP-BUF-CHAR(SNDRCV-BUF-AT-BYTE)
                                 TCP-ERRNO
                                 TCP-RETCODE.

           IF TCP-RETCODE < 0 THEN
              MOVE TP-WRI2SOC-2 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-WRITE-FAILED TO CHILD-SERVER-ERROR
              GO TO WRITE-TO-SOCKET-EXIT
           END-IF.

           MOVE TP-WRI2SOC-3 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

       WRITE-TO-SOCKET-EXIT.
           EXIT.

      *****************************************************************
      ** RECEIVE SOME DATA FROM THE SOCKET INTO TCP-BUF               *
      *****************************************************************
       RECV-BUF-FROM-SOCKET.
           MOVE SNDRCV-BUF-LEN TO TCP-NBYTES.
           MOVE TCP-FLAGS-NO-FLAG TO TCP-FLAGS.
           MOVE 0 TO BYTES-RECEIVED.

           PERFORM UNTIL SNDRCV-BUF-LEN <= 0
              PERFORM RECV-FROM-SOCKET THRU RECV-FROM-SOCKET-EXIT

      ******* AN ERROR OCCURRED
              IF CHILD-SERVER-ERROR < 0 THEN
                 GO TO RECV-BUF-FROM-SOCKET-EXIT
              END-IF

      ******* SOCKET WAS CLOSED BUT ALL IS OK
              IF TCP-RETCODE = 0 THEN
                 GO TO RECV-BUF-FROM-SOCKET-EXIT
              END-IF

              COMPUTE TCP-NBYTES = TCP-NBYTES - TCP-RETCODE
              COMPUTE SNDRCV-BUF-LEN = SNDRCV-BUF-LEN - TCP-RETCODE
              COMPUTE SNDRCV-BUF-AT-BYTE = SNDRCV-BUF-AT-BYTE +
                                           TCP-RETCODE
              COMPUTE BYTES-RECEIVED = BYTES-RECEIVED + TCP-RETCODE

           END-PERFORM.

       RECV-BUF-FROM-SOCKET-EXIT.
           EXIT.

      *****************************************************************
      ** ISSUE A 'RECV' FOR THE SOCKET                                *
      *****************************************************************
       RECV-FROM-SOCKET.
           MOVE ZERO TO TCP-ERRNO TCP-RETCODE.
           CALL 'EZASOKET' USING
                           SOKET-RECV
                           TCP-SOCKET
                           TCP-FLAGS
                           TCP-NBYTES
                           TCP-BUF-CHAR(SNDRCV-BUF-AT-BYTE)
                           TCP-ERRNO
                           TCP-RETCODE.

           IF TCP-RETCODE = 0 THEN
              MOVE TP-RECV-1 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              GO TO RECV-FROM-SOCKET-EXIT
           END-IF.

           IF TCP-RETCODE < 0 THEN
              MOVE TP-RECV-2 TO TRACE-ID
              PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT
              MOVE CS-ERROR-RECV-FAILED TO CHILD-SERVER-ERROR
              GO TO RECV-FROM-SOCKET-EXIT
           END-IF.

           MOVE TP-RECV-3 TO TRACE-ID.
           PERFORM TRACE-POINTS THRU TRACE-POINTS-EXIT.

       RECV-FROM-SOCKET-EXIT.
           EXIT.

      *****************************************************************
      *  FORMAT AND WRITE TRACE MESSAGES                              *
      *****************************************************************
       TRACE-POINTS.
           IF LOGGING-IS-DISABLED
              GO TO TRACE-POINTS-EXIT
           END-IF.

           MOVE SPACES TO LOG-MSG-BUFFER.

           EVALUATE TRACE-ID
              WHEN TP-NPTRM-PGM-INVALID
                 STRING ' EXEC CICS LINK PROGRAM(' DELIMITED SIZE
                        CID-LINK-TO-PROG              DELIMITED SPACE
                        ') FAILED W/PGM INVALID'      DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-NPTRM-PGM-ABEND
                 STRING ' EXEC CICS LINK PROGRAM(' DELIMITED SIZE
                        CID-LINK-TO-PROG              DELIMITED SPACE
                        ') ABEND'                    DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-TAKESOC-1
                 MOVE 'TAKESOCKET FAILED' TO TCP-ERROR-MSG
                 MOVE TCP-RETCODE         TO TCP-ERROR-RETCODE
                 MOVE TCP-ERRNO           TO TCP-ERROR-ERRNO
                 MOVE TCP-ERROR-INFO      TO LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG

              WHEN TP-TRMREPLY-1
                 STRING ' EXEC CICS INQUIRE PROGRAM(' DELIMITED SIZE
                        CID-LINK-TO-PROG              DELIMITED SPACE
                        ') FAILED'                    DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-TRMREPLY-2
                 MOVE STATUS-PROGID TO EDIT-NUM-3-NS
                 STRING ' INQ PROGRAM RETURNED STATUS=' DELIMITED SIZE
                        EDIT-NUM-3-NS                   DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-SHUTDOWN-1
                 MOVE ' SHUTDOWN FAILED' TO TCP-ERROR-MSG
                 MOVE TCP-RETCODE        TO TCP-ERROR-RETCODE
                 MOVE TCP-ERRNO          TO TCP-ERROR-ERRNO
                 MOVE TCP-ERROR-INFO     TO LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG

              WHEN TP-RECVREQ-1
                 MOVE BYTES-RECEIVED  TO EDIT-NUM-3-1
                 STRING ' DATA RECEIVED= ' DELIMITED SIZE
                        EDIT-NUM-3-1 DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-BAD-CID-VERSION-1
                 MOVE ZERO TO BTN-NUMBER
                 MOVE CID-VERSION TO BTN-BYTE
                 MOVE BTN-NUMBER TO EDIT-NUM-1
                 STRING ' CID VERSION= ' DELIMITED SIZE
                        EDIT-NUM-1 DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG
                 
              WHEN TP-BAD-CID-FORMAT
                 MOVE ZERO TO BTN-NUMBER
                 MOVE CID-FORMAT TO BTN-BYTE
                 MOVE BTN-NUMBER TO EDIT-NUM-1
                 STRING ' CID FORMAT= ' DELIMITED SIZE
                        EDIT-NUM-1 DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG                 

              WHEN TP-BAD-PERSISTENT-TYPE-1
                 MOVE ZERO TO BTN-NUMBER
                 MOVE CID-FLAGS TO BTN-BYTES
                 MOVE BTN-NUMBER TO EDIT-NUM-1
                 STRING ' CID FLAGS= ' DELIMITED SIZE
                        EDIT-NUM-1 DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-RECVCID-1
                 MOVE ' ISSUING RECEIVE FOR CID' TO
                      LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG

              WHEN TP-RECVCID-2
                 MOVE ' CID WAS NOT RECEIVED OR IS TOO SHORT' TO
                      LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG

              WHEN TP-RECVCID-3
                 MOVE BYTES-RECEIVED  TO EDIT-NUM-3-1
                 STRING ' CID RECEIVED= ' DELIMITED SIZE
                        EDIT-NUM-3-1 DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-LINKTO-1
                 STRING ' LINK PROGRAM="' DELIMITED SIZE
                        CID-LINK-TO-PROG DELIMITED SIZE
                        '"' DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' LINK COMMAREA="' DELIMITED SIZE
                        COMMAREA-DATA(1:RECV-COMMAREA-LEN)
                                                 DELIMITED SIZE
                        '"' DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE RECV-COMMAREA-LEN TO EDIT-NUM-3-1
                 STRING ' LINK RECV COMMAREA LEN=' DELIMITED SIZE
                        EDIT-NUM-3-1    DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE CID-COMMAREA-LEN TO EDIT-NUM-3-1
                 STRING ' LINK CID COMMAREA LEN=' DELIMITED SIZE
                        EDIT-NUM-3-1    DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-LINKTO-2
                 STRING ' RETURNED COMMAREA="' DELIMITED SIZE
                        COMMAREA-DATA(1:CID-COMMAREA-LEN)
                                       DELIMITED SIZE
                        '"' DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-CLOSE-1
                 MOVE ' CLOSE FAILED'  TO TCP-ERROR-MSG
                 MOVE TCP-RETCODE      TO TCP-ERROR-RETCODE
                 MOVE TCP-ERRNO        TO TCP-ERROR-ERRNO
                 MOVE TCP-ERROR-INFO   TO LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG

              WHEN TP-BUF2SOC-1
                 MOVE SNDRCV-BUF-LEN TO EDIT-NUM-4
                 STRING ' COMMAREA SEND LEN=' DELIMITED SIZE
                        EDIT-NUM-4    DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-WRI2SOC-2
                  MOVE ' WRITE FAILED' TO TCP-ERROR-MSG
                  MOVE TCP-RETCODE     TO TCP-ERROR-RETCODE
                  MOVE TCP-ERRNO       TO TCP-ERROR-ERRNO
                  MOVE TCP-ERROR-INFO  TO LOG-MSG-BUFFER
                  PERFORM WRITE-LOG-MSG

              WHEN TP-WRI2SOC-3
                 MOVE TCP-RETCODE TO EDIT-NUM-3
                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' BYTES SENT=' DELIMITED SIZE
                        EDIT-NUM-3     DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' DATA SENT='     DELIMITED SIZE
                     TCP-BUF(SNDRCV-BUF-AT-BYTE:TCP-RETCODE)
                                          DELIMITED SIZE
                     INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-RECV-1
                 MOVE ' ''SOCKET CLOSED'' STATUS RETURNED ON RECV'
                        TO LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG

              WHEN TP-RECV-2
                 MOVE ' RECV FAILED' TO TCP-ERROR-MSG
                 MOVE TCP-RETCODE    TO TCP-ERROR-RETCODE
                 MOVE TCP-ERRNO      TO TCP-ERROR-ERRNO
                 MOVE TCP-ERROR-INFO TO LOG-MSG-BUFFER
                 PERFORM WRITE-LOG-MSG

              WHEN TP-RECV-3
                 MOVE TCP-RETCODE TO EDIT-NUM-3
                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' BYTES RECVD=' DELIMITED SIZE
                        EDIT-NUM-3      DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' DATA RECVD='   DELIMITED SIZE
                     TCP-BUF(SNDRCV-BUF-AT-BYTE:TCP-RETCODE)
                                         DELIMITED SIZE
                     INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-VALIDATE-1
                 MOVE LENGTH OF STANDARD-LISTENER-TIM TO EDIT-NUM-1
                 MOVE LENGTH OF ENHANCED-LISTENER-TIM TO EDIT-NUM-2
                 MOVE HW-LENGTH                TO EDIT-NUM-3-1
                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' RETRIEVE TCPSOCKET-PARM ERROR' DELIMITED SIZE
                        ', EXPECTED '                    DELIMITED SIZE
                        EDIT-NUM-1                       DELIMITED SIZE
                        ' OR '                           DELIMITED SIZE
                        EDIT-NUM-2                       DELIMITED SIZE
                        ', ACTUAL='                      DELIMITED SIZE
                        EDIT-NUM-3-1                     DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN TP-VALIDATE-2
                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE GIVE-TAKE-SOCKET TO EDIT-NUM-3
                 STRING ' LSTN GIVE-TAKE-SOCKET=' DELIMITED SIZE
                        EDIT-NUM-3                DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' CLIENT-IN-DATA='       DELIMITED SIZE
                        '"'                      DELIMITED SIZE
                        CLIENT-IN-DATA-RECV-AREA DELIMITED SIZE
                        '"'                      DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' LSTN NAME=' DELIMITED SIZE
                        LSTN-NAME     DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' LSTN SUBTASKNAME=' DELIMITED SIZE
                        LSTN-SUBTASKNAME     DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' LSTN CID-USERID='     DELIMITED SIZE
                        CID-USERID              DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' LSTN CID-PASSWORD=' DELIMITED SIZE
                        CID-PASSWORD         DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' LSTN CID-LINK-PROG=' DELIMITED SIZE
                        CID-LINK-TO-PROG      DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE CID-COMMAREA-LEN TO EDIT-NUM-1
                 STRING ' LSTN CID-COMMAREA-LEN=' DELIMITED SIZE
                        EDIT-NUM-1                DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE CID-DATA-LEN TO EDIT-NUM-1
                 STRING ' LSTN CID-DATA-LEN=' DELIMITED SIZE
                        EDIT-NUM-1            DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE ZERO TO BTN-NUMBER
                 MOVE CID-VERSION TO BTN-BYTE
                 MOVE BTN-NUMBER TO EDIT-NUM-1
                 STRING ' LSTN CID-VERSION=' DELIMITED SIZE
                        EDIT-NUM-1           DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE ZERO TO BTN-NUMBER
                 MOVE CID-FLAGS TO BTN-BYTES
                 MOVE BTN-NUMBER TO EDIT-NUM-1
                 STRING ' LSTN CID-FLAGS=' DELIMITED SIZE
                        EDIT-NUM-1         DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 STRING ' LSTN LISTENER TYPE=' DELIMITED SIZE
                        LISTENER-TYPE          DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE SIN-FAMILY TO EDIT-NUM-3
                 STRING ' LSTN SIN-FAMILY=' DELIMITED SIZE
                        EDIT-NUM-3          DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE SIN-PORT TO EDIT-NUM-3
                 STRING ' LSTN SIN-PORT=' DELIMITED SIZE
                        EDIT-NUM-3        DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE SIN-ADDR TO EDIT-NUM-4
                 STRING ' LSTN SIN-ADDR=' DELIMITED SIZE
                        EDIT-NUM-4        DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE PERSISTENCE-TYPE TO EDIT-NUM-4
                 STRING ' PC TYPE=' DELIMITED SIZE
                        EDIT-NUM-4        DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

                 MOVE SPACES TO LOG-MSG-BUFFER
                 MOVE USE-TICS-WORKAREA TO EDIT-NUM-4
                 STRING ' TICS WORK AREA=' DELIMITED SIZE
                        EDIT-NUM-4        DELIMITED SIZE
                        INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

              WHEN OTHER
                 MOVE TRACE-ID TO EDIT-NUM-3
                 STRING ' UNKNOWN TRACE-ID VALUE OF: ' DELIMITED SIZE
                    EDIT-NUM-3 DELIMITED SIZE
                    INTO LOG-MSG-BUFFER
                 END-STRING
                 PERFORM WRITE-LOG-MSG

           END-EVALUATE.

       TRACE-POINTS-EXIT.
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

      *****************************************************************
      ** ERROR HANDLING ROUTINES                                      *
      *****************************************************************
       INVREQ-ERR-SEC.
           MOVE ' CICS COMMAND RETURNED ''INVREQ''' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG.
           MOVE CS-ERROR-CICS-INVREQ TO CHILD-SERVER-ERROR.
           PERFORM CLOSE-THE-SOCKET THRU CLOSE-THE-SOCKET-EXIT.
           GO TO EXIT-THE-PROGRAM.

       IOERR-SEC.
           MOVE ' CICS COMMAND RETURNED ''IOREQ''' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG.
           MOVE CS-ERROR-CICS-IOREQ TO CHILD-SERVER-ERROR.
           PERFORM CLOSE-THE-SOCKET THRU CLOSE-THE-SOCKET-EXIT.
           GO TO EXIT-THE-PROGRAM.

       LENGERR-SEC.
           MOVE ' CICS COMMAND RETURNED ''LENGERR''' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG.
           MOVE CS-ERROR-CICS-LENGERR TO CHILD-SERVER-ERROR.
           PERFORM CLOSE-THE-SOCKET THRU CLOSE-THE-SOCKET-EXIT.
           GO TO EXIT-THE-PROGRAM.

       ENDDATA-SEC.
           MOVE ' CICS COMMAND RETURNED ''ENDDATA''' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG.
           MOVE CS-ERROR-CICS-ENDDATA TO CHILD-SERVER-ERROR.
           PERFORM CLOSE-THE-SOCKET THRU CLOSE-THE-SOCKET-EXIT.
           GO TO EXIT-THE-PROGRAM.

      *****************************************************************
      ** EXIT PGM                                                     *
      *****************************************************************
       EXIT-THE-PROGRAM.
           MOVE SPACES TO LOG-MSG-BUFFER.
           MOVE 'END OF CONCURRENT SERVER' TO LOG-MSG-BUFFER.
           PERFORM WRITE-LOG-MSG.
           EXEC CICS RETURN END-EXEC.
           GOBACK.
