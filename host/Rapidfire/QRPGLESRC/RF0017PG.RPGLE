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
//* Maintain Area                                                                           *
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
//* 92      --> Der Cursor soll auf das Feld 'Befehl' positioniert werden                   *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* �bergabeparameter                                                                       *
//* =================                                                                       *
//*                                                                                         *
//* PIMode     / *CREATE  --> Modus : 'Erstellen'                                           *
//*              *CHANGE  --> Modus : '�ndern'                                              *
//*              *COPY    --> Modus : 'Kopieren'                                            *
//*              *DELETE  --> Modus : 'L�schen'                                             *
//*              *DISPLAY --> Modus : 'Anzeigen'                                            *
//*                                                                                         *
//* PIRtCd     / *F3      --> Der Benutzer hat die Taste F3 gedr�ckt                        *
//*              *F12     --> Der Benutzer hat die Taste F12 gedr�ckt                       *
//*              *ENTER   --> Der Benutzer hat die Taste ENTER gedr�ckt                     *
//*                                                                                         *
//*------------+--------+-------------------------------------------------------------------*
//*   Datum    I Progr. I Beschreibung                                                      *
//*------------+--------+-------------------------------------------------------------------*
//* 15.10.2015 I   FH   I Programm erstellt                                                 *
//*------------+--------+-------------------------------------------------------------------*
//* 13.06.2016 I   TR   I Enabled program for '*DISPLAY' mode.                              *
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

DCL-F RF0017DF Workstn(*EXT) USAGE(*INPUT:*OUTPUT)
      InfDS(FIDS_RF0017DF);
DCL-F JOBS Disk(*EXT) USAGE(*INPUT) KEYED Rename(JOBS : JOBRF);
DCL-F FILES Disk(*EXT) USAGE(*INPUT) KEYED Rename(FILES : FILERF);
DCL-F LIBRARIES Disk(*EXT) USAGE(*INPUT)
      KEYED Rename(LIBRARIES : LIBRF);
DCL-F LIBLS Disk(*EXT) USAGE(*INPUT) KEYED Rename(LIBLS : LIBLSTRF);
DCL-F AREAS Disk(*EXT) USAGE(*UPDATE:*DELETE:*OUTPUT)
      KEYED Rename(AREAS : AREARF) Commit;

//*-----------------------------------------------------------------------------------------*

// Prozedurenprototyp f�r Prozedur 'RF0017PG'

/Copy QCPYSRC,RF0017PG

// Prozedurenschnittstelle f�r Prozedur 'RF0017PG'

DCL-PI RF0017PG;
  PIMode CHAR(10) Const;                                                 // --> Modus
  PIJOB CHAR(10) Const;                                                  // --> Job
  PIPOS PACKED(6) Const;                                                 // --> Position
  PIARA CHAR(10);                                                        // <-> Bereich
  PIRtCd CHAR(10);                                                       // <-- R�ckkehrcode
END-PI;

//*-----------------------------------------------------------------------------------------*

// Prozedurenprototyp f�r Prozedur 'RF0003PG'

/Copy QCPYSRC,RF0003PG

// Prozedurenprototyp f�r Prozedur 'RF0005PG'

/Copy QCPYSRC,RF0005PG

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

// Datenstruktur f�r Format 'ERRC0100' f�r Fehlercode

/Copy QCPYSRC,ERRC0100

// Programmstatusdatenstruktur

DCL-DS PSDS LEN(429) PSDS;
END-DS;

// Dateiinformationsdatenstruktur f�r RF0017DF

DCL-DS FIDS_RF0017DF;
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
DCL-S ITFld CHAR(10);                                                    // Feld
DCL-S ITMsgId CHAR(7);                                                   // Nachrichten-Id.
DCL-S ITDsp INT(10) Dim(2);                                              // Anzeige Hilfetext
DCL-S ITNbr INT(10);                                                     // Anzahl Hilfetextm
DCL-S ITLftC INT(10) Dim(2);                                             // Linke Ecke
DCL-S ITRghC INT(10) Dim(2);                                             // Rechte Ecke
DCL-S ITCsrL INT(10) Dim(2);                                             // Cursorposition
DCL-S ITHlp CHAR(1);                                                     // Kontextbezogene H
DCL-S ITLIB CHAR(10);                                                    // Bibliothek
DCL-S ITLIBL CHAR(10);                                                   // Bibliotheksliste
DCL-S ITCCSID ZONED(10);                                                 // CCSID
DCL-S DO_X PACKED(7);

