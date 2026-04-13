create or replace PACKAGE BODY sessioneUtente AS

    function controllaCredenziali(p_username IN CREDENZIALI.Username%TYPE, p_password IN CREDENZIALI.Password%TYPE) return boolean AS
        v_dbPsw CREDENZIALI.Password%TYPE;
    begin
        begin
            SELECT CREDENZIALI.Password INTO v_dbPsw
            FROM CREDENZIALI
            WHERE p_username = CREDENZIALI.Username;
            EXCEPTION
                WHEN NO_DATA_FOUND then
                    return false; --username o password sbagliati
        end;
        return p_password = v_dbPsw;
    end controllaCredenziali;

    function creaSessione(p_nomeUtente IN CREDENZIALI.Username%TYPE, p_password IN CREDENZIALI.Password%TYPE, p_idSessione OUT SESSIONI.IdSessione%TYPE, p_sessioneDuplicata OUT boolean) return boolean AS
        v_idUtente                      UTENTE.IdUtente%TYPE;
        v_idVecchiaSessione             SESSIONI.IdSessione%TYPE;
        v_isAtleta                      NUMBER(1) := 0;
        v_isAmministratore              NUMBER(1) := 0;
        v_isIstruttore                  NUMBER(1) := 0;
        v_isPersonalTrainer             NUMBER(1) := 0;
        v_var                           NUMBER;
    begin 
        if not controllaCredenziali(p_nomeUtente, p_password) then
            return false;
        end if;

        SELECT IdUtente INTO v_idUtente
        FROM CREDENZIALI
        WHERE Username = p_nomeUtente;

        p_sessioneDuplicata := false;

        begin
            SELECT IdSessione INTO v_idVecchiaSessione
            FROM SESSIONI
            WHERE IdUtente = v_idUtente
            AND DataFine IS NULL
            AND ROWNUM = 1;

            p_sessioneDuplicata := TRUE;
            if NOT sessioneUtente.aggiornaSessione(v_idVecchiaSessione) then
                RETURN FALSE;
            end if;

            EXCEPTION 
                WHEN NO_DATA_FOUND then
                    NULL; -- nessuna sessione aperta

        end;

        -- ruoli UTENTE
        -- amministrativo
        begin
            SELECT 1 INTO v_var 
            FROM AMMINISTRATIVO 
            WHERE IdUtente = v_idUtente;
            v_isAmministratore := 1;
        EXCEPTION 
            WHEN NO_DATA_FOUND then 
                NULL;
        end;
        --atleta
        begin
            SELECT 1 INTO v_var 
            FROM ATLETA 
            WHERE IdUtente = v_idUtente;
            v_isAtleta := 1;
        EXCEPTION 
            WHEN NO_DATA_FOUND then 
                NULL;
        end;
        --istruttore
        begin
            SELECT 1 INTO v_var 
            FROM ISTRUTTORE 
            WHERE IdUtente = v_idUtente;
            v_isIstruttore := 1;
        EXCEPTION 
            WHEN NO_DATA_FOUND then 
                NULL;
        end;
        --personaltrainer
        begin
            SELECT 1 INTO v_var 
            FROM PERSONAL_TRAINER 
            WHERE IdUtente = v_idUtente;
            v_isPersonalTrainer := 1;
        EXCEPTION 
            WHEN NO_DATA_FOUND then 
                NULL;
        end;

        INSERT INTO SESSIONI(
            IdSessione, 
            IsAmministratore, 
            IsAtleta, 
            IsIstruttore, 
            IsPersonalTrainer, 
            DataInizio, 
            DataFine, 
            IdUtente
        ) VALUES (
            seq_sessione.NEXTVAL, 
            v_isAmministratore, 
            v_isAtleta, 
            v_isIstruttore, 
            v_isPersonalTrainer, 
            SYSDATE, 
            NULL, 
            v_idUtente
        ) 
        RETURNING IdSessione INTO p_idSessione;

        return true;

    end creaSessione;

    function aggiornaSessione(p_idSessione IN SESSIONI.IdSessione%TYPE) return boolean AS
    begin
        UPDATE SESSIONI     
        SET DataFine = SYSDATE
        WHERE IdSessione = p_idSessione
            AND DataFine is NULL;
        
        if SQL%ROWCOUNT > 0 then
            RETURN TRUE;
        else
            RETURN FALSE; -- sessione non trovata o già chiusa
        end if;
    end aggiornaSessione;

    procedure login(p_username IN CREDENZIALI.Username%TYPE DEFAULT NULL, p_password IN CREDENZIALI.Password%TYPE DEFAULT NULL, p_idSessione OUT SESSIONI.IdSessione%TYPE) AS
        v_inserito boolean := false;
        v_sessioneDuplicata boolean;
    begin
        if(p_username is NULL or p_password is NULL) then 
            p_idSessione := NULL;
            IF p_username IS NULL AND p_password IS NULL THEN
                --apex_util.redirect_url ( p_url => global.root || 'home?msg=campi_mancanti' ); -- da inserire un messaggio di errore nella home
                htp.print('<script>window.location.href="' || global.root || 'home?msg=campi_mancanti";</script>');
                RETURN;
            ELSIF p_username IS NULL THEN
                --apex_util.redirect_url ( p_url => global.root || 'home?msg=user_mancante' ); -- da inserire un messaggio di errore nella home
                htp.print('<script>window.location.href="' || global.root || 'home?msg=user_mancante";</script>');
                RETURN;
            ELSIF p_password IS NULL THEN
                --apex_util.redirect_url ( p_url => global.root || 'home?msg=pwd_mancante' ); -- da inserire un messaggio di errore nella home
                htp.print('<script>window.location.href="' || global.root || 'home?msg=pwd_mancante";</script>');
                RETURN;
            END IF;
        else
            v_inserito := sessioneUtente.creaSessione(p_username, p_password, p_idSessione, v_sessioneDuplicata);
        end if;
        if(v_inserito) then
            if(v_sessioneDuplicata) then
                --si dice che è stata chiusa la sessione precedente e mandiamo in homePage
                --apex_util.redirect_url ( p_url => global.root || 'home' ); -- da inserire un messaggio di errore nella home
                htp.print('<script>window.location.href="' || global.root || 'home?IdSessione=' || p_idSessione || '";</script>');
            else
                --mandiamo direttamente in homePage
                --apex_util.redirect_url ( p_url => global.root || 'home' );
                htp.print('<script>window.location.href="' || global.root || 'home?IdSessione=' || p_idSessione || '";</script>');
            end if;
        else 
            p_idSessione := NULL;
            --mostriamo un errore di psw o username sbagliati e facciamo riprovare il login
            --apex_util.redirect_url ( p_url => global.root || 'home?msg=errore_login' );
            htp.print('<script>window.location.href="' || global.root || 'home?msg=errore_login";</script>');
        end if;
    end login;


    procedure logout(p_idSessione IN SESSIONI.IdSessione%TYPE) AS
        v_aggiornata boolean := false;
    begin
        v_aggiornata := sessioneUtente.aggiornaSessione(p_idSessione);
        if(v_aggiornata) then
            --il logout ha successo
            --apex_util.redirect_url ( p_url => global.root || 'home' );
            htp.print('<script>window.location.href="' || global.root || 'home";</script>');
        else 
            --il logout non va a buon fine
            --apex_util.redirect_url ( p_url => global.root || 'home' ); -- da inserire un messaggio di errore nella home
            htp.print('<script>window.location.href="' || global.root || 'home";</script>');
        end if;
    end logout;


    function controllaSessione(p_idSessione IN SESSIONI.IdSessione%TYPE) return boolean AS
        v_dataFine SESSIONI.DataFine%TYPE;
    begin
        if (p_idSessione IS NULL) then
            return false;
        end if;
        begin
            SELECT SESSIONI.DataFine INTO v_dataFine
            FROM SESSIONI
            WHERE p_idSessione = SESSIONI.IdSessione;
            EXCEPTION
                WHEN NO_DATA_FOUND then
                    return false; --sessione non trovata
        end;

        if(v_dataFine IS NULL) then
            return true; --sessione attiva
        else 
            return false; --sessione terminata
        end if;

    end controllaSessione;

    end sessioneUtente; 