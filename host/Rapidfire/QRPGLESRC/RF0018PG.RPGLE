**FREE

//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* Copyright (c) 2016 Task Force IT-Consulting GmbH, Waltrop (Germany)                     *
//* This software and the accompanying materials are made available                         *
//* under the terms of the GNU General Public License version 2.0 (GPLv2)                   *
//* which accompanies this distribution and is available at                                 *
//* http://www.gnu.org/licenses/gpl-2.0.html                                                *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* Generate Copy Program                                                                   *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* (01 - 49) Freie Bezugszahlen f�r sonstige Dinge                                         *
//*                                                                                         *
//* 01      --> Modus : 'Erstellen'                                                         *
//* 02      --> Modus : '�ndern'                                                            *
//* 03      --> Modus : 'Kopieren'                                                          *
//* 04      --> Modus : 'L�schen'                                                           *
//* 05      --> Modus : 'Anzeigen'                                                          *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* (50 - 59) Reservierte Bezugszahlen f�r Diverses                                         *
//*                                                                                         *
//* 50      --> Schl�sselwort SFLEND in Nachrichtensubdatei aktivieren                      *
//* 51      --> Ergebnis f�r LookUp Operation                                               *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* (60 - 79) Reservierte Bezugszahlen f�r Subdateiverarbeitung                             *
//*                                                                                         *
//* 60,64,68,72,76  --> (Subdatei 1 - 5) Inhalt der Subdatei l�schen                        *
//* 61,65,69,73,77  --> (Subdatei 1 - 5) Keine S�tze in der Subdatei vorhanden              *
//* 62,66,70,74,78  --> (Subdatei 1 - 5) Letzter Satz befindet sich bereits in der Subdatei *
//* 63,67,71,75,79  --> (Subdatei 1 - 5) Subdateisatz ist ein ge�nderter Satz               *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* (80 - 89) Reservierte Bezugszahlen f�r Fehlermeldungen                                  *
//*                                                                                         *
//* 80      --> Es liegt ein Fehler vor (Spezifikation durch BZ 81 - 89)                    *
//* 81 - 83 --> (Block 1) Fehlermeldungen                                                   *
//* 84 - 86 --> (Block 2) Fehlermeldungen                                                   *
//* 87 - 89 --> (Block 3) Fehlermeldungen                                                   *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* (90 - 99) Reservierte Bezugszahlen f�r Cursorpositionierung                             *
//*                                                                                         *
//* 90      --> Es soll positioniert werden (Spezifikation durch 91 - 99)                   *
//* 91      --> Der Cursor soll auf Koordinate Zeile / Spalte positioniert werden           *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* �bergabeparameter                                                                       *
//* =================                                                                       *
//*                                                                                         *
//* PIMode     / *CREATE    --> Modus : 'Erstellen'                                         *
//*                                                                                         *
//* PIRtCd     / *F3        --> Der Benutzer hat die Taste F3 gedr�ckt                      *
//*              *F12       --> Der Benutzer hat die Taste F12 gedr�ckt                     *
//*              *ENTER     --> Der Benutzer hat die Taste ENTER gedr�ckt                   *
//*                                                                                         *
//* Aufruf von der Befehlszeile                                                             *
//* ===========================                                                             *
//*                                                                                         *
//* CALL PGM(RF0018PG) PARM('*CREATE' 'DIV6.B' X'0000001F' 'DIV6' '')                       *
//*                                                                                         *
//*------------+--------+-------------------------------------------------------------------*
//*   Datum    I Progr. I Beschreibung                                                      *
//*------------+--------+-------------------------------------------------------------------*
//* 24.03.2016 I   FH   I Programm erstellt                                                 *
//*------------+--------+-------------------------------------------------------------------*
//* 14.07.2016 I   TR   I Opened fields 'Library' and 'Shadow library' to let the user      *
//*            I        I specify the data and shadow libraries, when either of them does   *
//*            I        I does not yet exist, as specified by the area.                     *
//*------------+--------+-------------------------------------------------------------------*
//* >>PRE-COMPILER<<                                                                        *
//*   >>CRTCMD<< CRTBNDRPG PGM(&LI/&OB) SRCFILE(&SL/&SF) SRCMBR(&SM);                       *
//*   >>IMPORTANT<<                                                                         *
//*     >>PARM<< DFTACTGRP(*NO);                                                            *
//*     >>PARM<< DBGVIEW(&U1);                                                              *
//*     >>PARM<< ACTGRP(&U2);                                                               *
//*     >>PARM<< TGTRLS(&TR);                                                               *
//*     >>PARM<< OPTION(*EVENTF);                                                           *
//*   >>END-IMPORTANT<<                                                                     *
//*   >>EXECUTE<<                                                                           *
//* >>END-PRE-COMPILER<<                                                                    *
//*-----------------------------------------------------------------------------------------*