//*-----------------------------------------------------------------------------------------*

// Bezugszahl f�r 'Schl�sselwort SFLEND in Nachrichtensubdatei aktivieren' auf 'Ja' setzen
*IN50 = *On;
// Datensatz lesen
Chain ( PIJOB ) JOBRF;
// Fehler : Der Datensatz konnte nicht gefunden werden
If Not %Found;
  PIRtCd = '*ERROR';
Else;
  // Datensatz lesen
  Chain ( PIJOB : PIPOS ) FILERF;
  // Fehler : Der Datensatz konnte nicht gefunden werden
  If Not %Found;
    PIRtCd = '*ERROR';
  Else;
    // Job initialisieren
    DFJOB = PIJOB;
    // Position initialisieren
    DFPOS = PIPOS;
    Select;
      // Modus : 'Erstellen'
    When PIMode = '*CREATE';
      ExSr SR005;
      If PIRtCd = '*ENTER';
        PIARA = DFARA;
      EndIf;
      // Modus : '�ndern'
    When PIMode = '*CHANGE';
      ExSr SR010;
      // Modus : 'Kopieren'
    When PIMode = '*COPY';
      ExSr SR015;
      If PIRtCd = '*ENTER';
        PIARA = DFARA;
      EndIf;
      // Modus : 'L�schen'
    When PIMode = '*DELETE';
      ExSr SR020;
      // Modus : 'Anzeigen'
    When PIMode = '*DISPLAY';
      ExSr SR025;
    EndSl;
    // Datensatz entsperren
    Unlock AREAS;
  EndIf;
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
  ExSr SR050;
  If PIRtCd = '*ENTER';
    // Datensatz initialisieren
    Clear AREARF;
    XDJOB = PIJOB;
    XDPOS = PIPOS;
    // Datenbank mit Werten aus dem Bildschirm f�llen
    ExSr SR045;
    // Datensatz schreiben
    XDFILE = *Blanks;
    XDRCDW = *Blanks;
    XDCHGW = *Blanks;
    XDJLNG = *Blank;
    XDJRNL = *Blanks;
    XDJRN = *Blanks;
    XDRTO = *Zero;
    XDRCO = *Zero;
    XDTCS = *Zero;
    XDCTA = *Zero;
    XDCAP = *Zero;
    Write AREARF;
    // Modifikationen festschreiben
    Commit;
  EndIf;
EndSr;

//-------------------------------------------------------------------------------------------
// �ndern
//-------------------------------------------------------------------------------------------

BegSr SR010;
  // �berschrift f�r Modus '�ndern' anzeigen
  *IN(1) = *OFF;
  *IN(2) = *ON;
  *IN(3) = *OFF;
  *IN(4) = *OFF;
  *IN(5) = *OFF;
  // Datensatz lesen
  DoU Not %Error;
    Chain(E) ( PIJOB : PIPOS : PIARA ) AREARF;
    If %Error;
      HdlRcdLck(PSDS);
    EndIf;
  EndDo;
  // Fehler : Der Datensatz konnte nicht gefunden werden
  If Not %Found;
    PIRtCd = '*ERROR';
  Else;
    // Bildschirm mit Werten aus der Datenbank f�llen
    ExSr SR035;
    // Bildschirm verarbeiten
    ExSr SR050;
    If PIRtCd = '*ENTER';
      // Datenbank mit Werten aus dem Bildschirm f�llen
      ExSr SR045;
      // Datensatz aktualisieren
      Update AREARF;
      // Modifikationen festschreiben
      Commit;
    EndIf;
  EndIf;
EndSr;

//-------------------------------------------------------------------------------------------
// Kopieren
//-------------------------------------------------------------------------------------------

