             PGM        PARM(&LIB)
/*                                                                   */
/* Declare variables                                                 */
/*                                                                   */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/*                                                                   */
/* Create woodgrove back library                                     */
/*                                                                   */
             CRTLIB     LIB(&LIB)
             MONMSG     MSGID(CPF2111)
             ADDLIBLE   LIB(&LIB) POSITION(*FIRST)
             MONMSG     MSGID(CPF2103)
/*                                                                   */
/* Create physical files.                                            */
/*                                                                   */
             CRTPF      FILE(&LIB/ACTMAS) SRCFILE(&LIB/QDDSSRC) +
                          SIZE(*NOMAX) AUT(*ALL)

             CRTPF      FILE(&LIB/CUSMAS) SRCFILE(&LIB/QDDSSRC) +
                          SIZE(*NOMAX) AUT(*ALL)

             CRTPF      FILE(&LIB/TRNDTL) SRCFILE(&LIB/QDDSSRC) +
                          SIZE(*NOMAX) AUT(*ALL)
/*                                                                   */
/* Create logical files.                                             */
/*                                                                   */
             CRTLF      FILE(&LIB/CUSMASL1) SRCFILE(&LIB/QDDSSRC) +
                          DTAMBRS((&LIB/CUSMAS (CUSMAS)))

             CRTLF      FILE(&LIB/ACTMASL1) SRCFILE(&LIB/QDDSSRC) +
                          DTAMBRS((&LIB/ACTMAS (ACTMAS)))

             CRTLF      FILE(&LIB/ACTMASL2) SRCFILE(&LIB/QDDSSRC) +
                          DTAMBRS((&LIB/ACTMAS (ACTMAS)))

             CRTLF      FILE(&LIB/ACTMASL3) SRCFILE(&LIB/QDDSSRC) +
                          DTAMBRS((&LIB/ACTMAS (ACTMAS)))

             CRTLF      FILE(&LIB/TRNDTLL1) SRCFILE(&LIB/QDDSSRC) +
                          DTAMBRS((&LIB/TRNDTL (TRNDTL)))
/*                                                                   */
/* Create display files.                                             */
/*                                                                   */
             CRTDSPF    FILE(&LIB/DSPGETSTMT) SRCFILE(&LIB/QDDSSRC)
             CRTDSPF    FILE(&LIB/SGETACCTS) SRCFILE(&LIB/QDDSSRC)
             CRTDSPF    FILE(&LIB/WBAPPSCR) SRCFILE(&LIB/QDDSSRC)             
/*                                                                   */
/* Create RPG Programs.                                              */
/*                                                                   */

             CRTBNDRPG  PGM(&LIB/LOADACCTS) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/LOADCUSTS) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/LOADTRANS) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WBAPPL) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WTIADDA) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WTIADDC) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WTIGACC) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WTIGBAL) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WTIGCUSI) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WTIGSTMT) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)

             CRTBNDRPG  PGM(&LIB/WTISCUSI) +
                          SRCFILE(&LIB/QRPGLESRC) AUT(*ALL)
/*                                                                   */
/* Create CL  Programs.                                              */
/*                                                                   */
             CRTCLPGM   PGM(&LIB/RELOADENV1) 
                          SRCFILE(&LIB/QCLSRC) AUT(*ALL)

             CRTCLPGM   PGM(&LIB/WDDEFDATA) 
                          SRCFILE(&LIB/QCLSRC) AUT(*ALL)
/*                                                                   */
/* Create menu.                                                      */
/*                                                                   */
             CRTMNU     MENU(&LIB/WOODGRVE) TYPE(*UIM) +
                       SRCFILE(&LIB/QMNUSRC) REPLACE(*YES) AUT(*ALL)  
/*                                                                   */
/* Populate data files.                                              */
/*                                                                   */
             CALL       PGM(&LIB/RELOADENV1) PARM(&LIB)

             ENDPGM