// Control

CTL-OPT DatFmt(*ISO) TimFmt(*ISO) DecEdit('0,');
CTL-OPT DftActGrp(*NO) ActGrp('RAPIDFIRE') BNDDIR('RAPIDFIRE');
CTL-OPT Copyright('(C) Copyright Task Force IT-Consulting GmbH');
CTL-OPT ExtBinInt(*YES);

//*-----------------------------------------------------------------------------------------*

DCL-F RF0018DF Workstn(*EXT) USAGE(*INPUT:*OUTPUT)
      InfDS(FIDS_RF0018DF);
DCL-F FILES Disk(*EXT) USAGE(*INPUT) KEYED Rename(FILES : FILESF);
DCL-F AREAS Disk(*EXT) USAGE(*INPUT) KEYED Rename(AREAS : AREARF);
DCL-F LIBRARIES Disk(*EXT) USAGE(*INPUT)
      KEYED Rename(LIBRARIES : LIBRARYF);

//*-----------------------------------------------------------------------------------------*

// Prozedurenprototyp f�r Prozedur 'RF0018PG'

/Copy QCPYSRC,RF0018PG

// Prozedurenschnittstelle f�r Prozedur 'RF0008PG'

DCL-PI RF0018PG;
  PIMode CHAR(10) Const;                                                 // --> Modus
  PIJOB CHAR(10) Const;                                                  // --> Job
  PIPOS PACKED(6) Const;                                                 // --> Position
  PIRtCd CHAR(10);                                                       // <-- R�ckkehrcode
END-PI;

//*-----------------------------------------------------------------------------------------*

// Prozedurenprototyp f�r Prozedur 'RtvFktKey'

/Copy QCPYSRC,RTVFKTKEY

// Prozedurenprototyp f�r Prozedur 'RmvErrMsg'

/Copy QCPYSRC,RMVERRMSG

// Prozedurenprototyp f�r Prozedur 'SndErrMsg'

/Copy QCPYSRC,SNDERRMSG

// Prozedurenprototyp f�r Prozedur 'HdlRcdLck'

/Copy QCPYSRC,HDLRCDLCK

// Prozedurenprototyp f�r Prozedur 'QUHDSPH'

/Copy QCPYSRC,QUHDSPH

// Prozedurenprototyp f�r Prozedur 'ChkVal'

/Copy QCPYSRC,CHKVAL

// Prozedurenprototyp f�r Prozeduren 'ChkObj'

/Copy QCPYSRC,CHKOBJ

// Prozedurenprototyp f�r Prozeduren 'Promoter'

/Copy QCPYSRC,PROMOTER

// Konstanten f�r Rapid Fire Jobs

/Copy QCPYSRC,RAPIDFIRE

// Prozedurenprototyp f�r Prozedur 'RF0016PG'

/Copy QCPYSRC,RF0016PG

// Datenstruktur f�r Format 'ERRC0100' f�r Fehlercode

/Copy QCPYSRC,ERRC0100

// Programmstatusdatenstruktur

DCL-DS PSDS LEN(429) PSDS;
END-DS;

// Dateiinformationsdatenstruktur f�r RF0008DF

DCL-DS FIDS_RF0018DF;
  AIDCde CHAR(1) POS(369);
END-DS;

// Hilfe-Id.

DCL-DS *N;
  ITHlpId CHAR(52) Dim(100);                                             // Hilfe-Id.
  ITHIPG CHAR(10) Overlay(ITHlpId : 1);                                  // Panelgroup
  ITHILP CHAR(10) Overlay(ITHlpId : 11);                                 // Bibliothek Panelg
  ITHIMO CHAR(32) Overlay(ITHlpId : 21);                                 // Modul
END-DS;

// Sonstige Felddeklarationen