BegSr SR015;
  // �berschrift f�r Modus 'Kopieren' anzeigen
  *IN(1) = *OFF;
  *IN(2) = *OFF;
  *IN(3) = *ON;
  *IN(4) = *OFF;
  *IN(5) = *OFF;
  // Datensatz lesen
  Chain(N) ( PIJOB : PIPOS : PIARA ) AREARF;
  // Fehler : Der Datensatz konnte nicht gefunden werden
  If Not %Found;
    PIRtCd = '*ERROR';
  Else;
    // Bildschirm mit Werten aus der Datenbank f�llen
    ExSr SR035;
    // Bildschirm verarbeiten
    ExSr SR050;
    If PIRtCd = '*ENTER';
      // Datenbank mit Werten aus dem Bildschirm f�llen
      ExSr SR045;
      // Datensatz schreiben
      XDFILE = *Blanks;
      XDRCDW = *Blanks;
      XDCHGW = *Blanks;
      XDJLNG = *Blank;
      XDJRNL = *Blanks;
      XDJRN = *Blanks;
      XDRTO = *Zero;
      XDRCO = *Zero;
      XDTCS = *Zero;
      XDCTA = *Zero;
      XDCAP = *Zero;
      Write AREARF;
      // Modifikationen festschreiben
      Commit;
    EndIf;
  EndIf;
EndSr;

//-------------------------------------------------------------------------------------------
// L�schen
//-------------------------------------------------------------------------------------------

BegSr SR020;
  // �berschrift f�r Modus 'L�schen' anzeigen
  *IN(1) = *OFF;
  *IN(2) = *OFF;
  *IN(3) = *OFF;
  *IN(4) = *ON;
  *IN(5) = *OFF;
  // Datensatz lesen
  DoU Not %Error;
    Chain(E) ( PIJOB : PIPOS : PIARA ) AREARF;
    If %Error;
      HdlRcdLck(PSDS);
    EndIf;
  EndDo;
  // Fehler : Der Datensatz konnte nicht gefunden werden
  If Not %Found;
    PIRtCd = '*ERROR';
  Else;
    // Bildschirm mit Werten aus der Datenbank f�llen
    ExSr SR035;
    // Bildschirm verarbeiten
    ExSr SR050;
    If PIRtCd = '*ENTER';
      // Best�tigung f�r L�schung einholen
      ExFmt DSPF020W;
      // Funktionstaste abrufen
      ITFktKey = RtvFktKey(AIDCde);
      // Datensatz l�schen
      If ITFktKey = '*ENTER';
        // Datensatz l�schen
        Delete AREARF;
        // Modifikationen festschreiben
        Commit;
      Else;
        // L�schung abgebrochen
        PIRtCd = '*F12';
      EndIf;
    EndIf;
  EndIf;
EndSr;

//-------------------------------------------------------------------------------------------
// Anzeigen
//-------------------------------------------------------------------------------------------

BegSr SR025;
  // �berschrift f�r Modus 'Anzeigen' anzeigen
  *IN(1) = *OFF;
  *IN(2) = *OFF;
  *IN(3) = *OFF;
  *IN(4) = *OFF;
  *IN(5) = *ON;
  // Datensatz lesen
  Chain(N) ( PIJOB : PIPOS : PIARA ) AREARF;
  // Fehler : Der Datensatz konnte nicht gefunden werden
  If Not %Found;
    PIRtCd = '*ERROR';
  Else;
    // Bildschirm mit Werten aus der Datenbank f�llen
    ExSr SR035;
    // Bildschirm verarbeiten
    ExSr SR050;
  EndIf;
EndSr;

//-------------------------------------------------------------------------------------------
// Bildschirm mit Standartwerten f�llen
//-------------------------------------------------------------------------------------------

BegSr SR030;
  // Einzelwerte mit Standartwerten f�llen
  DFARA = *Blanks;
  DFLIB = *Blanks;
  DFLIBL = *Blanks;
  DFCCSID = *Blanks;
  DFCEXT = *Blanks;
EndSr;

//-------------------------------------------------------------------------------------------
// Bildschirm mit Werten aus der Datenbank f�llen
//-------------------------------------------------------------------------------------------

