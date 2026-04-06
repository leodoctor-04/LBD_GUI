CREATE OR REPLACE PROCEDURE login_proc (
    p_user IN VARCHAR2,
    p_pwd  IN VARCHAR2
) IS
    v_user        VARCHAR2(100);
    v_pwd         VARCHAR2(100);
    v_idUtente    NUMBER;
    v_idsessione  NUMBER;
    v_admin       NUMBER := 0;
    v_atleta      NUMBER := 0;
    v_istruttore  NUMBER := 0;
    v_pt          NUMBER := 0;
BEGIN
    v_user := TRIM(p_user);
    v_pwd  := p_pwd;

    ------------------------------------------------------------------
    -- Controllo campi mancanti
    ------------------------------------------------------------------
    IF v_user IS NULL AND v_pwd IS NULL THEN
        htp.print('<script>window.location.href="/apex/DELPRETE2526.home?msg=campi_mancanti";</script>');
        RETURN;
    ELSIF v_user IS NULL THEN
        htp.print('<script>window.location.href="/apex/DELPRETE2526.home?msg=user_mancante";</script>');
        RETURN;
    ELSIF v_pwd IS NULL THEN
        htp.print('<script>window.location.href="/apex/DELPRETE2526.home?msg=pwd_mancante";</script>');
        RETURN;
    END IF;

    ------------------------------------------------------------------
    -- Login
    ------------------------------------------------------------------
    SELECT IdUtente
    INTO v_idUtente
    FROM CREDENZIALI
    WHERE TRIM(Username) = v_user
      AND Password = v_pwd;

    BEGIN
        SELECT 1 INTO v_admin
        FROM AMMINISTRATIVO
        WHERE IdUtente = v_idUtente;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_admin := 0;
    END;

    BEGIN
        SELECT 1 INTO v_atleta
        FROM ATLETA
        WHERE IdUtente = v_idUtente;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_atleta := 0;
    END;

    BEGIN
        SELECT 1 INTO v_istruttore
        FROM ISTRUTTORE
        WHERE IdUtente = v_idUtente;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_istruttore := 0;
    END;

    BEGIN
        SELECT 1 INTO v_pt
        FROM PERSONAL_TRAINER
        WHERE IdUtente = v_idUtente;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_pt := 0;
    END;

    v_idsessione := seq_sessione.NEXTVAL;

    INSERT INTO SESSIONI (
        IdSessione,
        IsAmministratore,
        IsAtleta,
        IsIstruttore,
        IsPersonalTrainer,
        DataInizio,
        DataFine,
        IdUtente
    )
    VALUES (
        v_idsessione,
        v_admin,
        v_atleta,
        v_istruttore,
        v_pt,
        SYSDATE,
        NULL,
        v_idUtente
    );

    COMMIT;

htp.print('<script>window.location.href="/apex/DELPRETE2526.home?IdSessione=' 
          || v_idsessione 
          || '" + "&" + "msg=login_ok";</script>');
          
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        htp.print('<script>window.location.href="/apex/DELPRETE2526.home?msg=login_errato";</script>');
    WHEN OTHERS THEN
        ROLLBACK;
        htp.print('<script>window.location.href="/apex/DELPRETE2526.home?msg=errore_login";</script>');
END;
/