DCL-S ITLoop IND Inz(*On);                                               // Schleife
DCL-S ITFktKey CHAR(10);                                                 // Funktionstaste
DCL-S ITSts CHAR(10);                                                    // Nachrichten-Id. b
DCL-S ITMsgId CHAR(7);                                                   // Nachrichten-Id.
DCL-S ITDsp INT(10) Dim(2);                                              // Anzeige Hilfetext
DCL-S ITNbr INT(10);                                                     // Anzahl Hilfetextm
DCL-S ITLftC INT(10) Dim(2);                                             // Linke Ecke
DCL-S ITRghC INT(10) Dim(2);                                             // Rechte Ecke
DCL-S ITCsrL INT(10) Dim(2);                                             // Cursorposition
DCL-S ITHlp CHAR(1);                                                     // Kontextbezogene H
DCL-S ITAra CHAR(10);                                                    // Prompt: Area

DCL-DS g_qSrcMbr likeds(qMbr_t) inz;
DCL-S DO_X PACKED(7);

//*-----------------------------------------------------------------------------------------*

// Bezugszahl f�r 'Schl�sselwort SFLEND in Nachrichtensubdatei aktivieren' auf 'Ja' setzen
*IN50 = *On;
// Datensatz lesen
Chain ( PIJOB : PIPOS ) FILESF;
// Fehler : Der Datensatz konnte nicht gefunden werden
If Not (%Found);
  PIRtCd = '*ERROR';
Else;
  // Job initialisieren
  DFJOB = PIJOB;
  DFPOS = PIPOS;
  DFFILE = X3FILE;
  Select;
    // Modus : 'Erstellen'
  When PIMode = '*CREATE';
    ExSr SR005;
  EndSl;
EndIf;
// Programm nicht hauptspeicherresident verlassen
*INLR = *On;

//-----------------------------------------------------------------------
// Erstellen
//-----------------------------------------------------------------------

BegSr SR005;
  // �berschrift f�r Modus 'Erstellen' anzeigen
  *IN(1) = *ON;
  *IN(2) = *OFF;
  *IN(3) = *OFF;
  *IN(4) = *OFF;
  *IN(5) = *OFF;
  // Bildschirm mit Standartwerten f�llen
  ExSr SR030;
  // Bildschirm verarbeiten
  ExSr SR045;
EndSr;

//-------------------------------------------------------------------------------------------
// Bildschirm mit Standartwerten f�llen
//-------------------------------------------------------------------------------------------

BegSr SR030;
  DFSRCF = *Blanks;
  DFSRCL = *Blanks;
  DFSRCM = *Blanks;
  DFREP  = '*NO';
  DFARA  = *Blanks;
  DFLIB  = *Blanks;
  DFSLIB = *Blanks;
  DFVP = '*NONE';
  DFVPL = *Blanks;
EndSr;

//-------------------------------------------------------------------------------------------
// Bildschirm verarbeiten
//-------------------------------------------------------------------------------------------

