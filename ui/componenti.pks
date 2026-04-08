create or replace package Componenti as

-- types
TYPE tabella_corsi IS TABLE OF Corso.titolo%TYPE;

-- pkg scope var
root constant VARCHAR2(20) := '/apex/Benedetti2526.';
accountutente constant VARCHAR2(20) := 'Benedetti2526';
array_corsi tabella_corsi;

-- procedure
PROCEDURE calendar(startDate IN DATE);
PROCEDURE lesson(isTeacher BOOLEAN,course VARCHAR, teacher VARCHAR, startH VARCHAR , endH VARCHAR);

procedure LoginPopup;
procedure MenuHamburger;
procedure MenuButton (
    Testo varchar2,
    Link varchar2,
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
PROCEDURE loginProc (
    p_user IN VARCHAR2,
    p_pwd  IN VARCHAR2
);
PROCEDURE messaggioLogin( msg IN VARCHAR2);

-- del gruppo 3 (qui abusivamente)
procedure listaCorsi(numero IN number DEFAULT NULL);

END Componenti;