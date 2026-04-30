create or replace PACKAGE BASEHTML as

    v_idSessione NUMBER := -1;

    PROCEDURE apriPagina(
        titolo       IN VARCHAR2 DEFAULT NULL,
        p_idSessione IN NUMBER DEFAULT -1
    );
    procedure chiudiPagina;

     -- div speciali(id definiti): lista, griglia
    procedure apriDiv( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiDiv;

    procedure paragrafo( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL );
    procedure h1( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL );

    -- nome utilee  per chiamarlo in un form
    procedure apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, nome IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiMenuTendina;
    PROCEDURE tendinaOption(
        opzione     IN VARCHAR2,
        valore      IN VARCHAR2 DEFAULT NULL,
        selezionata IN BOOLEAN DEFAULT FALSE
    );

    -- per i form onclick vuoto e diventa di tipo submit da mettere nel modulo
    PROCEDURE bottone(
        testo   IN VARCHAR2,
        onClick IN VARCHAR2 DEFAULT NULL,
         stile IN VARCHAR2 DEFAULT NULL
    ) ;
    
    PROCEDURE bottoneLink(
        testo IN VARCHAR2,
        link  IN VARCHAR2,
         stile IN VARCHAR2 DEFAULT NULL
    );
    PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL);

    -- form( action<la pagina a cui inviare i dati>)
    PROCEDURE apriModulo( id IN VARCHAR2 DEFAULT NULL, action IN VARCHAR2 DEFAULT NULL);
    PROCEDURE chiudiModulo;
    PROCEDURE inserisciInput(
        id  IN VARCHAR2,    ----Nome del label
        tipo    IN VARCHAR2 DEFAULT 'text', -- text, password, email, tel, checkbox, radio, number, hidden, date.
        nome    IN VARCHAR2,    -- il nome per richiamare il campo
        valore  IN VARCHAR2 DEFAULT NULL,   --valore di default del campo
        placeholder IN VARCHAR2 DEFAULT NULL,   --per campi checked e radio, indica se sono checked o no
        obbligatorio    IN BOOLEAN  DEFAULT false,  -- Aggiunge l'attributo 'required'
        stileDiv IN VARCHAR2 DEFAULT NULL,  -- CSS inline del contenitore <div> dell'input
        stileInput IN VARCHAR2 DEFAULT NULL, -- CSS inline dell'elemento <input>

        label IN VARCHAR2 DEFAULT NULL, -- Testo del label (se NULL usa id)

        min_val IN NUMBER DEFAULT NULL, -- Valore minimo (per input number/date)
        max_val IN NUMBER DEFAULT NULL  -- Valore massimo (per input number/date)
    );
    PROCEDURE inserisciTextArea( testo IN VARCHAR2, nome IN VARCHAR2 DEFAULT NULL, modificabile IN BOOLEAN DEFAULT true); -- name serve per richiamarlo nel form

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
    
    PROCEDURE aggiungi_Stile(stile varchar);
    PROCEDURE aggiungi_script(script varchar);
     procedure redirect(url varchar);
    
    PROCEDURE vaiACapo;
    
end baseHTML;