BegSr SR045;
  // Fehlernachricht entfernen
  ITSts = RmvErrMsg('*SAME');
  // Fehlernachrichten-Id. initialisieren
  ITMsgId = *Blanks;
  // Fehlerbezugszahlen initialisieren
  *IN(80) = *OFF;
  *IN(81) = *OFF;
  *IN(82) = *OFF;
  *IN(83) = *OFF;
  *IN(84) = *OFF;
  *IN(85) = *OFF;
  *IN(86) = *OFF;
  *IN(87) = *OFF;
  *IN(88) = *OFF;
  *IN(89) = *OFF;
  // Positionierung deaktivieren
  *IN(90) = *OFF;
  *IN(91) = *OFF;
  *IN(92) = *OFF;
  *IN(93) = *OFF;
  *IN(94) = *OFF;
  *IN(95) = *OFF;
  *IN(96) = *OFF;
  *IN(97) = *OFF;
  *IN(98) = *OFF;
  *IN(99) = *OFF;
  DoW ITLoop;
    // Fehlernachricht in die Programmnachrichtenwarteschlange schreiben
    If ITMsgId <> *Blanks;
      ExSr SR055;
    EndIf;
    DoU ITFktKey <> '*F1';
      // Satzformate auf den Bildschirm ausgeben
      DFPGMQ = '*';
      Write DSPF999C;
      ExFmt DSPF010;
      // Funktionstaste abrufen
      ITFktKey = RtvFktKey(AIDCde);
      // Funktionstaste : 'F1=Hilfe'
      If ITFktKey = '*F1';
        ExSr SR060;
      EndIf;
    EndDo;
    // Fehlernachricht entfernen
    ITSts = RmvErrMsg('*SAME');
    // Fehlernachrichten-Id. initialisieren
    ITMsgId = *Blanks;
    // Fehlerbezugszahlen initialisieren
    *IN(80) = *OFF;
    *IN(81) = *OFF;
    *IN(82) = *OFF;
    *IN(83) = *OFF;
    *IN(84) = *OFF;
    *IN(85) = *OFF;
    *IN(86) = *OFF;
    *IN(87) = *OFF;
    *IN(88) = *OFF;
    *IN(89) = *OFF;
    // Positionierung deaktivieren
    *IN(90) = *OFF;
    *IN(91) = *OFF;
    *IN(92) = *OFF;
    *IN(93) = *OFF;
    *IN(94) = *OFF;
    *IN(95) = *OFF;
    *IN(96) = *OFF;
    *IN(97) = *OFF;
    *IN(98) = *OFF;
    *IN(99) = *OFF;
    // Funktionstaste : 'F3=Verlassen'
    If ITFktKey = '*F3';
      PIRtCd = '*F3';
      Leave;
    EndIf;
    // Funktionstaste : 'F12=Abbrechen'
    If ITFktKey = '*F12';
      PIRtCd = '*F12';
      Leave;
    EndIf;
    // Funktionstaste : 'F4=Bedienerf�hrung'
    If ITFktKey = '*F4';
      ExSr SR065;
      If PIRtCd = '*F3';
        Leave;
      Else;
        Iter;
      EndIf;
    EndIf;
    // Funktionstaste : 'Enter'
    If ITFktKey = '*ENTER';
      // Bildschirmfelder auf Fehler �berpr�fen
      ExSr SR050;
      If ITMsgId <> *Blanks;
        Iter;
      EndIf;
      // R�ckkehrcode setzen
      DFPGMQ = '*';
      Write DSPF999C;
      Write DSPF010;
      ExSr SR070;
      If PIRtCd = '*F10';
        PIRtCd = '*F12';
        Leave;
      EndIf;
    EndIf;
  EndDo;
EndSr;

//-------------------------------------------------------------------------------------------
// Bildschirmfelder auf Fehler �berpr�fen
//-------------------------------------------------------------------------------------------