BegSr SR035;
  // Einzelwerte mit Werten aus der Datenbank f�llen
  DFARA = XDARA;
  DFLIB = XDLIB;
  DFLIBL = XDLIBL;
  DFCCSID = XDCCSID;
  DFCEXT = XDCEXT;
EndSr;

//-------------------------------------------------------------------------------------------
// Datenbank mit Werten aus dem Bildschirm f�llen
//-------------------------------------------------------------------------------------------

BegSr SR045;
  // Datenbank mit Einzelwerten f�llen
  XDARA = DFARA;
  XDLIB = DFLIB;
  XDLIBL = DFLIBL;
  XDCCSID = DFCCSID;
  XDCEXT = DFCEXT;
EndSr;

//-------------------------------------------------------------------------------------------
// Bildschirm verarbeiten
//-------------------------------------------------------------------------------------------

BegSr SR050;
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
      ExSr SR060;
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
        ExSr SR065;
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
      ExSr SR070;
      If PIRtCd = '*F3';
        Leave;
      Else;
        Iter;
      EndIf;
    EndIf;
    // Funktionstaste : 'Enter'
    If ITFktKey = '*ENTER';
      // Bildschirmfelder auf Fehler �berpr�fen
      ExSr SR055;
      If ITMsgId <> *Blanks;
        Iter;
      EndIf;
      // R�ckkehrcode setzen
      PIRtCd = '*ENTER';
      Leave;
    endif;
  EndDo;
EndSr;

//-------------------------------------------------------------------------------------------
// Bildschirmfelder auf Fehler �berpr�fen
//-------------------------------------------------------------------------------------------

BegSr SR055;
  // Namensfelder linksb�ndig ausrichten
  If PIMode = '*CREATE' Or
    PIMode = '*COPY' Or
    PIMode = '*CHANGE';
    DFARA = %TRIML(DFARA);
    DFLIB = %TRIML(DFLIB);
    DFLIBL = %TRIML(DFLIBL);
    DFCCSID = %TRIML(DFCCSID);
    DFCEXT = %TRIML(DFCEXT);
  EndIf;
  FOR DO_X = 1 TO 1;
    // *** Fehlerpr�fung nur f�r Modus 'Erstellen' und 'Kopieren' ***
    If PIMode = '*CREATE' Or
      PIMode = '*COPY';
      // The value in field 'Area' is not valid
      If DFARA <> '*NONE' And
        ChkVal('*NAME' : 10 : %Addr(DFARA)) =
        '*INVALID';
        ITMsgId = 'ERR0002';
        *IN(81) = *OFF;
        *IN(82) = *OFF;
        *IN(83) = *ON;
        Leave;
      EndIf;
      // The area does already exist
      SetLL ( PIJOB : PIPOS : DFARA ) AREARF;
      If %Equal;
        ITMsgId = 'ERR0001';
        *IN(81) = *ON;
        *IN(82) = *OFF;
        *IN(83) = *ON;
        Leave;
      EndIf;
    EndIf;
    // *** Fehlerpr�fung nur f�r Modus 'Erstellen', 'Kopieren' und '�ndern' ***
    If PIMode = '*CREATE' Or
      PIMode = '*COPY' Or
      PIMode = '*CHANGE';
      // The value in field 'Library' is not valid
      If ChkVal('*NAME' : 10 : %Addr(DFLIB)) =
        '*INVALID';
        ITMsgId = 'ERR0019';
        *IN(81) = *OFF;
        *IN(82) = *ON;
        *IN(83) = *OFF;
        Leave;
      EndIf;
      // The library has not defined
      SetLL ( PIJOB : DFLIB ) LIBRF;
      If Not %Equal;
        ITMsgId = 'ERR0006';
        *IN(81) = *OFF;
        *IN(82) = *ON;
        *IN(83) = *OFF;
        Leave;
      EndIf;
      If X1CRTE = '*NO';
        // The library list has to be *NONE, if create environment is *NO
        If DFLIBL <> '*NONE';
          ITMsgId = 'ERR0007';
          *IN(81) = *OFF;
          *IN(82) = *ON;
          *IN(83) = *ON;
          Leave;
        EndIf;
      Else;
        // The value in field 'Library list' is not valid
        If ChkVal('*NAME' : 10 : %Addr(DFLIBL)) =
          '*INVALID';
          ITMsgId = 'ERR0003';
          *IN(81) = *OFF;
          *IN(82) = *ON;
          *IN(83) = *ON;
          Leave;
        EndIf;
        // The library list has not defined
        SetLL ( PIJOB : DFLIBL ) LIBLSTRF;
        If Not %Equal;
          ITMsgId = 'ERR0005';
          *IN(81) = *OFF;
          *IN(82) = *ON;
          *IN(83) = *ON;
          Leave;
        EndIf;
      EndIf;
      // The value in field 'CCSID' is not valid
      If DFCCSID <> '*JOB';
        ITCCSID = *Zero;
        If ChkVal('*NUM' : 10 : %Addr(DFCCSID)) =
          '*VALID';
          ITCCSID = %Dec(DFCCSID : 10 : 0);
        EndIf;
        If Not (ITCCSID >= 1 And
          ITCCSID <= 65535);
          ITMsgId = 'ERR0008';
          *IN(81) = *ON;
          *IN(82) = *OFF;
          *IN(83) = *OFF;
          Leave;
        EndIf;
      EndIf;
    EndIf;
  ENDFOR;
