create or replace PACKAGE BODY COMPONENTI as

procedure LoginPopup is
    begin
        -- il pop up è inizialmente nascosto
        htp.print('<dialog id="loginPopup" style="display: none;">');

            htp.print('<h1>Login</h1> <br>');

            htp.formOpen( global.accountutente ||'.loginproc', 'GET');
                htp.print('<p>Username:</p><br>');
                htp.formText('p_username',20);
                htp.br;

                htp.print('<p>Password:</p><br>');
                htp.formPassword('p_password',20);
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
) IS
BEGIN
    htp.p('
        <div style="
            background:#1f1f1f;
            border:1.5px solid #8fd400;
            border-radius:24px;
            padding:30px 25px;
            min-height:200px;
            box-shadow:0 6px 18px rgba(0,0,0,0.35);
            display:flex;
            flex-direction:column;
            justify-content:center;
            align-items:center;
            text-align:center;
        ">
            <h3 style="
                margin:0 0 20px 0;
                color:#a6e22e;
                font-size:20px;
            ">' || Titolo || '</h3>

            <div style="
                margin-bottom:18px;
                color:white;
                font-size:48px;
                font-weight:bold;
            ">' || Valore || '</div>

            <p style="
                margin:0;
                color:#cfcfcf;
                font-size:16px;
                line-height:1.4;
            ">' || Descrizione || '</p>
        </div>
    ');
END;

PROCEDURE CardLink (
    Titolo      IN VARCHAR2,
    Valore      IN VARCHAR2,
    Descrizione IN VARCHAR2 DEFAULT NULL,
    Link        IN VARCHAR2 DEFAULT '#' --deafult vaule == link cliccabile che non ti porta da nessuna parte
) IS
BEGIN
    htp.p('
        <a href="' || Link || '" style="
            text-decoration:none;
            color:inherit;
            background:#1f1f1f;
            border:1.5px solid #8fd400;
            border-radius:24px;
            padding:34px 28px;
            min-height:200px;
            box-shadow:0 6px 18px rgba(0,0,0,0.35);
            display:flex;
            flex-direction:column;
            justify-content:center;
            align-items:center;
            text-align:center;
            cursor:pointer;
            transition:transform 0.2s ease, box-shadow 0.2s ease;
        "
        onmouseover="
            this.style.transform=''translateY(-6px)'';
            this.style.boxShadow=''0 10px 28px rgba(143,212,0,0.35)'';
        "
        onmouseout="
            this.style.transform=''translateY(0)'';
            this.style.boxShadow=''0 6px 18px rgba(0,0,0,0.35)'';
        ">

            <div style="
                color:#a6e22e;
                font-size:42px;
                font-weight:bold;
                margin-bottom:14px;
            ">' || Valore || '</div>

            <p style="
                margin:0;
                color:#cfcfcf;
                font-size:16px;
            ">' || Descrizione || '</p>

        </a>
    ');
END;

procedure MenuHamburger (
    p_idSessione IN NUMBER
) is
    v_idUtente SESSIONI.IdUtente%TYPE;
    v_isPT NUMBER := 0;
    v_isIstruttore NUMBER := 0;
    v_isAmministrativo NUMBER := 0;
begin
    -- Recupero utente dalla sessione
    begin
        select IdUtente
        into v_idUtente
        from SESSIONI
        where IdSessione = p_idSessione;
    exception
        when no_data_found then
            v_idUtente := null;
    end;

    -- Controllo se è personal tranier/istruttore/amministrativo
    if v_idUtente is not null then
        select count(*)
        into v_isPT
        from personal_trainer
        where IdUtente = v_idUtente;
    
        select count(*)
        into v_isIstruttore
        from ISTRUTTORE
        where IdUtente = v_idUtente;

        select count(*)
        into v_isAmministrativo
        from AMMINISTRATIVO
        where IdUtente = v_idUtente;
    end if;

    -- SIDEBAR
    htp.print('<div id="sidebar">');

    htp.print('<h3>Menu</h3>');

    -- Menu visibile agli atleti / base
    MenuButton('Home',                global.root || 'home',                  p_idSessione);
    MenuButton('I Tuoi Corsi',         global.root || 'TuoiCorsi',             p_idSessione);
    MenuButton('Calendario Lezioni',   global.root || 'calendario',            p_idSessione);
    MenuButton('Partecipazioni',          global.root || 'gabrielli.visualizzaPartecipazioni',    p_idSessione);
    MenuButton('Iscrizioni',          global.root || 'gabrielli.visualizzaIscrizioni',    p_idSessione);

    MenuButton('Abbonamento',          global.root || 'pagina_abbonamento.visualizza',    p_idSessione);

    -- Se è amministrativo
    if v_isAmministrativo > 0 then
        MenuButton('Area Amministrativo', global.root || 'areaGestionale', p_idSessione);

    -- Se è istruttore
    elsif v_isIstruttore > 0 then
        MenuButton('Area Istruttore', global.root || 'areaGestionale', p_idSessione);
    -- Se è PT    
    elsif v_isPT > 0 then
        MenuButton('Area Persona Trainer', global.root || 'areaGestionale', p_idSessione);
    end if;

    MenuButton('Logout', global.root || 'sessioneUtente.logout', p_idSessione);

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

    if (menu.style.transform === "translateX(0px)" || menu.style.transform === "translateX(0%)" || menu.style.transform === "translateX(0)") {
        menu.style.transform = "translateX(-100%)";
        overlay.style.display = "none";
    } else {
        menu.style.transform = "translateX(0)";
        overlay.style.display = "block";
    }
}
</script>');

end;

procedure MenuButton (
    Testo       IN varchar2,
    Link        IN varchar2,
    p_idSessione IN NUMBER,
    Colore      IN varchar2 default 'black'
) is
    v_link varchar2(4000);
begin
    if p_idSessione is not null then
        v_link := Link || '?p_idSessione=' || p_idSessione;
    else
        v_link := Link;
    end if;

    htp.print('<a href="' || v_link || '" style="
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

PROCEDURE messaggioLogin( msg IN VARCHAR2) IS BEGIN
    IF msg IS NOT NULL THEN
        IF msg = 'login_errato' THEN
            MessaggioTemporaneo(
                'msg_login_errato',
                'Login errato',
                'errore',
                3000
            );
        ELSIF msg = 'user_mancante' THEN
            MessaggioTemporaneo(
                'msg_user_mancante',
                'Nome utente mancante',
                'warning',
                3000
            );
        ELSIF msg = 'pwd_mancante' THEN
            MessaggioTemporaneo(
                'msg_pwd_mancante',
                'Password mancante',
                'warning',
                3000
            );
        ELSIF msg = 'campi_mancanti' THEN
            MessaggioTemporaneo(
                'msg_campi_mancanti',
                'Nome utente e password mancanti',
                'warning',
                3000
            );
        ELSIF msg = 'errore_login' THEN
            MessaggioTemporaneo(
                'msg_errore_login',
                'Errore durante il login',
                'errore',
                3000
            );
        ELSIF msg = 'sessione_scaduta' THEN
            MessaggioTemporaneo(
                'msg_sessione_scaduta',
                'Sessione Scaduta',
                'errore',
                3000
            );
        ELSIF msg = 'login_ok' THEN
            MessaggioTemporaneo(
                'msg_login_ok',
                'Login effettuato con successo',
                'successo',
                3000
            );
        ELSIF msg = 'no_permessi' THEN
            MessaggioTemporaneo(
                'msg_no_permessi',
                'Accesso negato: permessi mancanti',
                'errore',
                3000
            );
        ELSIF msg = 'no_target' THEN
            MessaggioTemporaneo(
                'msg_no_target',
                'Elemento riferito non esistente',
                'errore',
                3000
            );
        ELSIF msg = 'errore_generale' THEN
            MessaggioTemporaneo(
                'msg_errore_generale',
                'Errore non previsto o gestito',
                'errore',
                3000
            );
        END IF;
    END IF;
END messaggioLogin;

END Componenti;