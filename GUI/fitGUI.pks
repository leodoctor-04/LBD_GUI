create or replace PACKAGE fitGUI AS

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

PROCEDURE login_proc_web (
    p_user IN VARCHAR2,
    p_pwd  IN VARCHAR2
);

END fitGUI;
