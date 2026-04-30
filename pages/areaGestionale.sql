CREATE OR REPLACE PROCEDURE areaGestionale (
    p_IdSessione IN SESSIONI.IdSessione%TYPE DEFAULT NULL
) IS
    v_nome CREDENZIALI.Username%TYPE;
    v_idUtente SESSIONI.IdUtente%TYPE;
    v_isIstruttore NUMBER := 0;
    v_isPersonalTrainer NUMBER := 0;
    v_isAmministrativo NUMBER := 0;
BEGIN
    ------------------------------------------------------------------
    -- CONTROLLO SESSIONE
    ------------------------------------------------------------------
    IF NOT sessioneUtente.controllaSessione(p_IdSessione) THEN
        htp.print('<script>window.location.href="' || global.url || 'home?msg=sessione_scaduta";</script>');
        RETURN;
    END IF;

    ------------------------------------------------------------------
    -- RECUPERO NOME UTENTE DELLA SESSIONE
    ------------------------------------------------------------------
    BEGIN 
        SELECT c.Username
        INTO v_nome
        FROM SESSIONI s
        JOIN CREDENZIALI c
          ON s.IdUtente = c.IdUtente
        WHERE s.IdSessione = p_IdSessione
          AND s.DataFine IS NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            htp.print('<script>window.location.href="' || global.url || 'home?msg=errore_login";</script>');
            RETURN;
    END;
    
    

    ------------------------------------------------------------------
    -- APERTURA PAGINA
    ------------------------------------------------------------------
    baseHTML.apriPagina(
        titolo       => 'Fitzone',
        p_idSessione => p_IdSessione
    );

    ------------------------------------------------------------------
    -- CONTENITORE PRINCIPALE
    ------------------------------------------------------------------
    baseHTML.apriDiv(
        id    => 'contenitore_area_gestionale',
        stile => 'padding:35px 40px 50px 40px;'
    );

    ------------------------------------------------------------------
    -- TITOLO PAGINA
    ------------------------------------------------------------------
    baseHTML.h1(
        testo => 'Area gestionale',
        stile => 'color:white; margin-bottom:10px;'
    );

    baseHTML.paragrafo(
        testo => 'Accedi rapidamente alle funzionalità gestionali disponibili',
        stile => 'color:white; margin-top:0; margin-bottom:30px;'
    );

    ------------------------------------------------------------------
    -- RECUPERO RUOLI
    ------------------------------------------------------------------
    SELECT s.IdUtente
    INTO v_idUtente
    FROM SESSIONI s
    WHERE s.IdSessione = p_IdSessione
      AND s.DataFine IS NULL;
    
    SELECT COUNT(*)
    INTO v_isAmministrativo
    FROM AMMINISTRATIVO
    WHERE IdUtente = v_idUtente;
    
    SELECT COUNT(*)
    INTO v_isIstruttore
    FROM ISTRUTTORE
    WHERE IdUtente = v_idUtente;
    
    SELECT COUNT(*)
    INTO v_isPersonalTrainer
    FROM PERSONAL_TRAINER
    WHERE IdUtente = v_idUtente;
    
    
    ------------------------------------------------------------------
    -- CONSULTAZIONE
    ------------------------------------------------------------------
    baseHTML.h1(
        testo => 'Consultazione',
        stile => 'color:white; font-size:26px; margin:25px 0 18px 0;'
    );
    
    baseHTML.apriDiv(id => 'griglia');
    
    Componenti.CardLink(
        NULL,
        'Ricerca personal trainer',
        'Cerca i personal trainer disponibili e visualizza le informazioni associate',
        global.url || 'PT.immettiParametriRicercaPT?p_IdSessione=' || p_IdSessione
    );
    
    Componenti.CardLink(
        NULL,
        'Visualizza istruttori',
        'Consulta l''elenco degli istruttori registrati',
        global.url || 'bartoli.visualizzaIstruttori?p_IdSessione=' || p_IdSessione
    );
    
    Componenti.CardLink(
        NULL,
        'Visualizza amministrativi',
        'Consulta l''elenco del personale amministrativo',
        global.url || 'bartoli.visualizzaAmministrativi?p_IdSessione=' || p_IdSessione
    );
    
    Componenti.CardLink(
        NULL,
        'Istruttori supervisionati',
        'Cerca gli istruttori supervisionati tramite email',
        global.url || 'bartoli.visIstruttoriSupEmail?p_IdSessione=' || p_IdSessione
    );
    
    baseHTML.chiudiDiv;
    
    
    ------------------------------------------------------------------
    -- GESTIONE CORSI
    ------------------------------------------------------------------
    IF v_isAmministrativo > 0 OR v_isIstruttore > 0 THEN
    
        baseHTML.h1(
            testo => 'Gestione corsi',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
    
        baseHTML.apriDiv(id => 'griglia');
    
        Componenti.CardLink(
            NULL,
            'Tipologie corso',
            'Visualizza le tipologie di corsi disponibili',
            global.url || 'batalli.visualizzaTipoCorso?p_idSessione=' || p_IdSessione
        );
    
        IF v_isIstruttore > 0 THEN
            Componenti.CardLink(
                NULL,
                'Corsi insegnati',
                'Visualizza i corsi associati agli istruttori',
                global.url || 'bartoli.corsiInsegnati?p_IdSessione=' || p_IdSessione
            );
        END IF;
    
        IF v_isAmministrativo > 0 THEN
            Componenti.CardLink(
                NULL,
                'Inserisci tipologia corso',
                'Aggiungi una nuova tipologia di corso',
                global.url || 'batalli.formInserisciTipologiaCorso?p_idSessione=' || p_IdSessione
            );
    
            Componenti.CardLink(
                NULL,
                'Assegna amministrativo a corso',
                'Collega un amministrativo alla gestione di un corso',
                global.url || 'batalli.formAssegnaAmmACorso?p_idSessione=' || p_IdSessione
            );
        END IF;
    
        baseHTML.chiudiDiv;
    
    END IF;
        
    
    ------------------------------------------------------------------
    -- GESTIONE PERSONALE
    ------------------------------------------------------------------
    IF v_isAmministrativo > 0 THEN
    
        baseHTML.h1(
            testo => 'Gestione personale',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
    
        baseHTML.apriDiv(id => 'griglia');
    
        Componenti.CardLink(
            NULL,
            'Aggiorna abilitazione',
            'Assegna o modifica l''abilitazione di un istruttore',
            global.url || 'batalli.formAggAbilitazione?p_idSessione=' || p_IdSessione
        );
    
        Componenti.CardLink(
            NULL,
            'Inserisci istruttore',
            'Registra un nuovo istruttore nel sistema',
            global.url || 'bartoli.inserisciIstruttore?p_IdSessione=' || p_IdSessione
        );
    
        Componenti.CardLink(
            NULL,
            'Elimina istruttore',
            'Rimuovi un istruttore dal sistema',
            global.url || 'bartoli.eliminaIstruttore?p_IdSessione=' || p_IdSessione
        );
    
        Componenti.CardLink(
            NULL,
            'Inserisci amministrativo',
            'Registra un nuovo membro del personale amministrativo',
            global.url || 'bartoli.inserisciAmministrativo?p_IdSessione=' || p_IdSessione
        );
    
        baseHTML.chiudiDiv;
    
    END IF;
    
    
    ------------------------------------------------------------------
    -- GESTIONE RECAPITI
    ------------------------------------------------------------------
    IF v_isAmministrativo > 0 THEN
    
        baseHTML.h1(
            testo => 'Gestione recapiti',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
    
        baseHTML.apriDiv(id => 'griglia');
    
        Componenti.CardLink(
            NULL,
            'Visualizza recapiti',
            'Consulta i recapiti degli istruttori',
            global.url || 'bartoli.visualizzaRecapiti?p_IdSessione=' || p_IdSessione
        );
    
        Componenti.CardLink(
            NULL,
            'Inserisci recapito email',
            'Aggiungi un recapito email a un istruttore',
            global.url || 'bartoli.inserisciRecapitoEmail?p_IdSessione=' || p_IdSessione
        );
    
        Componenti.CardLink(
            NULL,
            'Rimuovi recapito',
            'Elimina un recapito associato a un istruttore',
            global.url || 'bartoli.rimuoviRecapito?p_IdSessione=' || p_IdSessione
        );
    
        baseHTML.chiudiDiv;
    
    END IF;
    
    
    ------------------------------------------------------------------
    -- STRUTTURA PALESTRA
    ------------------------------------------------------------------
    IF v_isAmministrativo > 0 OR v_isPersonalTrainer > 0 OR v_isIstruttore > 0 THEN
    
        baseHTML.h1(
            testo => 'Struttura palestra',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
    
        baseHTML.apriDiv(id => 'griglia');
    
        -- Admin e PT vedono Sala Pesi
        IF v_isAmministrativo > 0 OR v_isPersonalTrainer > 0 THEN
            Componenti.CardLink(
                NULL,
                'Sala Pesi',
                'Visualizza sale, turni e personal trainer della sala pesi',
                global.url || 'salapesi.visualizza?p_IdSessione=' || p_IdSessione
            );
        END IF;
    
        -- Admin e istruttore vedono Sale Corsi
        IF v_isAmministrativo > 0 OR v_isIstruttore > 0 THEN
            Componenti.CardLink(
                NULL,
                'Sale corsi',
                'Consulta le sale dedicate alle lezioni e ai corsi',
                global.url || 'gabrielli.visualizzaSale?p_idSessione=' || p_IdSessione
            );
        END IF;
    
        -- Solo admin
        IF v_isAmministrativo > 0 THEN
    
            Componenti.CardLink(
                NULL,
                'Visualizza atleti',
                'Consulta l''elenco degli atleti registrati',
                global.url || 'gabrielli.visualizzaAtleti?p_idSessione=' || p_IdSessione
            );
    
            Componenti.CardLink(
                NULL,
                'Aggiungi personal trainer',
                'Inserisci un nuovo personal trainer nel sistema',
                global.url || 'PT.formaggiungPT?p_IdSessione=' || p_IdSessione
            );
    
        END IF;
    
        baseHTML.chiudiDiv;
    
    END IF;
    
    ------------------------------------------------------------------
    -- PREMI
    ------------------------------------------------------------------
    IF v_isAmministrativo > 0 OR v_isIstruttore > 0 THEN
    
        baseHTML.h1(
            testo => 'Premi',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
    
        baseHTML.apriDiv(id => 'griglia');
    
        ------------------------------------------------------------------
        -- ISTRUTTORE → SOLO VISUALIZZA I PROPRI PREMI
        ------------------------------------------------------------------
        IF v_isIstruttore > 0 THEN
            Componenti.CardLink(
                NULL,
                'I miei premi',
                'Visualizza i premi assegnati a te',
                global.url || 'PremiIstruttori.visualizzaPremiIstruttori?p_idSessione=' || p_IdSessione
            );
        END IF;
    
        ------------------------------------------------------------------
        -- AMMINISTRATIVO → TUTTO
        ------------------------------------------------------------------
        IF v_isAmministrativo > 0 THEN
    
            Componenti.CardLink(
                NULL,
                'Premi amministrativi',
                'Visualizza i premi assegnati agli amministrativi',
                global.url || 'premi_amministrativi.visualizzaPremiAmministrativi?p_idSessione=' || p_IdSessione
            );
    
            Componenti.CardLink(
                NULL,
                'Aggiungi premio amministrativo',
                'Inserisci un nuovo premio per un amministrativo',
                global.url || 'premi_amministrativi.aggiungiPremioAmministrativo?p_idSessione=' || p_IdSessione
            );
    
            Componenti.CardLink(
                NULL,
                'Premi istruttori',
                'Visualizza tutti i premi degli istruttori',
                global.url || 'PremiIstruttori.visualizzaPremiIstruttori?p_idSessione=' || p_IdSessione
            );
    
            Componenti.CardLink(
                NULL,
                'Aggiungi premio istruttore',
                'Inserisci un nuovo premio per un istruttore',
                global.url || 'PremiIstruttori.aggiungiPremioIstruttore?p_idSessione=' || p_IdSessione
            );
    
        END IF;
    
        baseHTML.chiudiDiv;
    
    END IF;
    
    
    ------------------------------------------------------------------
    -- STATISTICHE
    ------------------------------------------------------------------
    IF v_isAmministrativo > 0 THEN
    
        baseHTML.h1(
            testo => 'Statistiche',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
    
        baseHTML.apriDiv(id => 'griglia');
    
        Componenti.CardLink(
            NULL,
            'Statistiche palestra',
            'Visualizza le statistiche generali della palestra',
            global.url || 'VisualizzaStatistiche?p_IdSessione=' || p_IdSessione
        );
    
        baseHTML.chiudiDiv;
    
    END IF;

    ------------------------------------------------------------------
    -- CHIUSURA CONTENITORE E PAGINA
    ------------------------------------------------------------------
    baseHTML.chiudiDiv; -- chiude contenitore_area_gestionale

    baseHTML.chiudiPagina;
END;
/
GRANT EXECUTE ON areaGestionale TO anonymous;