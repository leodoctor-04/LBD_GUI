CREATE OR REPLACE PACKAGE BODY baseHTML AS

    PROCEDURE apriPagina(titolo IN VARCHAR2 DEFAULT NULL, acceduto IN BOOLEAN DEFAULT false, nome IN VARCHAR2 DEFAULT NULL) IS BEGIN
    htp.htmlOpen;
    htp.headOpen;
        htp.title( titolo );
        htp.print('<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">');
        Stile.stile;
    htp.headClose;

    htp.bodyOpen;
        htp.print('<header>');

        IF acceduto THEN
            htp.p( '<h1 onclick="toggleMenu()" style="cursor: pointer;">☰</h1>' );
            MenuHamburger;
        END IF;

        htp.print('<h1>'|| titolo ||'</h1> <nav>');
        IF acceduto THEN
            htp.p( '<p>' || nome || '</p>');
        ELSE
            htp.p('
                <button onclick="openLogin()">Accedi</button>
                <img src="" alt="icona" onerror="this.src=''https://cdn-icons-png.flaticon.com/512/149/149071.png'';">
                '); --aggiungere icona
            LoginPopup;
        END IF;
            
        htp.print('</nav>
        </header>
        ');
END apriPagina;
    PROCEDURE chiudiPagina IS BEGIN
        htp.print('
            <footer>
            <h1>FitZone</h1>
            <p>&copy; ' || to_char(sysdate, 'YYYY') || ' FitZone. Tutti i diritti riservati</p>
            </footer>
        ');
        
        htp.bodyClose;
        htp.htmlClose;
    END chiudiPagina;

    PROCEDURE apriDiv( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<div');
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF stile IS NOT NULL THEN
            htp.prn( ' style="' || stile || '"' );
        END IF;
        htp.p('>');
        
    END apriDiv;
    PROCEDURE chiudiDiv IS BEGIN
        htp.p('</div>');
    END chiudiDiv;

    PROCEDURE paragrafo( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<p' );
        IF stile IS NOT NULL THEN
            htp.prn( ' style="'|| stile || '"' );
        END IF;
        htp.p(' >' || testo || '</p>');
    END paragrafo;
    PROCEDURE h1( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<h1' );
        IF stile IS NOT NULL THEN
            htp.prn( ' style="'|| stile || '"' );
        END IF;
        htp.p( '>' || testo || '</h1>' );
    END h1;

    PROCEDURE apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<select');
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF stile IS NOT NULL THEN
            htp.prn( ' style="' || stile || '"' );
        END IF;
        htp.p('>');
    END apriMenuTendina;
    PROCEDURE chiudiMenuTendina IS BEGIN
        htp.p('</select>');
    END chiudiMenuTendina;
    PROCEDURE tendinaOption(opzione IN VARCHAR2) IS BEGIN
        htp.p('<option value="' || opzione || '">' || opzione || '</option>');
    END tendinaOption;

    PROCEDURE bottone( testo IN VARCHAR2, onClick IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn( '<button' );
        IF onClick IS NOT NULL THEN
            htp.prn( 'type="button" onclick="' || onClick || '()"');
        END IF;
        htp.p( '>' || testo || '</button>' );
    END bottone;

    PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL) IS BEGIN
        htp.prn('<a ');
        IF pagina IS NOT NULL THEN
            htp.prn( 'href="' || pagina || '"' );
        END IF;
        htp.p( '>' || testo || '</a>' );

    END collegamento;

    PROCEDURE apriModulo( id IN VARCHAR2 DEFAULT NULL, action IN VARCHAR2 DEFAULT NULL, metodo IN BOOLEAN DEFAULT false) IS BEGIN
        htp.prn( '<form' );
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF action IS NOT NULL THEN
            htp.prn( ' action="' || action || '"' );
        END IF;
        IF metodo THEN
            htp.prn( ' method="true"' );
        ELSE
            htp.prn( ' method="false"' );
        END IF;
        htp.p( '>' );

    END apriModulo;
    PROCEDURE chiudiModulo IS BEGIN
        htp.p('</form>');
    END chiudiModulo;
    PROCEDURE inserisciInput(
        id  IN VARCHAR2,
        tipo    IN VARCHAR2 DEFAULT 'text',    -- text, password, email, tel, checkbox, radio, number, hidden, date.
        nome    IN VARCHAR2,    -- il nome per richiamare il campo
        valore  IN VARCHAR2 DEFAULT NULL, 
        placeholder IN VARCHAR2 DEFAULT NULL,
        obbligatorio    IN BOOLEAN  DEFAULT false   -- Aggiunge l'attributo 'required'
    ) IS BEGIN
        htp.p( '<label for="' || id || '">' || nome || '</label>' );
        htp.prn( '<input id="' || id || '" type="' || tipo || '" name="' || nome || '"' );
        IF valore IS NOT NULL THEN
            htp.prn( ' value="' || valore || '"' );
        END IF;
        IF placeholder IS NOT NULL THEN
            IF tipo = 'radio' OR tipo = 'checkbox' THEN
                htp.prn( ' checked' );
            ELSE
                htp.prn( ' placeholder="' || placeholder || '"' );
            END IF;
        END IF;
        IF obbligatorio THEN
            htp.prn( ' required' );
        END IF;

        htp.p( ' >');
    END inserisciInput;
    PROCEDURE inserisciTextArea( testo IN VARCHAR2 ) IS BEGIN
        htp.p( '<textarea>' || testo || '</textarea>' );
    END inserisciTextArea;

    PROCEDURE apriPopup( id IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn( '<dialog ');
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        htp.p(' >');
    END apriPopup;
    PROCEDURE chiudiPopup IS BEGIN
    htp.prn( '</dialog>');
    END chiudiPopup;



    procedure LoginPopup is
    begin
        -- il pop up è inizialmente nascosto
        htp.print('<dialog id="loginPopup" style="display: none;">');

            htp.print('<h1>Login</h1> <br>');

            htp.formOpen( accountutente ||'.baseHTML.loginProc', 'GET');
                htp.print('<p>Username:</p><br>');
                htp.formText('p_user',20);
                htp.br;

                htp.print('<p>Password:</p><br>');
                htp.formPassword('p_pwd',20);
                htp.br;
                htp.br;

                htp.p('<div style="display:flex; gap:0.25vw;">');
                    htp.print('<button type="submit" style="margin:auto;" >Accedi</button>');
                    htp.print('<br><button type="button" onclick="closeLogin()">Chiudi</button>');
                htp.p('</div>');
            htp.p('</div>');
            
            htp.formClose;

        htp.print('</dialog>');
        -- javascript
        htp.print('<script>
            function openLogin() {
                document.getElementById("loginPopup").style.display = "flex";
            }
            function closeLogin() {
                document.getElementById("loginPopup").style.display = "none";
            }
            </script>'
        );
    end;

procedure MessaggioTemporaneo (
    IdMsg        varchar2,
    Testo        varchar2,
    Tipo         varchar2 default 'errore',
    Millisecondi number default 3000
) is
    v_bg        varchar2(30);
    v_text      varchar2(30);
    v_border    varchar2(30);
begin
    ------------------------------------------------------------------
    -- Colori in base al tipo
    ------------------------------------------------------------------
    if lower(Tipo) = 'successo' then
        v_bg     := '#e6ffed';
        v_text   := '#1f7a1f';
        v_border := '#66cc66';
    elsif lower(Tipo) = 'warning' then
        v_bg     := '#fff8e6';
        v_text   := '#996600';
        v_border := '#e6c200';
    else
        -- errore default
        v_bg     := '#f8d7da';
        v_text   := '#842029';
        v_border := '#f1aeb5';
    end if;

    ------------------------------------------------------------------
    -- Banner
    ------------------------------------------------------------------
    htp.print('<div id="' || IdMsg || '" style="
        position:fixed;
        bottom:20px;
        left:50%;
        transform:translateX(-50%);
        min-width:280px;
        max-width:500px;
        padding:14px 18px;
        background:' || v_bg || ';
        color:' || v_text || ';
        border:1px solid ' || v_border || ';
        border-radius:14px;
        box-shadow:0 4px 12px rgba(0,0,0,0.2);
        z-index:3000;
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:15px;
        font-family:Arial, sans-serif;
    ">');

    -- Testo messaggio
    htp.print('<span>' || Testo || '</span>');

    -- Pulsante chiudi
    htp.print('<button type="button" onclick="document.getElementById(''' || IdMsg || ''').style.display=''none'';" style="
        background:transparent;
        border:none;
        color:' || v_text || ';
        font-size:18px;
        font-weight:bold;
        cursor:pointer;
        line-height:1;
    ">×</button>');

    htp.print('</div>');

    ------------------------------------------------------------------
    -- Auto-hide
    ------------------------------------------------------------------
    htp.print('<script>
        setTimeout(function() {
            var el = document.getElementById("' || IdMsg || '");
            if (el) {
                el.style.display = "none";
            }
        }, ' || Millisecondi || ');
    </script>');
end;

    procedure StatCard (
        Titolo      varchar2,
        Valore      varchar2,
        Descrizione varchar2 default null
    ) is
    begin
        htp.print('<div style="
            background:white;
            border-radius:22px;
            padding:26px 24px;
            box-shadow:0 6px 18px rgba(0,0,0,0.10);
            border:1px solid #e8e8e8;
            min-height:170px;
            display:flex;
            flex-direction:column;
            justify-content:center;
            text-align:center;
        ">');

        htp.print('<div style="
            font-size:20px;
            font-weight:800;
            color:#0f3fb8;
            margin-bottom:14px;
        ">' || Titolo || '</div>');

        htp.print('<div style="
            font-size:42px;
            font-weight:900;
            color:#111;
            margin-bottom:10px;
        ">' || Valore || '</div>');

        if Descrizione is not null then
            htp.print('<div style="
                font-size:15px;
                color:#666;
                line-height:1.5;
            ">' || Descrizione || '</div>');
        end if;

        htp.print('</div>');
    end;


    
-- MENU HAMBURGER
-- considerare tabella pagine per modifiche dinamiche
procedure MenuHamburger is begin
-- SIDEBAR
htp.print('<div id="sidebar">');

htp.print('<h3>Menu</h3>');

MenuButton('Abbonamento', root ||'pagina_abbonamento');
MenuButton('Corsi', root || 'pagina_corsi');
MenuButton('Calendario lezioni', root || 'calendario');
MenuButton('Crea Corso', root || 'crea_corso');
MenuButton('Crea Abbonamento', root || 'crea_abbonamento');
MenuButton('Statistiche Palestra', root || 'statistiche');

htp.print('</div>');

-- OVERLAY
htp.print('<div id="overlay" onclick="toggleMenu()" style="
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.3);
    display:none;
    z-index:998;
"></div>');

-- SCRIPT
htp.print('<script>
function toggleMenu() {
    var menu = document.getElementById("sidebar");
    var overlay = document.getElementById("overlay");

    if (menu.style.transform === "translateX(0px)") {
        menu.style.transform = "translateX(-100%)";
        overlay.style.display = "none";
    } else {
        menu.style.transform = "translateX(0)";
        overlay.style.display = "block";
    }
}
</script>');

end;

-- MENU BUTTON
procedure MenuButton (
    Testo varchar2,
    Link varchar2,
    Colore varchar2 default 'black'
) is
begin
    htp.print('<a href="' || Link || '" style="
        display:block;
        margin:10px 0;
        padding:12px;
        border-radius:10px;
        text-decoration:none;
        color:' || Colore || ';
        background:white;
        border:1px solid #ccc;
        font-weight:bold;
    ">' || Testo || '</a>');
end;

PROCEDURE loginProc (
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
        htp.print('<script>window.location.href="' || root || 'GUI.home?msg=campi_mancanti";</script>');
        RETURN;
    ELSIF v_user IS NULL THEN
        htp.print('<script>window.location.href="' || root || 'GUI.home?msg=user_mancante";</script>');
        RETURN;
    ELSIF v_pwd IS NULL THEN
        htp.print('<script>window.location.href="' || root || 'GUI.home?msg=pwd_mancante";</script>');
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

htp.print('<script>window.location.href="' || root || 'GUI.home?IdSessione=' 
          || v_idsessione 
          || '" + "&" + "msg=login_ok";</script>');
          
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        htp.print('<script>window.location.href="' || root || 'GUI.home?msg=login_errato";</script>');
    WHEN OTHERS THEN
        ROLLBACK;
        htp.print('<script>window.location.href="' || root || 'GUI.home?msg=errore_login";</script>');
END;

PROCEDURE messaggioLogin( msg IN VARCHAR2) IS BEGIN
    IF msg IS NOT NULL THEN
        IF msg = 'login_errato' THEN
            baseHTML.MessaggioTemporaneo(
                'msg_login_errato',
                'Login errato',
                'errore',
                3000
            );
        ELSIF msg = 'user_mancante' THEN
            baseHTML.MessaggioTemporaneo(
                'msg_user_mancante',
                'Nome utente mancante',
                'warning',
                3000
            );
        ELSIF msg = 'pwd_mancante' THEN
            baseHTML.MessaggioTemporaneo(
                'msg_pwd_mancante',
                'Password mancante',
                'warning',
                3000
            );
        ELSIF msg = 'campi_mancanti' THEN
            baseHTML.MessaggioTemporaneo(
                'msg_campi_mancanti',
                'Nome utente e password mancanti',
                'warning',
                3000
            );
        ELSIF msg = 'errore_login' THEN
            baseHTML.MessaggioTemporaneo(
                'msg_errore_login',
                'Errore durante il login',
                'errore',
                3000
            );
        ELSIF msg = 'login_ok' THEN
            baseHTML.MessaggioTemporaneo(
                'msg_login_ok',
                'Login effettuato con successo',
                'successo',
                3000
            );
        END IF;
    END IF;
END messaggioLogin;

END baseHTML;