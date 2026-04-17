--------------------------------------------------------
--  DDL for Package COMPONENTI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "DELPRETE2526"."COMPONENTI" as

-- types
TYPE tabella_corsi IS TABLE OF Corso.titolo%TYPE;

-- pkg scope var
array_corsi tabella_corsi;

-- procedure
PROCEDURE calendar(startDate IN DATE);
PROCEDURE lesson(isTeacher BOOLEAN,course VARCHAR, teacher VARCHAR, startH VARCHAR , endH VARCHAR);

procedure LoginPopup;
procedure MenuHamburger(p_idSessione IN NUMBER);
procedure MenuButton (
    Testo varchar2,
    Link varchar2,
    p_idSessione IN NUMBER,
    Colore varchar2 default 'black'
);
procedure MessaggioTemporaneo (
    IdMsg        varchar2,
    Testo        varchar2,
    Tipo         varchar2 default 'errore',
    Millisecondi number default 3000
);
procedure StatCard (
    Titolo      varchar2,
    Valore      varchar2,
    Descrizione varchar2 default null
);

PROCEDURE messaggioLogin( msg IN VARCHAR2);

-- del gruppo 3 (qui abusivamente)
procedure listaCorsi(numero IN number DEFAULT NULL);

END Componenti;