BegSr SR050;
  // Namensfelder linksb�ndig ausrichten
  If PIMode = '*CREATE';
    DFSRCF = %TRIML(DFSRCF);
    DFSRCL = %TRIML(DFSRCL);
    DFSRCM = %TRIML(DFSRCM);
  EndIf;
  FOR DO_X = 1 TO 1;
    // *** Fehlerpr�fung nur f�r Modus 'Erstellen'
    If PIMode = '*CREATE';
      // The value in field 'Source File' is not valid.
      If ChkVal('*NAME' : 10 : %Addr(DFSRCF)) =
        '*INVALID';
        ITMsgId = 'ERR0001';
        *IN(87) = *ON;
        *IN(88) = *OFF;
        *IN(89) = *OFF;
        Leave;
      EndIf;
      // The value in field 'Library' is not valid.
      If ChkVal('*NAME' : 10 : %Addr(DFSRCL)) =
        '*INVALID';
        ITMsgId = 'ERR0002';
        *IN(87) = *OFF;
        *IN(88) = *ON;
        *IN(89) = *OFF;
        Leave;
      EndIf;
      // The value in field 'Source member' is not valid.
      If ChkVal('*NAME' : 10 : %Addr(DFSRCM)) =
        '*INVALID';
        ITMsgId = 'ERR0003';
        *IN(87) = *ON;
        *IN(88) = *ON;
        *IN(89) = *OFF;
        Leave;
      EndIf;
      // Library does not exist.
      If not Library_exist (DFSRCL);
        ITMsgId = 'ERR0004';
        *IN(87) = *OFF;
        *IN(88) = *ON;
        *IN(89) = *OFF;
        Leave;
      EndIf;
      // File does not exist.
      If not File_exist (DFSRCF: DFSRCL);
        ITMsgId = 'ERR0005';
        *IN(87) = *ON;
        *IN(88) = *OFF;
        *IN(89) = *OFF;
        Leave;
      EndIf;
      // File is not a source file.
      If not File_isSourceFile(DFSRCF: DFSRCL);
        ITMsgId = 'ERR0006';
        *IN(87) = *ON;
        *IN(88) = *OFF;
        *IN(89) = *OFF;
        Leave;
      EndIf;
      // The value in field 'Replace' is not valid.
      If DFREP <> '*YES' And DFREP <> '*NO';
        ITMsgId = 'ERR0014';
        *IN(87) = *ON;
        *IN(88) = *ON;
        *IN(89) = *ON;
        Leave;
      EndIf;
      // Member already exists.
      If DFREP <> '*YES' And
        Member_exist (DFSRCF: DFSRCL: DFSRCM);
        ITMsgId = 'ERR0007';
        *IN(87) = *ON;
        *IN(88) = *ON;
        *IN(89) = *OFF;
        Leave;
      EndIf;
      // Specify 'Area' or 'Library' and 'Shadow library'
      If DFARA = '' And DFLIB = '' And DFSLIB = '';
        ITMsgId = 'ERR0017';
        *IN(87) = *OFF;                                                  // Area
        *IN(88) = *OFF;                                                  // Area
        *IN(89) = *ON;                                                   // Area
        *IN(84) = *ON;                                                   // Library
        *IN(85) = *OFF;                                                  // Library
        *IN(86) = *OFF;                                                  // Library
        Leave;
      EndIf;
      // Area not found.
      If DFARA <> '*NONE' And DFARA <> '' And
        ChkVal('*NAME' : 10 : %Addr(DFARA)) =
        '*INVALID';
        ITMsgId = 'ERR0008';
        *IN(87) = *OFF;
        *IN(88) = *OFF;
        *IN(89) = *ON;
        Leave;
      EndIf;
      // Pr�fen Area ...
      If DFARA <> '';
        Setll ( DFJOB : DFPOS : DFARA ) AREARF;
        If not %equal(AREAS);
          ITMsgId = 'ERR0009';
          *IN(87) = *OFF;
          *IN(88) = *OFF;
          *IN(89) = *ON;
          Leave;
        EndIf;
        // Vorbelegen der Bibliotheken ...
        ExSr SR075;
        If ITMsgId <> '';
          Leave;
        EndIf;
      Endif;
      // Pr�fen der Datenbibliothek mit der 'von' Datei ...
      If not Library_exist (DFLIB);
        ITMsgId = 'ERR0018';
        *IN(84) = *ON;                                                   // 'From' Library
        *IN(85) = *OFF;                                                  // 'From' Library
        *IN(86) = *OFF;                                                  // 'From' Library
        Leave;
      EndIf;
      // Pr�fen 'von' Datei ...
      If not File_exist (DFFILE: DFLIB);
        ITMsgId = 'ERR0020';
        *IN(84) = *ON;                                                   // 'From' Library
        *IN(85) = *OFF;                                                  // 'From' Library
        *IN(86) = *OFF;                                                  // 'From' Library
        Leave;
      EndIf;
      // Pr�fen der Schattenbibliothek mit der 'nach' Datei ...
      If not Library_exist (DFSLIB);
        ITMsgId = 'ERR0019';
        *IN(84) = *OFF;                                                  // 'To' Library
        *IN(85) = *ON;                                                   // 'To' Library
        *IN(86) = *OFF;                                                  // 'To' Library
        Leave;                                                           // (Shadow library)
      EndIf;
      // Pr�fen 'nach' Datei ...
      If not File_exist (DFFILE: DFSLIB);
        ITMsgId = 'ERR0021';
        *IN(84) = *OFF;                                                  // 'To' Library
        *IN(85) = *ON;                                                   // 'To' Library
        *IN(86) = *OFF;                                                  // 'To' Library
        Leave;                                                           // (Shadow library)
      EndIf;
      // The value in field 'Conversion program' is not valid.
      If DFVP <> '*NONE' And
        ChkVal('*NAME' : 10 : %Addr(DFVP)) =
        '*INVALID';
        ITMsgId = 'ERR0011';
        *IN(87) = *ON;
        *IN(88) = *OFF;
        *IN(89) = *ON;
        Leave;
      EndIf;
      // The value in field 'Library' is not valid.
      If DFVP = '*NONE';
        If DFVPL <> '';
          ITMsgId = 'ERR0013';
          *IN(87) = *OFF;
          *IN(88) = *ON;
          *IN(89) = *ON;
          Leave;
        EndIf;
      Else;
        If ChkVal('*NAME' : 10 : %Addr(DFVPL)) =
          '*INVALID';
          ITMsgId = 'ERR0012';
          *IN(87) = *OFF;
          *IN(88) = *ON;
          *IN(89) = *ON;
          Leave;
        EndIf;
      EndIf;

    EndIf;
  ENDFOR;
