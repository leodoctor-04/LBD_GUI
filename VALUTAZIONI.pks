CREATE OR REPLACE package Valutazioni as
    procedure creaValutazione(p_idSessione IN SESSIONI.IdSessione%TYPE, p_idCorso IN NUMBER DEFAULT 2, p_votoNumerico IN NUMBER DEFAULT NULL, p_commento IN VARCHAR2 DEFAULT NULL);
    
    procedure singolaValutazione(p_idSessione IN SESSIONI.IdSessione%TYPE, p_idCorso IN CORSO.IdCorso%TYPE, p_idValutazione IN VALUTAZIONE.IdValutazione%TYPE);
    
    procedure visualizzaValutazioni(p_idSessione IN SESSIONI.IdSessione%TYPE);
    
    procedure eliminaValutazione(p_idSessione IN SESSIONI.IdSessione%TYPE, p_idValutazione IN NUMBER);
    
end Valutazioni;

