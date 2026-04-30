create or replace package body Corsi as

PROCEDURE visualizzaCorsi( p_tipologia IN varchar2 DEFAULT NULL, useSessione BOOLEAN default TRUE) IS
    TYPE r_corso IS RECORD (
        idCorso Corso.idCorso%TYPE,
        titolo  Corso.titolo%TYPE
    );
    TYPE t_corsi IS TABLE OF r_corso;

    array_corsi t_corsi;
    v_current_url VARCHAR2(1000);
BEGIN
    v_current_url := owa_util.get_cgi_env('SCRIPT_NAME') || owa_util.get_cgi_env('PATH_INFO');

    IF( baseHTML.v_idSessione < 0 OR NOT useSessione ) THEN
        SELECT Corso.idCorso, titolo 
        BULK COLLECT INTO array_corsi
        FROM Corso
        WHERE Corso.Stato = 'ATTIVO'
        AND (p_tipologia is null OR Corso.idtipologia = p_tipologia);
    ELSE
        SELECT Corso.idCorso, titolo 
        BULK COLLECT INTO array_corsi
        FROM Corso, SESSIONI, ISCRIZIONE_CORSO
        WHERE Corso.Stato = 'ATTIVO'
        AND (p_tipologia is null OR Corso.idtipologia = p_tipologia)
        AND baseHTML.v_idSessione = SESSIONI.idSessione
        AND SESSIONI.idUtente = ISCRIZIONE_CORSO.idAtleta
        AND Corso.idCorso = ISCRIZIONE_CORSO.idCorso;
    END IF;

    IF array_corsi.COUNT > 0 THEN
        FOR i IN array_corsi.FIRST .. array_corsi.LAST LOOP
            IF v_current_url NOT LIKE '%' || 'home' THEN
                baseHTML.collegamento( array_corsi(i).titolo, global.url || 'CorsoSingolo?p_idSessione=' || baseHTML.v_idSessione || '&p_id=' || array_corsi(i).idCorso );
            ELSE
                baseHTML.paragrafo( array_corsi(i).titolo );
            END IF;
        END LOOP;
    ELSE
        baseHTML.paragrafo('nessun corso trovato');
    END IF;

END visualizzaCorsi;

PROCEDURE listaCorsiAll( p_tipologia IN varchar2 DEFAULT NULL, useSessione BOOLEAN default TRUE) IS
    TYPE r_corso IS RECORD (
        idCorso Corso.idCorso%TYPE,
        titolo  Corso.titolo%TYPE
    );
    TYPE t_corsi IS TABLE OF r_corso;

    array_corsi t_corsi;
    v_current_url VARCHAR2(1000);
BEGIN
    v_current_url := owa_util.get_cgi_env('SCRIPT_NAME') || owa_util.get_cgi_env('PATH_INFO');

    IF( baseHTML.v_idSessione < 0 OR NOT useSessione ) THEN
        SELECT Corso.idCorso, titolo 
        BULK COLLECT INTO array_corsi
        FROM Corso
        WHERE (p_tipologia is null OR Corso.idtipologia = p_tipologia);
    ELSE
        SELECT Corso.idCorso, titolo 
        BULK COLLECT INTO array_corsi
        FROM Corso, SESSIONI, ISCRIZIONE_CORSO
        WHERE (p_tipologia is null OR Corso.idtipologia = p_tipologia)
        AND baseHTML.v_idSessione = SESSIONI.idSessione
        AND SESSIONI.idUtente = ISCRIZIONE_CORSO.idAtleta
        AND Corso.idCorso = ISCRIZIONE_CORSO.idCorso;
    END IF;

    IF array_corsi.COUNT > 0 THEN
        FOR i IN array_corsi.FIRST .. array_corsi.LAST LOOP
            baseHTML.tendinaOption( array_corsi(i).titolo, array_corsi(i).idCorso );
        END LOOP;
    ELSE
        baseHTML.paragrafo('nessun corso trovato');
    END IF;

END listaCorsiAll;

PROCEDURE visualizzaCorsiIstruttore( p_idIstruttore IN number, isLink in boolean DEFAULT false ) IS
is_empty boolean := true;
BEGIN
    FOR corso IN ( SELECT idCorso, titolo FROM Corso WHERE idIstruttore = p_idIstruttore AND Stato = 'ATTIVO' )
    LOOP
        is_empty := false;
        IF isLink THEN
            baseHTML.collegamento( corso.titolo, global.url || 'CorsoSingolo?p_idSessione=' || baseHTML.v_idSessione || '&p_id=' || corso.idCorso , 'background-color: deepskyblue; border: 0.25vw solid blue;' );
        ELSE
            baseHTML.paragrafo( corso.titolo, 'background-color: cornflowerblue; border: 0.25vw solid blue;' );
        END IF;
    END LOOP;
    IF is_empty THEN
        baseHTML.paragrafo( 'nessun corso gestito', 'background-color: cornflowerblue; border: 0.25vw solid blue;' );
    END IF;
END visualizzaCorsiIstruttore;