EndSr;

//-------------------------------------------------------------------------------------------
// Fehlernachricht in die Programmnachrichtenwarteschlange schreiben
//-------------------------------------------------------------------------------------------

BegSr SR060;
  // Bezugszahl f�r 'Es liegt ein Fehler vor' auf 'Ja' setzen
  *IN80 = *On;
  // Fehlernachricht in die Programmnachrichtenwarteschlange schreiben
  ITSts = SndErrMsg(
   '*SAME' :                                                             // --> Aufrufstapele
   ITMsgId :                                                             // --> Nachrichten-I
   'RF0017MF' :                                                          // --> Nachrichtenda
   '*LIBL' :                                                             // --> Bibliothek Na
   *Blanks                                                               // --> Nachrichtenda
  );
EndSr;

//-------------------------------------------------------------------------------------------
// Hilfe
//-------------------------------------------------------------------------------------------

BegSr SR065;
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
    ITHIPG(ITNbr) = 'AREAS';
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
    // Modul 'ARA'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'AREAS';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'ARA';
    If DFFLD010 = 'DFARA';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'LIB'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'AREAS';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'LIB';
    If DFFLD010 = 'DFLIB';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'LIBL'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'AREAS';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'LIBL';
    If DFFLD010 = 'DFLIBL';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'CCSID'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'AREAS';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'CCSID';
    If DFFLD010 = 'DFCCSID';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'CEXT'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'AREAS';
    ITHILP(ITNbr) = '*LIBL';
    ITHIMO(ITNbr) = 'CEXT';
    If DFFLD010 = 'DFCEXT';
      ITHlp = 'J';
      ITDsp(1) = ITNbr;
      ITDsp(2) = ITNbr;
    EndIf;
    // Modul 'FKT'
    ITNbr = ITNbr + 1;
    ITHIPG(ITNbr) = 'RF0017GP';
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

BegSr SR070;
  Select;
    // Bedienerf�hrung f�r das Feld 'Bibliothek'
  When DFFLD010 = 'DFLIB';
    RF0005PG(
     '*SELECT' :                                                         // --> Modus
     PIJOB :                                                             // --> Job
     ITLIB :                                                             // <-> Bibliothek
     PIRtCd                                                              // <-- R�ckkehrcode
    );
    If PIRtCd = '*SELECT';
      DFLIB = ITLIB;
    EndIf;
    // Bedienerf�hrung f�r das Feld 'Bibliotheksliste'
  When DFFLD010 = 'DFLIBL';
    RF0003PG(
     '*SELECT' :                                                         // --> Modus
     PIJOB :                                                             // --> Job
     ITLIBL :                                                            // <-> Bibliotheksli
     PIRtCd                                                              // <-- R�ckkehrcode
    );
    If PIRtCd = '*SELECT';
      DFLIBL = ITLIBL;
    EndIf;
    // Es ist keine Bedienerf�hrung f�r das angeforderte Feld vorhanden
  Other;
    ITMsgId = 'ERR0004';
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