EndSr;

//-------------------------------------------------------------------------------------------
// Fehlernachricht in die Programmnachrichtenwarteschlange schreiben
//-------------------------------------------------------------------------------------------

BegSr SR055;
  // Bezugszahl f�r 'Es liegt ein Fehler vor' auf 'Ja' setzen
  *IN80 = *On;
  // Fehlernachricht in die Programmnachrichtenwarteschlange schreiben
  ITSts = SndErrMsg(
   '*SAME' :                                                             // --> Aufrufstapele
   ITMsgId :                                                             // --> Nachrichten-I
   'RF0018MF' :                                                          // --> Nachrichtenda
   '*LIBL' :                                                             // --> Bibliothek Na
   *Blanks                                                               // --> Nachrichtenda
  );
EndSr;

//-------------------------------------------------------------------------------------------
// Hilfe
//-------------------------------------------------------------------------------------------

BegSr SR060;
  // Kontextbezogene Hilfe initialisiern
  ITHlp = 'N';
  // Nummer Hilfetextmodul initialisieren
  ITNbr = *Zero;
  // Hilfe f�r Fehlernachrichtensubdatei angefordert
  If DFRCD010 = 'DSPF999S';
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'CMOREFGP';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'REF/MSGINF';
    ITHlp = 'J';
    ITDsp(1) = ITNbr;
    ITDsp(2) = ITNbr;
  Else;
    // Modul 'GNR'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'CPYPGM';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'GNR';
    // Modul 'JOB'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'JOBS';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'JOB';
    If DFFLD010 = 'DFJOB';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'POS'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'FILES';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'POS';
    If DFFLD010 = 'DFPOS';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'FILE'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'FILES';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'FILE';
    If DFFLD010 = 'DFFILE';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'CPYPGM'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'CPYPGM';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'SRCFILE';
    If DFFLD010 = 'DFSRCF';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'CPYPGM'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'CPYPGM';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'SRCLIB';
    If DFFLD010 = 'DFSRCL';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'CPYPGM'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'CPYPGM';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'SRCMBR';
    If DFFLD010 = 'DFSRCM';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'CPYPGM'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'CPYPGM';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'REPLACE';
    If DFFLD010 = 'DFREP';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'AREAS'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'AREAS';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'ARA';
    If DFFLD010 = 'DFARA';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'LIBRARIES'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'LIBRARIES';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'LIB';
    If DFFLD010 = 'DFLIB';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'LIBRARIES'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'LIBRARIES';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'SLIB';
    If DFFLD010 = 'DFSLIB';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'FILES'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'FILES';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'VP';
    If DFFLD010 = 'DFVP';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'FILES'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'FILES';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'VPL';
    If DFFLD010 = 'DFVPL';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'FKT'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'RF0018GP';
    ITHILP(ITNbr) = '*LIBL';
    Select;
    When PIMode = '*CREATE' Or
      PIMode = '*COPY' Or
      PIMode = '*CHANGE';
      ITHIMO(ITNbr) = 'FKT/EDT';
    When PIMode = '*DISPLAY' Or
      PIMode = '*DELETE';
      ITHIMO(ITNbr) = 'FKT/DSP';
    EndSl;
    If DFROW010 >= 23 And
      DFROW010 <= 23 And
      DFCOL010 >= 2 And
      DFCOL010 <= 79;
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
  EndIf;
  // Keine kontextbezogene Hilfe ausgew�hlt
  If ITHlp = 'N';
    ITDsp(1) = 1;
    ITDsp(2) = ITNbr;
  EndIf;
  // Hilfetext anzeigen
  ITLftC(1) = 1;
  ITLftC(2) = 1;
  ITRghC(1) = 24;
  ITRghC(2) = 80;
  ITCsrL(1) = DFROW010;
  ITCsrL(2) = DFCOL010;
  Reset ERRC0100;
  QUHDSPH(
   ITHlpId :                                                             // --> Help identifi
   ITNbr :                                                               // --> Number of hel
   ITDsp :                                                               // --> Help type
   *Blanks :                                                             // --> Full display
   '*NONE' :                                                             // --> Qualified sea
   'N' :                                                                 // --> Display type
   ITLftC :                                                              // --> Upper left co
   ITRghC :                                                              // --> Lower right c
   ITCsrL :                                                              // --> Cursor locati
   ERRC0100                                                              // <-> Error code
  );
  // Cursor auf der letzten Position positionieren
  *IN(90) = *ON;
  *IN(91) = *ON;
  *IN(92) = *OFF;
  *IN(93) = *OFF;
  *IN(94) = *OFF;
  *IN(95) = *OFF;
  *IN(96) = *OFF;
  *IN(97) = *OFF;
  *IN(98) = *OFF;
  *IN(99) = *OFF;