PROCEDURE visualizzaCorso( p_id IN number ) IS
v_corso Corso%ROWTYPE;
v_tipologia Tipologia_corso.nomeTipologia%TYPE;
v_istruttore Utente.nome%TYPE;
BEGIN
    SELECT * INTO v_corso FROM Corso WHERE Corso.idcorso = p_id;
    SELECT nome INTO v_istruttore FROM Utente WHERE idUtente = v_corso.idIstruttore;
    SELECT nomeTipologia INTO v_tipologia FROM Tipologia_corso WHERE idTipologia = v_corso.idtipologia;

    baseHTML.apridiv('flex', 'padding: 2.5vw 7.5vw; width:75%');
        
    baseHTML.apriDiv;
        baseHTML.paragrafo( 'Titolo: ' || v_corso.titolo );
        baseHTML.apriDiv;
            baseHTML.paragrafo( 'Descrizione:', 'margin: 0px;' );
            baseHTML.inserisciTextArea( v_corso.descrizione, null, false );
        baseHTML.chiudiDiv;
        baseHTML.paragrafo( 'Tipologia: ' || v_tipologia );
    baseHTML.chiudiDiv;

    baseHTML.apriDiv; -- informazioni extra
        baseHTML.paragrafo( 'Istruttore: ' || v_istruttore );
        Corsi.votoCorso( p_id );
        baseHTML.paragrafo( 'Durata: ' || v_corso.durata || ' minuti' );
        baseHTML.paragrafo( 'Massimo partecipanti: ' || v_corso.maxPartecipanti );
        baseHTML.paragrafo( 'Prezzo: ' || v_corso.prezzo || ' euro' );
    baseHTML.chiudiDiv;
    

    baseHTML.chiudiDiv;

END visualizzaCorso;

FUNCTION inserisciCorso(
    p_titolo IN corso.titolo%TYPE,
    p_descrizione IN corso.descrizione%TYPE,
    p_durata IN corso.durata%TYPE,
    p_maxPartecipanti IN corso.maxPartecipanti%TYPE,
    p_prezzo IN corso.prezzo%TYPE,
    p_idtipologia IN corso.idtipologia%TYPE,
    p_idIstruttore IN corso.idIstruttore%TYPE
) RETURN NUMBER IS
    v_idCorso corso.idCorso%TYPE;
BEGIN
    -- Inserimento con clausola RETURNING per ottenere l'ID generato dalla sequenza
    INSERT INTO Corso (
        idCorso, titolo, descrizione, durata, maxPartecipanti, STATO, prezzo, idtipologia, idIstruttore
    ) VALUES (
        SEQ_CORSO.nextval, p_titolo, p_descrizione, p_durata, p_maxPartecipanti, 'ATTIVO', p_prezzo, p_idtipologia, p_idIstruttore
    )
    RETURNING idCorso INTO v_idCorso;

    COMMIT;

    RETURN v_idCorso;

EXCEPTION
    WHEN OTHERS THEN
        -- In caso di errore annulla l'operazione e restituisce -1
        ROLLBACK;
        RETURN -1;
END inserisciCorso;

PROCEDURE moduloInserisciCorso IS BEGIN
    baseHTML.apriModulo( 'modulo', global.url || 'creaCorso' );
        baseHTML.inserisciInput( null, 'hidden', 'p_idSessione', baseHTML.v_idSessione );

        baseHTML.inserisciInput( 'titolo', 'text', 'p_titolo', NULL, 'Inserisci il nome del corso', true );
        baseHTML.inserisciTextArea( null, 'p_descrizione' );
        baseHTML.inserisciInput( 'durata', 'number', 'p_durata', NULL, 'Inserisci la durata del corso', true );
        baseHTML.inserisciInput( 'maxPartecipanti', 'number', 'p_maxPartecipanti', NULL, 'Inserisci il massimo di partecipanti', true );
        baseHTML.inserisciInput( 'prezzo', 'number', 'p_prezzo', NULL, 'Inserisci il prezzo del corso', true );

        baseHTML.apriMenuTendina('Tipologia', 'p_idtipologia');
        FOR r IN (SELECT idTipologia, nomeTipologia FROM Tipologia_corso) LOOP
            -- Passiamo il nome come etichetta e l'ID come valore tecnico
            baseHTML.tendinaOption( r.nomeTipologia, r.idTipologia);
        END LOOP;
        baseHTML.chiudiMenuTendina;

        baseHTML.apriMenuTendina('Istruttore', 'p_idIstruttore');
        FOR i IN (SELECT nome, cognome, Utente.idUtente FROM Utente, Istruttore WHERE Istruttore.idUtente = Utente.idUtente ) LOOP
            -- Passiamo il nome come etichetta e l'ID come valore tecnico
            baseHTML.tendinaOption( i.nome || ' ' || i.cognome, i.idUtente);
        END LOOP;
        baseHTML.chiudiMenuTendina;
        baseHTML.bottone('salva');

    baseHTML.chiudiModulo;
END moduloInserisciCorso;

FUNCTION degradaCorso( p_id IN number ) RETURN NUMBER IS
    v_stato Corso.stato%TYPE;
BEGIN
    SELECT Stato INTO v_stato FROM Corso WHERE idCorso = p_id;
    IF v_stato = 'DISATTIVO' THEN
        DELETE Corso WHERE idCorso = p_id;
        RETURN 1; -- corso eliminato
    ELSE
        UPDATE Corso SET Stato = 'DISATTIVO' WHERE idCorso = p_id;
        RETURN 0; -- corso disattivato
    END IF;
    COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Gestisce il caso in cui il p_id non esista nella tabella
            RETURN -1; 
        WHEN OTHERS THEN
            -- Gestisce qualsiasi altro errore imprevisto
            ROLLBACK; -- Buona pratica: annulla eventuali modifiche pendenti in caso di errore
            RETURN -1;
END degradaCorso;

PROCEDURE votoCorso( p_id IN number ) IS 
    v_voto NUMBER;
BEGIN
    SELECT AVG(VOTONUMERICO) INTO v_voto
    FROM VALUTAZIONE
    WHERE IDCORSO = p_id;

    BaseHTML.paragrafo( 'Voto: ' || v_voto );

END votoCorso;
END Corsi;