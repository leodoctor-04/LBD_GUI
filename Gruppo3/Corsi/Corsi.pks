create or replace package Corsi as

-- visualizza i corsi,
-- se tipologia è null mostra tutto, altrimenti mostra solo quelli della tipologia (ATTENZIONE al case sensitive)
-- per mostrare tutti i corsi di una tipologia, metterenumero a null, e scrivere la tipologia desiderata
procedure visualizzaCorsi(
    p_tipologia IN varchar2 DEFAULT NULL,
    useSessione BOOLEAN default TRUE
);
PROCEDURE listaCorsiAll( p_tipologia IN varchar2 DEFAULT NULL, useSessione BOOLEAN default TRUE);

PROCEDURE visualizzaCorsiIstruttore(
    p_idIstruttore IN number
);

-- visualizza tutti i dettagli di un corso specifico
procedure visualizzaCorso(
    p_id IN number DEFAULT NULL
);

FUNCTION inserisciCorso(
    p_titolo IN corso.titolo%TYPE,
    p_descrizione IN corso.descrizione%TYPE,
    p_durata IN corso.durata%TYPE,
    p_maxPartecipanti IN corso.maxPartecipanti%TYPE,
    p_prezzo IN corso.prezzo%TYPE,
    p_idtipologia IN corso.idtipologia%TYPE,
    p_idIstruttore IN corso.idIstruttore%TYPE
) RETURN NUMBER;

PROCEDURE moduloInserisciCorso;

FUNCTION degradaCorso( p_id IN number ) RETURN NUMBER;

PROCEDURE votoCorso( p_id IN number );

end Corsi;
