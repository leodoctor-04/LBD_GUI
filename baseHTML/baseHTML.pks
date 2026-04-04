create or replace package body baseHTML as

    procedure apriPagina( titolo IN VARCHAR2 DEFAULT NULL );
    procedure chiudiPagina;

    -- div speciali: lista
    procedure apriDiv( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiDiv;

    procedure paragrafo( testo IN VARCHAR2 );
    procedure h1( testo IN VARCHAR2 );
    procedure h3( testo IN VARCHAR2 );

    procedure apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiMenuTendina;
    procedure tendinaOption( ozione IN VARCHAR2 );

    -- per i form onclick vuoto e diventa di tipo submit
    PROCEDURE bottone( testo IN VARCHAR2, onClick IN VARCHAR2 DEFAULT NULL );

    PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL);

    -- form( action<la pagina a cui inviare i dati>,metodo<true:get, false:post>)
    PROCEDURE apriForm( id IN VARCHAR2 DEFAULT NULL, action IN VARCHAR2 DEFAULT NULL, metodo IN BOOLEAN DEFAULT false);
    PROCEDURE chiudiForm;
    PROCEDURE inserisciInput(
        id  IN VARCHAR2,    --obbligatorio nell'input per permettere a label di collegarsi alla casella
        tipo    IN VARCHAR2 DEFAULT 'text', -- text, password, email, tel, checkbox, radio, number, hidden, date.
        nome    IN VARCHAR2,    -- il nome per richiamare il campo
        valore  IN VARCHAR2 DEFAULT NULL,   --valore di default del campo
        placeholder IN VARCHAR2 DEFAULT NULL,   --per campi checked e radio, indica se 
        obbligatorio    IN BOOLEAN  DEFAULT false   -- Aggiunge l'attributo 'required'
    );
    PROCEDURE inserisciTextArea( testo IN VARCHAR2 );


end baseHTML;