EndSr;

//-------------------------------------------------------------------------------------------
// Bedienerf�hrung
//-------------------------------------------------------------------------------------------

BegSr SR065;
  Select;
    // Bedienerf�hrung f�r das Feld 'Area'
  When DFFLD010 = 'DFARA';
    RF0016PG(
     '*SELECT' :                                                         // --> Modus
     PIJOB :                                                             // --> Job
     PIPOS :                                                             // --> Position
     ITARA :                                                             // <-> Area
     PIRtCd                                                              // <-- R�ckkehrcode
    );
    If PIRtCd = '*SELECT';
      DFARA = ITARA;
      ExSr SR075;
    EndIf;
    // No prompt for the requested field available
  Other;
    ITMsgId = 'ERR0015';
  EndSl;
  // Cursor auf der letzten Position positionieren
  *IN(90) = *ON;
  *IN(91) = *ON;
  *IN(92) = *OFF;
  *IN(93) = *OFF;
  *IN(94) = *OFF;
  *IN(95) = *OFF;
  *IN(96) = *OFF;
  *IN(97) = *OFF;
  *IN(98) = *OFF;
  *IN(99) = *OFF;
EndSr;

//-------------------------------------------------------------------------------------------
// Generieren Kopierprogramm
//-------------------------------------------------------------------------------------------

BegSr SR070;

  ITLoop = *ON;

  DoW ITLoop;
    // Satzformate auf den Bildschirm ausgeben
    ExFmt DSPF020W;
    // Funktionstaste abrufen
    ITFktKey = RtvFktKey(AIDCde);
    // Funktionstaste : 'F10=Job starten'
    If ITFktKey = '*F10';
      PIRtCd = '*F10';
      Leave;
    EndIf;
    // Funktionstaste : 'F12=Abbrechen'
    If ITFktKey = '*F12';
      PIRtCd = '*F12';
      Leave;
    EndIf;
  EndDo;
  // Job starten
  If PIRtCd = '*F10';
    RAPIDFIRE_set_Error(
    RAPIDFIRE_JOB_NONE :
    *OFF
    );
    g_qSrcMbr.file = DFSRCF;                                             // Source file
    g_qSrcMbr.lib = DFSRCL;                                              // Library
    g_qSrcMbr.name = DFSRCM;                                             // Member
    PROMOTER_generate_Copy_Program(
      DFJOB: DFPOS: DFARA:
      DFLIB: DFSLIB: DFFILE:
      DFVPL: DFVP: *ON: g_qSrcMbr);
    If RAPIDFIRE_is_Error(RAPIDFIRE_JOB_NONE);
      Exfmt DSPF030W;
    EndIf;
  EndIf;

EndSr;

//-------------------------------------------------------------------------------------------
// Einlesen und belegen der Felder 'Library' und 'Shadow library'.
//-------------------------------------------------------------------------------------------

BegSr SR075;
  DFLIB = '';
  DFSLIB = '';
  Chain ( DFJOB : DFPOS : DFARA ) AREARF;
  If %found(AREAS);
    Chain ( XDJOB : XDLIB ) LIBRARYF;
    If %found(LIBRARIES);
      DFLIB = X2LIB;
      DFSLIB = X2SLIB;
    Else;
      ITMsgId = 'ERR0010';
      *IN(87) = *OFF;
      *IN(88) = *OFF;
      *IN(89) = *ON;
    EndIf;
  EndIf;
EndSr;