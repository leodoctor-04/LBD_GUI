CREATE OR REPLACE PACKAGE BODY fitGUI AS

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
        padding:18px 28px;
        background:linear-gradient(90deg, #1e5eff 0%, #0f3fb8 45%, #000000 100%);
        color:white;
        box-shadow:0 3px 10px rgba(0,0,0,0.25);
    ">');

    htp.print('<div style="display:flex; align-items:center; gap:15px;">');

    if Loggato then
        htp.print('<div onclick="toggleMenu()" style="
            font-size:28px;
            cursor:pointer;
            color:white;
        ">☰</div>');
    end if;

    htp.print('<h2 style="
        margin:0;
        font-size:38px;
        font-weight:800;
        letter-spacing:0.5px;
        color:white;
    ">' || NomeSito || '</h2>');

    htp.print('</div>');

    if Loggato then
        htp.print('<div style="display:flex; align-items:center; gap:12px;">');
        htp.print('<span style="font-weight:600;">' || NomeUtente || '</span>');

        htp.print('<a href="/apex/DELPRETE2526.profilo" style="text-decoration:none;">');
        htp.print('<div style="
            width:38px;
            height:38px;
            border-radius:50%;
            background:white;
            color:black;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:18px;
            font-weight:bold;
        ">👤</div>');
        htp.print('</a>');

        htp.print('</div>');
    else
        htp.print('<button onclick="openLogin()" style="
            padding:10px 18px;
            border-radius:12px;
            border:none;
            background:white;
            color:#0f3fb8;
            font-weight:700;
            cursor:pointer;
            box-shadow:0 2px 8px rgba(0,0,0,0.18);
        ">Accedi</button>');
    end if;

    htp.print('</div>');
end;

-- MENU HAMBURGER
-- considerare tabella pagine per modifiche dinamiche
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
MenuButton('Crea Corso','/apex/DELPRETE2526.crea_corso');
MenuButton('Crea Abbonamento','/apex/DELPRETE2526.crea_abbonamento');
MenuButton('Statistiche Palestra','/apex/DELPRETE2526.statistiche');


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

-- Dialog???????????
procedure LoginPopup is
begin
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

    htp.print('<div style="
        background:white;
        padding:30px;
        border-radius:15px;
        width:300px;
        text-align:center;
    ">');

    htp.print('<h3>Login</h3>');

    htp.formOpen('DELPRETE2526.login_proc', 'GET');

    htp.print('Username:<br>');
    htp.formText('p_user',20);
    htp.br;

    htp.print('Password:<br>');
    htp.formPassword('p_pwd',20);
    htp.br; 
    htp.br;

    htp.print('<button type="submit">Accedi</button>');
    htp.formClose;

    htp.print('<br><button type="button" onclick="closeLogin()">Chiudi</button>');

    htp.print('</div>');
    htp.print('</div>');

    htp.print('<script>
function openLogin() {
    document.getElementById("loginOverlay").style.display = "flex";
}
function closeLogin() {
    document.getElementById("loginOverlay").style.display = "none";
}
</script>');
end;
--????????????
procedure BottoneLogin is
begin
    htp.print('<button onclick="openLogin()" style="
        padding:10px 20px;
        border-radius:10px;
        cursor:pointer;
    ">Accedi</button>');
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

END fitGUI;