create or replace procedure creaCorso( p_idSessione IN NUMBER DEFAULT -1,
    p_titolo IN corso.titolo%TYPE DEFAULT NULL,
    p_descrizione IN corso.descrizione%TYPE DEFAULT NULL,
    p_durata IN corso.durata%TYPE DEFAULT NULL,
    p_maxPartecipanti IN corso.maxPartecipanti%TYPE DEFAULT NULL,
    p_prezzo IN corso.prezzo%TYPE DEFAULT NULL,
    p_idtipologia IN corso.idtipologia%TYPE DEFAULT NULL,
    p_idIstruttore IN corso.idIstruttore%TYPE DEFAULT NULL
) IS
    v_esito NUMBER := -1;
BEGIN

    v_esito := Corsi.inserisciCorso(
        p_titolo, p_descrizione, p_durata, p_maxPartecipanti, p_prezzo, p_idtipologia, p_idIstruttore
    );

    IF( v_esito = -1 ) THEN
        baseHTML.apriPagina('Crea corso', p_idSessione);
            Corsi.moduloInserisciCorso;
        baseHTML.chiudiPagina;
    ELSE
        owa_util.redirect_url( global.URL || 'CorsoSingolo?p_idSessione=' || p_idSessione || chr(38) || 'p_id=' || v_esito );
    END IF;

end creaCorso;
/
GRANT EXECUTE ON creaCorso TO anonymous;