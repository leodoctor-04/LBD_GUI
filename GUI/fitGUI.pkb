create or replace PACKAGE BODY fitGUI AS

-- PAGINA
procedure ApriPagina (Titolo varchar2 default 'FitZone') is
begin
    htp.htmlOpen;
    htp.headOpen;
    htp.title(Titolo);
    htp.headClose;
    htp.bodyOpen;
end;

procedure ChiudiPagina is
begin
    htp.bodyClose;
    htp.htmlClose;
end;

-- HEADER
procedure Header (
    NomeSito varchar2 default 'FitZone',
    Loggato boolean default false,
    NomeUtente varchar2 default null
) is
begin
    htp.print('<div style="
        display:flex;
        align-items:center;
        justify-content:space-between;
        padding:10px 20px;
    ">');

    ------------------------------------------------------------------
    -- 🔹 SINISTRA
    ------------------------------------------------------------------
    htp.print('<div style="display:flex; align-items:center; gap:15px;">');

    -- HAMBURGER SOLO SE LOGGATO
    if Loggato then
        htp.print('<div onclick="toggleMenu()" style="
            font-size:28px;
            cursor:pointer;
        ">☰</div>');
    end if;

    -- NOME SITO
    htp.print('<h2 style="margin:0;">' || NomeSito || '</h2>');

    htp.print('</div>');

    ------------------------------------------------------------------
    -- 🔹 DESTRA
    ------------------------------------------------------------------
    if Loggato then
        -- UTENTE LOGGATO
        htp.print('<div style="display:flex; align-items:center; gap:10px;">');

        htp.print('<span>' || NomeUtente || '</span>');

        htp.print('<a href="/apex/DELPRETE2526.profilo">');
        htp.print('<div style="
            width:35px;
            height:35px;
            border-radius:50%;
            background:#ccc;
            display:flex;
            align-items:center;
            justify-content:center;
        ">👤</div>');
        htp.print('</a>');

        htp.print('</div>');

    else
        -- GUEST → ACCEDI
        htp.print('<button onclick="openLogin()" style="
            padding:8px 16px;
            border-radius:10px;
            border:none;
            background:#007BFF;
            color:white;
            font-weight:bold;
            cursor:pointer;
        ">Accedi</button>');
    end if;

    htp.print('</div>');
    htp.hr;

end;

-- LAYOUT
procedure ApriLayout is
begin
    htp.print('<div style="display:flex;">');
end;

procedure ChiudiLayout is
begin
    htp.print('</div>');
end;

-- CONTENUTO
procedure Contenuto is
begin
    htp.print('<div style="flex:1; padding:20px;">');
end;

procedure ChiudiContenuto is
begin
    htp.print('</div>');
end;

-- SEZIONI
procedure ApriSezione (Titolo varchar2) is
begin
    htp.print('<h3>' || Titolo || '</h3>');
    htp.print('<div style="border:1px solid black; padding:20px; margin-bottom:20px;">');
end;

procedure ChiudiSezione is
begin
    htp.print('</div>');
end;

-- CARD
procedure Card (Testo varchar2) is
begin
    htp.print('<div style="border:1px solid black; border-radius:15px; padding:40px; margin:10px;">');
    htp.print(Testo);
    htp.print('</div>');
end;

-- LISTA
procedure ApriLista is
begin
    htp.print('<div style="max-height:200px; overflow-y:scroll;">');
end;

procedure ChiudiLista is
begin
    htp.print('</div>');
end;

-- CORSI
procedure RigaCorso (
    Nome varchar2,
    Tipo varchar2,
    Durata varchar2
) is
begin
    htp.print('<div style="border:1px solid black; margin:5px; padding:10px;">');
    htp.print(Nome || ' Tipo:' || Tipo || ' Durata:' || Durata);
    htp.print('</div>');
end;

procedure CorsoCard (
    Nome varchar2,
    Colore varchar2 default '#ADD8E6'
) is
begin
    htp.print('<div style="background:'||Colore||'; border-radius:10px; padding:10px; margin:5px;">');
    htp.print(Nome);
    htp.print('</div>');
end;

-- BOX INFO
procedure BoxInfo (Titolo varchar2) is
begin
    htp.print('<div style="border:1px solid black; border-radius:15px; padding:15px; margin-bottom:15px;">');
    htp.print('<h4>'||Titolo||'</h4>');
end;

procedure RigaInfo (Etichetta varchar2, Valore varchar2) is
begin
    htp.print('<p><b>'||Etichetta||':</b> '||Valore||'</p>');
end;

procedure ChiudiBoxInfo is
begin
    htp.print('</div>');
end;

-- BOTTONI
procedure Bottone (
    Etichetta varchar2,
    Azione varchar2
) is
begin
    htp.print('<form action="' || Azione || '" method="GET">');
    htp.formSubmit(Etichetta);
    htp.formClose;
end;

-- SELECT
procedure SelectBase (Nome varchar2) is
begin
    htp.formSelectOpen(Nome);
end;

procedure SelectOption (Valore varchar2, Etichetta varchar2) is
begin
    htp.formSelectOption(Etichetta, null, 'value="' || Valore || '"');
end;

procedure ChiudiSelect is
begin
    htp.formSelectClose;
end;

-- SEARCH
procedure SearchBar (Nome varchar2) is
begin
    htp.formOpen('', 'GET');
    htp.print('<input type="text" name="'||Nome||'" placeholder="search">');
    htp.formSubmit('Cerca');
    htp.formClose;
end;

-- MENU BUTTON
procedure MenuButton (
    Testo varchar2,
    Link varchar2,
    Colore varchar2 default 'black'
) is
begin
    htp.print('<a href="'||Link||'" style="
        display:block;
        margin:10px 0;
        padding:12px;
        border-radius:10px;
        text-decoration:none;
        color:'||Colore||';
        background:white;
        border:1px solid #ccc;
        font-weight:bold;
    ">'||Testo||'</a>');
end;

-- MENU HAMBURGER
procedure MenuHamburger is
begin

-- SIDEBAR
htp.print('<div id="sidebar" style="
    position:fixed;
    top:0;
    left:0;
    width:250px;
    height:100%;
    background:#f0f0f0;
    padding:20px;
    transform:translateX(-100%);
    transition:transform 0.3s ease;
    z-index:999;
    box-shadow:2px 0px 5px rgba(0,0,0,0.3);
">');

htp.print('<h3>Menu</h3>');

MenuButton('Abbonamento','/apex/DELPRETE2526.pagina_abbonamento');
MenuButton('Corsi','/apex/DELPRETE2526.pagina_corsi');
MenuButton('Calendario lezioni','/apex/DELPRETE2526.calendario');
MenuButton('Crea Corso','/apex/DELPRETE2526.crea_corso','blue');
MenuButton('Crea Abbonamento','/apex/DELPRETE2526.crea_abbonamento','red');
MenuButton('Statistiche Palestra','/apex/DELPRETE2526.crea_abbonamento','red');


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

procedure LoginPopup is
begin

-- OVERLAY
htp.print('<div id="loginOverlay" style="
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
    display:none;
    justify-content:center;
    align-items:center;
    z-index:1000;
">');

-- BOX LOGIN
htp.print('<div style="
    background:white;
    padding:30px;
    border-radius:15px;
    width:300px;
    text-align:center;
">');

htp.print('<h3>Login</h3>');

htp.formOpen('/apex/DELPRETE2526.fitGUI.login_proc_web','GET');

htp.print('Username:<br>');
htp.formText('p_user',20);
htp.br;

htp.print('Password:<br>');
htp.formPassword('p_pwd',20);
htp.br; htp.br;

htp.formSubmit('Accedi');

htp.formClose;

-- bottone chiudi
htp.print('<br><button onclick="closeLogin()">Chiudi</button>');

htp.print('</div>');
htp.print('</div>');

-- SCRIPT
htp.print('
<script>
function openLogin() {
    document.getElementById("loginOverlay").style.display = "flex";
}
function closeLogin() {
    document.getElementById("loginOverlay").style.display = "none";
}
</script>
');
end;

procedure BottoneLogin is
begin
    htp.print('<button onclick="openLogin()" style="
        padding:10px 20px;
        border-radius:10px;
        cursor:pointer;
    ">Accedi</button>');
end;

procedure ping IS
begin
    htp.p('PING OK');
end;

PROCEDURE login_proc_web (
    p_user IN VARCHAR2,
    p_pwd  IN VARCHAR2
) IS
    v_idsessione NUMBER;
BEGIN
    login_proc(
        p_user       => p_user,
        p_pwd        => p_pwd,
        p_idsessione => v_idsessione
    );

    IF v_idsessione IS NOT NULL THEN
        htp.p('LOGIN OK - SESSIONE=' || v_idsessione);
    ELSE
        htp.p('LOGIN FALLITO');
    END IF;
END;




END fitGUI;
