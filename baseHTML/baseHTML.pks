create or replace package body baseHTML as

    procedure apriPagina( titolo IN VARCHAR2 DEFAULT NULL );
    procedure chiudiPagina;

    procedure apriDiv( stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiDiv;

    procedure paragrafo( testo IN VARCHAR2 );
    procedure h1( testo IN VARCHAR2 );
    procedure h3( testo IN VARCHAR2 );

    procedure apriMenuTendina( stile IN VARCHAR2 DEFAULT NULL );
    procedure chiudiMenuTendina;
    procedure tendinaOption( ozione IN VARCHAR2 );

    procedure apriLista;
    procedure chiudiLista;

end baseHTML;