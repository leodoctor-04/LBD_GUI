    CREATE OR REPLACE PROCEDURE VisualizzaStatistiche (
        p_IdSessione IN SESSIONI.IdSessione%TYPE DEFAULT NULL
    ) IS
        v_nome CREDENZIALI.Username%TYPE;
    BEGIN
        ------------------------------------------------------------------
        -- CONTROLLO SESSIONE
        ------------------------------------------------------------------
        IF NOT sessioneUtente.controllaSessione(p_IdSessione) THEN
            htp.print('<script>window.location.href="' || global.url || 'home?msg=sessione_scaduta";</script>'); -- sessioneScaduta
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
            id    => 'contenitore_statistiche',
            stile => 'padding:35px 40px 50px 40px;'
        );
    
        ------------------------------------------------------------------
        -- TITOLO PAGINA
        ------------------------------------------------------------------
        baseHTML.h1(
            testo => 'Statistiche palestra',
            stile => 'color:white; margin-bottom:10px;'
        );
    
        baseHTML.paragrafo(
            testo => 'Panoramica generale dell''andamento',
            stile => 'color:white; margin-top:0; margin-bottom:30px;'
        );
    
        ------------------------------------------------------------------
        -- SEZIONE STATISTICHE GENERALI
        ------------------------------------------------------------------
        baseHTML.h1(
            testo => 'Statistiche generali',
            stile => 'color:white; font-size:26px; margin:25px 0 18px 0;'
        );
        
        baseHTML.apriDiv(id => 'griglia');
        
        Componenti.CardLink(
            NULL,
            'Corsi più selezionati',
            'Classifica dei corsi più scelti dagli atleti',
            global.url || 'salapesi.statisticheCorsiPiuSelezionati?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Carico lavoro PT',
            'Visualizza le statistiche sul carico di lavoro dei personal trainer',
            global.url || 'statisticheCaricoLavoroPT?IdSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Frequentazione corsi',
            'Visualizza le statistiche di frequentazione dei corsi',
            global.url || 'gabrielli.frequentazioneCorsi?p_idSessione=' || p_IdSessione
        );
    
        Componenti.CardLink(
            NULL,
            'Distribuzione abbonamenti',
            'Visualizza la distribuzione degli abbonamenti attivi per tipologia',
            global.url || 'pagina_abbonamento.statisticaDistribuzioneAbb?p_IdSessione=' || p_IdSessione
        );
        
        baseHTML.chiudiDiv;

        ------------------------------------------------------------------
        -- SEZIONE STATISTICHE ISTRUTTORI E AMMINISTRATIVI
        ------------------------------------------------------------------
        baseHTML.h1(
            testo => 'Statistiche personale',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
        
        baseHTML.apriDiv(id => 'griglia');
        
        Componenti.CardLink(
            NULL,
            'Indice gradimento istruttore',
            'Calcola la media delle valutazioni per un istruttore specifico',
            global.url || 'bartoli.indiceGradimentoIstruttore?IdSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Amministrativo con più istruttori',
            'Visualizza quale amministrativo supervisiona il maggior numero di istruttori',
            global.url || 'bartoli.amministrativoConPiuIstruttori?IdSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Numero istruttori per amministrativo',
            'Mostra quanti istruttori sono gestiti da ciascun amministrativo',
            global.url || 'bartoli.numIstrPerAmmi?IdSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Amministrativo più attivo',
            'Individua l''amministrativo che gestisce più corsi',
            global.url || 'batalli.visAmmCheAmministraPiuCorsi?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Corsi per tipologia',
            'Mostra quanti corsi esistono per ogni tipologia',
            global.url || 'batalli.visNumeroCorsiTipo?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Istruttori per tipologia',
            'Visualizza gli istruttori suddivisi per tipologia di corso',
            global.url || 'batalli.visIstruttoriPerTipologia?p_idSessione=' || p_IdSessione
        );
        
        
        baseHTML.chiudiDiv;
        
        
        ------------------------------------------------------------------
        -- SEZIONE STATISTICHE SESSIONI
        ------------------------------------------------------------------
        baseHTML.h1(
            testo => 'Statistiche sessioni',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
        
        baseHTML.apriDiv(id => 'griglia');
        
        Componenti.CardLink(
            NULL,
            'Sessioni attive in periodo',
            'Visualizza le sessioni attive in un intervallo di date',
            global.url || 'statisticheSessioni.sessioniAttiveInPeriodo?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Utenti attivi in periodo',
            'Mostra gli utenti attivi in un determinato intervallo temporale',
            global.url || 'statisticheSessioni.utentiAttiviinPeriodo?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Accessi per utente',
            'Numero totale di accessi effettuati da ciascun utente',
            global.url || 'statisticheSessioni.numeroAccessiPerUtente?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Utente più attivo',
            'Individua l''utente con il maggior numero di accessi',
            global.url || 'statisticheSessioni.utenteConPiuAccessi?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Tempo medio tra sessioni',
            'Calcola il tempo medio tra una sessione e l''altra',
            global.url || 'statisticheSessioni.tempoMedioTraSessioni?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Durata totale sessioni',
            'Durata complessiva di tutte le sessioni',
            global.url || 'statisticheSessioni.durataTotaleSessioni?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Durata sessioni per utente',
            'Durata totale delle sessioni suddivisa per utente',
            global.url || 'statisticheSessioni.durataTotaleSessioniPerUtente?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Sessioni max/min durata',
            'Individua la sessione più lunga e più breve',
            global.url || 'statisticheSessioni.sessioneConDurataMaxMin?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Durata media sessioni',
            'Calcola la durata media delle sessioni',
            global.url || 'statisticheSessioni.durataMediaSessioni?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Durata media per utente',
            'Durata media delle sessioni per ogni utente',
            global.url || 'statisticheSessioni.durataMediaSessioniPerUtente?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Dashboard sessioni',
            'Visualizza un riepilogo completo delle statistiche delle sessioni',
            global.url || 'statisticheSessioni.mostraStatistiche?p_idSessione=' || p_IdSessione
        );
        
        baseHTML.chiudiDiv;
        
        ------------------------------------------------------------------
        -- SEZIONE STATISTICHE PREMI
        ------------------------------------------------------------------
        baseHTML.h1(
            testo => 'Statistiche premi',
            stile => 'color:white; font-size:26px; margin:40px 0 18px 0;'
        );
        
        baseHTML.apriDiv(id => 'griglia');
        
        Componenti.CardLink(
            NULL,
            'Classifica amministrativi',
            'Visualizza la classifica degli amministrativi in base ai premi',
            global.url || 'StatistichePremi.classificaAmministrativi?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Medie amministrativi',
            'Calcola la media dei punteggi degli amministrativi in un periodo',
            global.url || 'StatistichePremi.medieAmministrativi?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Classifica istruttori',
            'Visualizza la classifica degli istruttori in base ai premi',
            global.url || 'StatistichePremi.classificaIstruttori?p_idSessione=' || p_IdSessione
        );
        
        Componenti.CardLink(
            NULL,
            'Medie istruttori',
            'Calcola la media dei punteggi degli istruttori in un periodo',
            global.url || 'StatistichePremi.medieIstruttori?p_idSessione=' || p_IdSessione
        );
        
        baseHTML.chiudiDiv;
    
        ------------------------------------------------------------------
        -- CHIUSURA CONTENITORE E PAGINA
        ------------------------------------------------------------------
        baseHTML.chiudiDiv; -- chiude contenitore_statistiche
    
        baseHTML.chiudiPagina;
    END;
    /