create or replace package Premi as

-- root constant VARCHAR2(20) := '/apex/Benedetti2526.';
-- accountutente constant VARCHAR2(20) := 'Benedetti2526';
root constant VARCHAR2(20) := '/apex/LBD_LOCALE.';
accountutente constant VARCHAR2(20) := 'LBD_LOCALE';

PROCEDURE visualizzaPremi;

procedure visualizzaPremioAmministrativo;

procedure aggiungi_premio_amministrativo(
    mese    in premio_amministrativo.mese%TYPE DEFAULT NULL,
    anno    in premio_amministrativo.anno%TYPE DEFAULT NULL,
    punti   in premio_amministrativo.punteggio%TYPE DEFAULT NULL
);

procedure visualizzaPremioIstruttore;
-- procedure aggiungi_premio_istruttore(
--     mese    in premio_istruttore.mese%TYPE DEFAULT NULL,
--     anno    in premio_istruttore.anno%TYPE DEFAULT NULL,
--     punti   in premio_istruttore.punteggio%TYPE DEFAULT NULL
-- );
        
end Premi;