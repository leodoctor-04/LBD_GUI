CREATE OR REPLACE PACKAGE fitGUI AS

-- Pagina
procedure ApriPagina (Titolo varchar2 default 'FitZone');
procedure ChiudiPagina;

-- Header
procedure Header (
    NomeSito varchar2 default 'FitZone',
    Loggato boolean default false,
    NomeUtente varchar2 default null
);
-- Layout
procedure ApriLayout;
procedure ChiudiLayout;

-- Contenuto
procedure Contenuto;
procedure ChiudiContenuto;

-- Sezioni
procedure ApriSezione (Titolo varchar2);
procedure ChiudiSezione;

-- Card
procedure Card (Testo varchar2);

-- Lista
procedure ApriLista;
procedure ChiudiLista;

-- Corsi
procedure RigaCorso (
    Nome varchar2,
    Tipo varchar2,
    Durata varchar2
);

procedure CorsoCard (
    Nome varchar2,
    Colore varchar2 default '#ADD8E6'
);

-- Box info
procedure BoxInfo (Titolo varchar2);
procedure RigaInfo (Etichetta varchar2, Valore varchar2);
procedure ChiudiBoxInfo;

-- Bottoni
procedure Bottone (
    Etichetta varchar2,
    Azione varchar2
);

-- Select
procedure SelectBase (Nome varchar2);
procedure SelectOption (Valore varchar2, Etichetta varchar2);
procedure ChiudiSelect;

-- Search
procedure SearchBar (Nome varchar2);

-- Login
procedure LoginPopup;
procedure BottoneLogin;

-- NUOVI
procedure MenuHamburger;
procedure MenuButton (
    Testo varchar2,
    Link varchar2,
    Colore varchar2 default 'black'
);

procedure ping;

procedure MessaggioTemporaneo (
    IdMsg        varchar2,
    Testo        varchar2,
    Tipo         varchar2 default 'errore',
    Millisecondi number default 3000
);

procedure HeroLanding;

procedure MiglioriCorsiLanding;

procedure StatCard (
    Titolo      varchar2,
    Valore      varchar2,
    Descrizione varchar2 default null
);

procedure ApriGriglia (Colonne number default 3);
procedure ChiudiGriglia;

procedure ApriContenitore (Padding varchar2 default '30px');
procedure ChiudiContenitore;

procedure TitoloSezione (
    Titolo      varchar2,
    Sottotitolo varchar2 default null
);

END fitGUI;
/


CREATE OR REPLACE PACKAGE BODY fitGUI AS

