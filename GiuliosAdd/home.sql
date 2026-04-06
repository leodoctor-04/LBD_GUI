CREATE OR REPLACE PROCEDURE home (
    IdSessione IN NUMBER   DEFAULT NULL,
    msg        IN VARCHAR2 DEFAULT NULL
) IS
    v_nome            VARCHAR2(100);
    v_sessione_attiva NUMBER;
BEGIN
    v_sessione_attiva := IdSessione;

    fitGUI.ApriPagina;

    ------------------------------------------------------------------
    -- MESSAGGI LOGIN
    ------------------------------------------------------------------
    IF msg IS NOT NULL THEN
        IF msg = 'login_errato' THEN
            fitGUI.MessaggioTemporaneo(
                'msg_login_errato',
                'Login errato',
                'errore',
                3000
            );
        ELSIF msg = 'user_mancante' THEN
            fitGUI.MessaggioTemporaneo(
                'msg_user_mancante',
                'Nome utente mancante',
                'warning',
                3000
            );
        ELSIF msg = 'pwd_mancante' THEN
            fitGUI.MessaggioTemporaneo(
                'msg_pwd_mancante',
                'Password mancante',
                'warning',
                3000
            );
        ELSIF msg = 'campi_mancanti' THEN
            fitGUI.MessaggioTemporaneo(
                'msg_campi_mancanti',
                'Nome utente e password mancanti',
                'warning',
                3000
            );
        ELSIF msg = 'errore_login' THEN
            fitGUI.MessaggioTemporaneo(
                'msg_errore_login',
                'Errore durante il login',
                'errore',
                3000
            );
        ELSIF msg = 'login_ok' THEN
            fitGUI.MessaggioTemporaneo(
                'msg_login_ok',
                'Login effettuato con successo',
                'successo',
                3000
            );
        END IF;
    END IF;

    ------------------------------------------------------------------
    -- UTENTE NON LOGGATO
    ------------------------------------------------------------------
    IF v_sessione_attiva IS NULL THEN
        fitGUI.Header('FitZone', FALSE);

        fitGUI.ApriContenitore('30px');

        fitGUI.HeroLanding;
        fitGUI.MiglioriCorsiLanding;
        
        fitGUI.ChiudiContenitore;

        fitGUI.LoginPopup;

    ------------------------------------------------------------------
    -- UTENTE LOGGATO
    ------------------------------------------------------------------
    ELSE
        BEGIN
            SELECT u.Nome
            INTO v_nome
            FROM SESSIONI s
            JOIN UTENTE u
              ON s.IdUtente = u.IdUtente
            WHERE s.IdSessione = v_sessione_attiva
              AND s.DataFine IS NULL;

        fitGUI.Header('FitZone', TRUE, v_nome);
        fitGUI.MenuHamburger();
    
        fitGUI.ApriContenitore('30px');

        
        ------------------------------------------------------------------
        -- BENVENUTO UTENTE 
        ------------------------------------------------------------------
        fitGUI.TitoloSezione(
            'Benvenuto ' || v_nome,
            'Pronto per allenarti oggi?'
        );
        
        ------------------------------------------------------------------
        -- STESSA LANDING DEL GUEST
        ------------------------------------------------------------------
        fitGUI.HeroLanding;
        fitGUI.MiglioriCorsiLanding;
        
        fitGUI.ChiudiContenitore;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                fitGUI.Header('FitZone', FALSE);

                fitGUI.MessaggioTemporaneo(
                    'msg_sessione_non_valida',
                    'Sessione non valida',
                    'errore',
                    3500
                );

                htp.print('<div style="padding:30px;">');
                fitGUI.Card('La sessione non e'' valida. Effettua di nuovo il login.');
                htp.print('</div>');

                fitGUI.LoginPopup;

            WHEN OTHERS THEN
                fitGUI.Header('FitZone', FALSE);

                fitGUI.MessaggioTemporaneo(
                    'msg_query_fallita',
                    'Errore durante il recupero dei dati',
                    'errore',
                    3500
                );

                htp.print('<div style="padding:30px;">');
                fitGUI.Card('Si e'' verificato un errore imprevisto.');
                htp.print('</div>');

                fitGUI.LoginPopup;
        END;
    END IF;

    fitGUI.ChiudiPagina;
END;
/