CREATE OR REPLACE PACKAGE fitGUI AS

-- Header
procedure Header (
    NomeSito varchar2 default 'FitZone',
    Loggato boolean default false,
    NomeUtente varchar2 default null
);

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


procedure MessaggioTemporaneo (
    IdMsg        varchar2,
    Testo        varchar2,
    Tipo         varchar2 default 'errore',
    Millisecondi number default 3000
);

procedure StatCard (
    Titolo      varchar2,
    Valore      varchar2,
    Descrizione varchar2 default null
);          -- in component

procedure ApriGriglia (Colonne number default 3);   --Da trasformare in stile

END fitGUI;