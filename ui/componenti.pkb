create or replace package body Componenti as

PROCEDURE calendar(startDate IN DATE) is
    nextLun Date;
BEGIN
    nextLun := NEXT_DAY(startDate-7, 'MONDAY');
    
    --body
    htp.print(
        utl_lms.format_message('
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <div class="calendar">
            <div class ="control_panel">
                <button onclick="prev_week()"><i class="material-icons">arrow_back_ios</i></button>
                <p id="date_label"> %s -- %s</p>
                <button onclick="next_week()"><i class="material-icons">arrow_forward_ios</i></button>
            </div>
            <p class="day_label" style="">lunedi</p>
            <p class="day_label" style="">martedi</p>
            <p class="day_label" style="">mercoledi</p>
            <p class="day_label" style="">giovedi</p>
            <p class="day_label" style="">venerdi</p>
            
            <div class="lesson_column" id="lun_clm">
            </div>
            <div class="lesson_column" id="mar_clm"></div>
            <div class="lesson_column" id="mer_clm"></div>
            <div class="lesson_column" id="gio_clm"></div>
            <div class="lesson_column" id="ven_clm"></div>
        </div>
        '
        , TO_CHAR(nextLun, 'DD mon')
        , TO_CHAR(nextLun+7, 'DD mon')

        )
    );

    --script
    htp.print(
        utl_lms.format_message('
        <script>
            function check_inside(position,elem){
                let bounds = elem.getBoundingClientRect();
                return false; 
            }

            function create_lesson(isTeacher,course,teacher,start,end){
                let body = document.createElement("div");
                body.setAttribute("class",`lesson ${isTeacher? "teach" : "attend"}`);
                body.setAttribute("style",`background-color: ${isTeacher? "#ffc7d1" : "#c3edd5"}`);
                
                body.innerHTML = `
                    <p style="font-size: 2vw;grid-column: span 2;">${course}</p>
                    <p style="font-size: 1.7vw;">start: ${start}</p>
                    <p style="font-size: 1.7vw;">end: ${end}</p>

                    <dialog class="lesson_popup" style=" background:${isTeacher? "#ffc7d1" : "#c3edd5"}">
                        <p>corso: </p><a href="" style="grid-column: span 2;">${course}</a> 
                        <p>istruttore: </p><a href="" style="grid-column: span 2;">${teacher}</a>  

                        <p>start: ${start}</p>
                        <p></p>
                        <p>end: ${start}</p>
                    </dialog>
                `;
                return body;
            }

            function clear_calendar(){
                console.log("hi");
                var columns = document.getElementsByClassName("lesson_column");

                for(c of columns){
                    c.innerHTML = "";
                }
            }
            function next_week(){
            }

            function prev_week(){
            }
            //upadate_datelabel()
            document.getElementById("lun_clm").appendChild(create_lesson(true,"corsoB","paolino","12:00","13:00"));
            document.getElementById("lun_clm").appendChild(create_lesson(false,"corsoB","paolino","12:00","13:00"));
 
            for(less of document.getElementsByClassName("lesson")){
                less.addEventListener("click", function (event) {
                    console.log("hi clicked")
                    event.currentTarget.children[3].showModal();
                });
            }

            console.log("hi from pl/sql");
        </script>        
        '
        , TO_CHAR(nextLun, 'YYYY,MM,DD')
        )
    );

END;
PROCEDURE lesson(isTeacher BOOLEAN,course VARCHAR, teacher VARCHAR, startH VARCHAR , endH VARCHAR) is
    bg_color VARCHAR(8);
BEGIN
    bg_color := case when isTeacher then '#ffc7d1' else '#c3edd5' end;

    htp.print(
        utl_lms.format_message(
        '
        <div class="lesson" onclick="this.children[3].showModal();">
            <p style="font-size: 2vw;grid-column: span 2;">%s</p>
            <p style="font-size: 1.7vw;">start: %s</p>
            <p style="font-size: 1.7vw;">end: %s</p>

            <dialog class="lesson_popup" style=" background:%s">
                <p>corso: </p><a href="" style="grid-column: span 2;">%s</a> 
                <p>istruttore: </p><a href="" style="grid-column: span 2;">%s</a>  

                <p>start: %s</p>
                <p></p>
                <p>end: %s</p>
            </dialog>
        </div>

        ',course,startH,endH,bg_color,course,teacher,startH,endH)
    );
END;
procedure LoginPopup is
    begin
        -- il pop up è inizialmente nascosto
        htp.print('<dialog id="loginPopup" style="display: none;">');

            htp.print('<h1>Login</h1> <br>');

            htp.formOpen( accountutente ||'.Componenti.loginProc', 'GET');
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
procedure MenuHamburger is begin
    -- SIDEBAR
    htp.print('<div id="sidebar">');

    htp.print('<h3>Menu</h3>');

    -- sidebar buttons
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
        ELSIF msg = 'login_ok' THEN
            MessaggioTemporaneo(
                'msg_login_ok',
                'Login effettuato con successo',
                'successo',
                3000
            );
        END IF;
    END IF;
END messaggioLogin;



procedure listaCorsi( numero IN number DEFAULT NULL ) is
begin
    if numero is null then
        FOR corso IN ( SELECT titolo FROM Corso )
        LOOP
            baseHTML.paragrafo( corso.titolo );
        END LOOP;
    else
        FOR corso IN ( SELECT titolo FROM Corso fetch first numero rows only)
        LOOP
            baseHTML.paragrafo( corso.titolo );
        END LOOP;
    end if;
end listaCorsi;

END Componenti;