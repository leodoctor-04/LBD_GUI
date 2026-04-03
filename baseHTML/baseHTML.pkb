CREATE OR REPLACE PACKAGE BODY baseHTML AS

PROCEDURE apriPagina(titolo IN VARCHAR2 DEFAULT NULL) IS BEGIN
    htp.htmlOpen;
    htp.headOpen;
        htp.title( titolo );
        htp.print('<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">');
        Stile.stile;
    htp.headClose;

    htp.bodyOpen;
        htp.print('
        <header>
        <h1>'|| TitoloPagina ||'</h1>
        <nav>
        <button>
        Accedi
        </button>
        <img src="" alt="icona" onerror="this.src=''https://cdn-icons-png.flaticon.com/512/149/149071.png'';">
        </nav>
        </header>
        ');
END apriPagina;

PROCEDURE chiudiPagina IS BEGIN
    htp.print('
        <footer>
        <h1>FitZone</h1>
        <p>&copy; ' || to_char(sysdate, 'YYYY') || ' FitZone. Tutti i diritti riservati</p>
        </footer>
    ');
    
    htp.bodyClose;
    htp.htmlClose;
END chiudiPagina;

-- div speciali: lista
PROCEDURE apriDiv( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
    htp.p('<div');
    IF id IS NOT NULL THEN
        htp.p( ' id="' || id );
    END IF;
    IF stile IS NOT NULL THEN
        htp.p( ' style="' || stile );
    END IF;
    htp.p('>');
    
END apriDiv;

PROCEDURE chiudiDiv IS BEGIN
    htp.p('</div>');
END chiudiDiv;

PROCEDURE paragrafo(testo IN VARCHAR2) IS BEGIN
    htp.p('<p>' || testo || '</p>');
END paragrafo;

PROCEDURE h1(testo IN VARCHAR2) IS BEGIN
    htp.p('<h1>' || testo || '</h1>');
END h1;

PROCEDURE apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
    htp.p('<select');
    IF id IS NOT NULL THEN
        htp.p( ' id="' || id );
    END IF;
    IF stile IS NOT NULL THEN
        htp.p( ' style="' || stile );
    END IF;
    htp.p('>');
END apriMenuTendina;

PROCEDURE chiudiMenuTendina IS BEGIN
    htp.p('</select>');
END chiudiMenuTendina;

PROCEDURE tendinaOption(opzione IN VARCHAR2) IS BEGIN
    htp.p('<option value="' || opzione || '">' || opzione || '</option>');
END tendinaOption;

-- per i form onclick vuoto e diventa di tipo submit
PROCEDURE bottone( testo IN VARCHAR2, onClick IN VARCHAR2 DEFAULT NULL ) IS BEGIN
    htp.print( '<button' );
    IF onClick IS NOT NULL THEN
        htp.p( 'type="button" onclick="' || onClick || '()"');
    END IF;
    htp.p( '>' || testo || '</button>' );
END bottone;

PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL) IS BEGIN
    htp.p('<a ');
    IF pagina IS NOT NULL THEN
        htp.p( 'href="' || pagina || '"' );
    END IF;
    htp.p( '>' || testo || '</a>' );

END collegamento;

END baseHTML;