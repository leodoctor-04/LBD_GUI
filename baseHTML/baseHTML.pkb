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


PROCEDURE apriDiv(stile IN VARCHAR2 DEFAULT NULL) IS BEGIN
    IF stile IS NOT NULL THEN
        htp.p('<div style="' || stile || '">');
    ELSE
        htp.p('<div>');
    END IF;
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

PROCEDURE h3(testo IN VARCHAR2) IS BEGIN
    htp.p('<h3>' || testo || '</h3>');
END h3;

-- Menu a tendina (Tag Select)
PROCEDURE apriMenuTendina(stile IN VARCHAR2 DEFAULT NULL) IS BEGIN
    IF stile IS NOT NULL THEN
        htp.p('<select class="' || stile || '">');
    ELSE
        htp.p('<select>');
    END IF;
END apriMenuTendina;

PROCEDURE chiudiMenuTendina IS BEGIN
    htp.p('</select>');
END chiudiMenuTendina;

PROCEDURE tendinaOption(ozione IN VARCHAR2) IS BEGIN
    htp.p('<option value="' || ozione || '">' || ozione || '</option>');
END tendinaOption;

-- Liste per paragrafi
PROCEDURE apriLista IS BEGIN
    htp.print('<div id="lista">');
END apriLista;

PROCEDURE chiudiLista IS BEGIN
    htp.print('</div>');
END chiudiLista;

END baseHTML;