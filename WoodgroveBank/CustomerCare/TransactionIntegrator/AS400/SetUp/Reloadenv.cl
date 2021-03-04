             PGM        PARM(&LIB)

             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)

             OVRDBF     FILE(CUSMAS) TOFILE(&LIB/CUSMAS)
             OVRDBF     FILE(CUSMASL1) TOFILE(&LIB/CUSMASL1)

             OVRDBF     FILE(ACTMAS) TOFILE(&LIB/ACTMAS)
             OVRDBF     FILE(ACTMASL1) TOFILE(&LIB/ACTMASL1)
             OVRDBF     FILE(ACTMASL2) TOFILE(&LIB/ACTMASL2)
             OVRDBF     FILE(ACTMASL3) TOFILE(&LIB/ACTMASL3)

             OVRDBF     FILE(TRNDTL) TOFILE(&LIB/TRNDTL)
             OVRDBF     FILE(TRNDTL) TOFILE(&LIB/TRNDTLL1)

             CLRPFM     FILE(&LIB/CUSMAS)
             CLRPFM     FILE(&LIB/ACTMAS)
             CLRPFM     FILE(&LIB/TRNDTL)

             CALL       PGM(&LIB/LOADCUSTS)

             CALL       PGM(&LIB/LOADACCTS)

             CALL       PGM(&LIB/LOADTRANS)

             ENDPGM