-- PAGINA
procedure ApriPagina (Titolo varchar2 default 'FitZone') is
begin
    htp.htmlOpen;
    htp.headOpen;
    htp.title(Titolo);
    htp.headClose;
    htp.print('<body style="
        margin:0;
        font-family:Arial, Helvetica, sans-serif;
        background:#f6f8fc;
    ">');
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

procedure HeroLanding is
begin
    htp.print('<div style="
        display:flex;
        gap:30px;
        padding:35px 40px 20px 40px;
        align-items:stretch;
    ">');

    ------------------------------------------------------------------
    -- BOX CHI SIAMO
    ------------------------------------------------------------------
    htp.print('<div style="
        flex:1.4;
        background:white;
        border-radius:24px;
        padding:35px 30px;
        box-shadow:0 6px 18px rgba(0,0,0,0.10);
        border:1px solid #e6e6e6;
        min-height:220px;
        display:flex;
        flex-direction:column;
        justify-content:center;
        text-align:center;
    ">');

    htp.print('<div style="
        font-size:30px;
        font-weight:800;
        color:#0f3fb8;
        margin-bottom:18px;
    ">Chi siamo</div>');

    htp.print('<div style="
        font-size:18px;
        line-height:1.6;
        color:#333333;
        max-width:700px;
        margin:0 auto;
    ">
        FitZone è la palestra ideale per chi vuole superare i propri limiti,
        allenarsi in un ambiente moderno e trovare ogni giorno l’energia giusta
        per stare bene e migliorarsi.
    </div>');

    htp.print('</div>');

    ------------------------------------------------------------------
    -- BOX DOVE SIAMO / IMMAGINE
    ------------------------------------------------------------------
    htp.print('<div style="
        flex:1;
        background:white;
        border-radius:24px;
        padding:25px;
        box-shadow:0 6px 18px rgba(0,0,0,0.10);
        border:1px solid #e6e6e6;
        min-height:220px;
        display:flex;
        flex-direction:column;
        align-items:center;
        justify-content:center;
        text-align:center;
    ">');

    htp.print('<div style="
        font-size:28px;
        font-weight:800;
        color:#0f3fb8;
        margin-bottom:15px;
    ">Dove siamo</div>');

    htp.print('<div style="
        width:220px;
        height:120px;
        border-radius:18px;
        background:#f1f4fb;
        border:2px dashed #9bb3ff;
        display:flex;
        align-items:center;
        justify-content:center;
        color:#5b6b8a;
        font-size:15px;
        margin-bottom:12px;
    ">
        Immagine sede
    </div>');

    htp.print('<div style="
        font-size:18px;
        font-weight:600;
        color:#333;
    ">Pisa</div>');

    htp.print('</div>');

    htp.print('</div>');
end;

procedure MiglioriCorsiLanding is
begin
    htp.print('<div style="
        padding:20px 40px 40px 40px;
    ">');

    htp.print('<div style="
        text-align:center;
        margin-bottom:30px;
    ">');

    htp.print('<div style="
        font-size:32px;
        font-weight:800;
        color:#111;
        margin-bottom:8px;
    ">I nostri migliori corsi</div>');

    htp.print('<div style="
        font-size:18px;
        color:#666;
    ">I corsi più amati dai nostri clienti</div>');

    htp.print('</div>');

    htp.print('<div style="
        display:grid;
        grid-template-columns:repeat(3, 1fr);
        gap:24px;
    ">');

    ------------------------------------------------------------------
    -- CARD CORSO 1
    ------------------------------------------------------------------
    htp.print('<div style="
        background:white;
        border-radius:24px;
        padding:22px;
        box-shadow:0 6px 18px rgba(0,0,0,0.10);
        border:1px solid #e8e8e8;
        display:flex;
        flex-direction:column;
        align-items:center;
    ">');

    htp.print('<div style="
        width:140px;
        height:140px;
        border-radius:20px;
        background:#eef3ff;
        border:2px dashed #9bb3ff;
        display:flex;
        align-items:center;
        justify-content:center;
        color:#5b6b8a;
        margin-bottom:14px;
    ">Immagine</div>');

    htp.print('<div style="
        font-size:22px;
        font-weight:700;
        color:#0f3fb8;
        text-align:center;
    ">Yoga Flow</div>');

    htp.print('</div>');

    ------------------------------------------------------------------
    -- CARD CORSO 2
    ------------------------------------------------------------------
    htp.print('<div style="
        background:white;
        border-radius:24px;
        padding:22px;
        box-shadow:0 6px 18px rgba(0,0,0,0.10);
        border:1px solid #e8e8e8;
        display:flex;
        flex-direction:column;
        align-items:center;
    ">');

    htp.print('<div style="
        width:140px;
        height:140px;
        border-radius:20px;
        background:#eef3ff;
        border:2px dashed #9bb3ff;
        display:flex;
        align-items:center;
        justify-content:center;
        color:#5b6b8a;
        margin-bottom:14px;
    ">Immagine</div>');

    htp.print('<div style="
        font-size:22px;
        font-weight:700;
        color:#0f3fb8;
        text-align:center;
    ">Cross Training</div>');

    htp.print('</div>');

    ------------------------------------------------------------------
    -- CARD CORSO 3
    ------------------------------------------------------------------
    htp.print('<div style="
        background:white;
        border-radius:24px;
        padding:22px;
        box-shadow:0 6px 18px rgba(0,0,0,0.10);
        border:1px solid #e8e8e8;
        display:flex;
        flex-direction:column;
        align-items:center;
    ">');

    htp.print('<div style="
        width:140px;
        height:140px;
        border-radius:20px;
        background:#eef3ff;
        border:2px dashed #9bb3ff;
        display:flex;
        align-items:center;
        justify-content:center;
        color:#5b6b8a;
        margin-bottom:14px;
    ">Immagine</div>');

    htp.print('<div style="
        font-size:22px;
        font-weight:700;
        color:#0f3fb8;
        text-align:center;
    ">Functional Fit</div>');

    htp.print('</div>');

    htp.print('</div>');
    htp.print('</div>');
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

procedure ApriGriglia (Colonne number default 3) is
begin
    htp.print('<div style="
        display:grid;
        grid-template-columns:repeat(' || Colonne || ', 1fr);
        gap:24px;
    ">');
end;

procedure ChiudiGriglia is
begin
    htp.print('</div>');
end;

procedure ApriContenitore (Padding varchar2 default '30px') is
begin
    htp.print('<div style="padding:' || Padding || ';">');
end;

procedure ChiudiContenitore is
begin
    htp.print('</div>');
end;

procedure TitoloSezione (
    Titolo      varchar2,
    Sottotitolo varchar2 default null
) is
begin
    htp.print('<div style="
        text-align:center;
        margin-bottom:35px;
    ">');

    htp.print('<div style="
        font-size:36px;
        font-weight:900;
        color:#0f3fb8;
        margin-bottom:10px;
    ">' || Titolo || '</div>');

    if Sottotitolo is not null then
        htp.print('<div style="
            font-size:18px;
            color:#555;
        ">' || Sottotitolo || '</div>');
    end if;

    htp.print('</div>');
end;

END fitGUI;
/