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
            <h1>'|| titolo ||'</h1>
            <nav>
                <button>Accedi</button>
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

    PROCEDURE apriDiv( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<div');
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF stile IS NOT NULL THEN
            htp.prn( ' style="' || stile || '"' );
        END IF;
        htp.p('>');
        
    END apriDiv;
    PROCEDURE chiudiDiv IS BEGIN
        htp.p('</div>');
    END chiudiDiv;

    PROCEDURE paragrafo( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<p' );
        IF stile IS NOT NULL THEN
            htp.prn( ' style="'|| stile || '"' );
        END IF;
        htp.p(' >' || testo || '</p>');
    END paragrafo;
    PROCEDURE h1( testo IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<h1' );
        IF stile IS NOT NULL THEN
            htp.prn( ' style="'|| stile || '"' );
        END IF;
        htp.p( '>' || testo || '</h1>' );
    END h1;

    PROCEDURE apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn('<select');
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF stile IS NOT NULL THEN
            htp.prn( ' style="' || stile || '"' );
        END IF;
        htp.p('>');
    END apriMenuTendina;
    PROCEDURE chiudiMenuTendina IS BEGIN
        htp.p('</select>');
    END chiudiMenuTendina;
    PROCEDURE tendinaOption(opzione IN VARCHAR2) IS BEGIN
        htp.p('<option value="' || opzione || '">' || opzione || '</option>');
    END tendinaOption;

    PROCEDURE bottone( testo IN VARCHAR2, onClick IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn( '<button' );
        IF onClick IS NOT NULL THEN
            htp.prn( 'type="button" onclick="' || onClick || '()"');
        END IF;
        htp.p( '>' || testo || '</button>' );
    END bottone;

    PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL) IS BEGIN
        htp.prn('<a ');
        IF pagina IS NOT NULL THEN
            htp.prn( 'href="' || pagina || '"' );
        END IF;
        htp.p( '>' || testo || '</a>' );

    END collegamento;

    PROCEDURE apriModulo( id IN VARCHAR2 DEFAULT NULL, action IN VARCHAR2 DEFAULT NULL, metodo IN BOOLEAN DEFAULT false) IS BEGIN
        htp.prn( '<form' );
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF action IS NOT NULL THEN
            htp.prn( ' action="' || action || '"' );
        END IF;
        IF metodo THEN
            htp.prn( ' method="true"' );
        ELSE
            htp.prn( ' method="false"' );
        END IF;
        htp.p( '>' );

    END apriModulo;
    PROCEDURE chiudiModulo IS BEGIN
        htp.p('</form>');
    END chiudiModulo;
    PROCEDURE inserisciInput(
        id  IN VARCHAR2,
        tipo    IN VARCHAR2 DEFAULT 'text',    -- text, password, email, tel, checkbox, radio, number, hidden, date.
        nome    IN VARCHAR2,    -- il nome per richiamare il campo
        valore  IN VARCHAR2 DEFAULT NULL, 
        placeholder IN VARCHAR2 DEFAULT NULL,
        obbligatorio    IN BOOLEAN  DEFAULT false   -- Aggiunge l'attributo 'required'
    ) IS BEGIN
        htp.p( '<label for="' || id || '">' || nome || '</label>' );
        htp.prn( '<input id="' || id || '" type="' || tipo || '" name="' || nome || '"' );
        IF valore IS NOT NULL THEN
            htp.prn( ' value="' || valore || '"' );
        END IF;
        IF placeholder IS NOT NULL THEN
            IF tipo = 'radio' OR tipo = 'checkbox' THEN
                htp.prn( ' checked' );
            ELSE
                htp.prn( ' placeholder="' || placeholder || '"' );
            END IF;
        END IF;
        IF obbligatorio THEN
            htp.prn( ' required' );
        END IF;

        htp.p( ' >');
    END inserisciInput;
    PROCEDURE inserisciTextArea( testo IN VARCHAR2 ) IS BEGIN
        htp.p( '<textarea>' || testo || '</textarea>' );
    END inserisciTextArea;

    PROCEDURE apriPopup( id IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn( '<dialog ');
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        htp.p(' >');
    END apriPopup;
    PROCEDURE chiudiPopup IS BEGIN
    htp.prn( '</dialog>');
END chiudiPopup;

END baseHTML;