create or replace package Corsi as

root constant VARCHAR2(20) := '/apex/Benedetti2526.';
accountutente constant VARCHAR2(20) := 'Benedetti2526';

procedure visualizza(
    numero IN number DEFAULT NULL
);

-- procedure aggiungi(
--     titolo    in corso.titolo%TYPE DEFAULT NULL
-- );
        
end Corsi;
