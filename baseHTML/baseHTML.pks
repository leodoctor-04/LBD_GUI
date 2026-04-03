create or replace package body baseHTML as

    procedure apriPagina( titolo IN VARCHAR2 DEFAULT NULL );
    procedure chiudiPagina;

    procedure apriDiv( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiDiv;

    procedure paragrafo( testo IN VARCHAR2 );
    procedure h1( testo IN VARCHAR2 );
    procedure h3( testo IN VARCHAR2 );

    procedure apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiMenuTendina;
    procedure tendinaOption( ozione IN VARCHAR2 );

    PROCEDURE bottone( testo IN VARCHAR2, onClick IN VARCHAR2 DEFAULT NULL );

    PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL);

end baseHTML;