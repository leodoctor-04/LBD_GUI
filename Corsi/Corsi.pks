create or replace package Corsi as

root constant VARCHAR2(20) := '/apex/Benedetti2526.';
accountutente constant VARCHAR2(20) := 'Benedetti2526';

-- Definizione delle variabili con scope di package
TYPE tabella_corsi IS TABLE OF Corso.titolo%TYPE;

-- Definizione delle variabili globali di sessione
array_corsi tabella_corsi;

procedure visualizza(
    numero IN number DEFAULT NULL
);

-- procedure aggiungi(
--     titolo    in corso.titolo%TYPE DEFAULT NULL
-- );
        
end Corsi;
