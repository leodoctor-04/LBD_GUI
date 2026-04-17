create or replace package baseHTML as
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

    -- form( action<la pagina a cui inviare i dati>)
    PROCEDURE apriModulo( id IN VARCHAR2 DEFAULT NULL, action IN VARCHAR2 DEFAULT NULL);
    PROCEDURE chiudiModulo;
    PROCEDURE inserisciInput(
        id  IN VARCHAR2,    --obbligatorio nell'input per permettere a label di collegarsi alla casella
        tipo    IN VARCHAR2 DEFAULT 'text', -- text, password, email, tel, checkbox, radio, number, hidden, date.
        nome    IN VARCHAR2,    -- il nome per richiamare il campo
        valore  IN VARCHAR2 DEFAULT NULL,   --valore di default del campo
        placeholder IN VARCHAR2 DEFAULT NULL,   --per campi checked e radio, indica se sono checked o no
        obbligatorio    IN BOOLEAN  DEFAULT false   -- Aggiunge l'attributo 'required'
    );
    PROCEDURE inserisciTextArea( testo IN VARCHAR2, name IN VARCHAR2 DEFAULT NULL, modificabile IN BOOLEAN DEFAULT true); -- name serve per richiamarlo nel form

    PROCEDURE apriPopup( id IN VARCHAR2 DEFAULT NULL );
    PROCEDURE chiudiPopup;

    PROCEDURE apriTabella( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    PROCEDURE chiudiTabella;
    PROCEDURE inizioRiga;
    PROCEDURE fineRiga;
    PROCEDURE inserisciIntestazione( testo IN VARCHAR2 );
    PROCEDURE inserisciCella( testo IN VARCHAR2 );
    -- per inserire altre procedure in una cella
    PROCEDURE apriCella;
    PROCEDURE chiudiCella;


end baseHTML;