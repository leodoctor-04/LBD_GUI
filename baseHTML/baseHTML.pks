create or replace package baseHTML as

    root constant VARCHAR2(20) := '/apex/Benedetti2526.';
    accountutente constant VARCHAR2(20) := 'Benedetti2526';

    procedure apriPagina(titolo IN VARCHAR2 DEFAULT NULL, acceduto IN BOOLEAN DEFAULT false, nome IN VARCHAR2 DEFAULT NULL);
    procedure chiudiPagina;

    -- div speciali: lista, griglia
    procedure apriDiv( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiDiv;

    procedure paragrafo( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL );
    procedure h1( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL );

    procedure apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiMenuTendina;
    procedure tendinaOption( opzione IN VARCHAR2 );

    -- per i form onclick vuoto e diventa di tipo submit da mettere nel modulo
    PROCEDURE bottone( testo IN VARCHAR2, onClick IN VARCHAR2 DEFAULT NULL );

    PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL);

    -- form( action<la pagina a cui inviare i dati>,metodo<true:GET, false:POST>)
    PROCEDURE apriModulo( id IN VARCHAR2 DEFAULT NULL, action IN VARCHAR2 DEFAULT NULL, metodo IN BOOLEAN DEFAULT false);
    PROCEDURE chiudiModulo;
    PROCEDURE inserisciInput(
        id  IN VARCHAR2,    --obbligatorio nell'input per permettere a label di collegarsi alla casella
        tipo    IN VARCHAR2 DEFAULT 'text', -- text, password, email, tel, checkbox, radio, number, hidden, date.
        nome    IN VARCHAR2,    -- il nome per richiamare il campo
        valore  IN VARCHAR2 DEFAULT NULL,   --valore di default del campo
        placeholder IN VARCHAR2 DEFAULT NULL,   --per campi checked e radio, indica se sono checked o no
        obbligatorio    IN BOOLEAN  DEFAULT false   -- Aggiunge l'attributo 'required'
    );
    PROCEDURE inserisciTextArea( testo IN VARCHAR2 );

    PROCEDURE apriPopup( id IN VARCHAR2 DEFAULT NULL );
    PROCEDURE chiudiPopup;




    -- Login
procedure LoginPopup;

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


PROCEDURE loginProc (
    p_user IN VARCHAR2,
    p_pwd  IN VARCHAR2
);

PROCEDURE messaggioLogin( msg IN VARCHAR2);

end baseHTML;