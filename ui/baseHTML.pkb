CREATE OR REPLACE PACKAGE BODY baseHTML AS

    PROCEDURE apriPagina(titolo IN VARCHAR2 DEFAULT NULL, acceduto IN BOOLEAN DEFAULT false, nome IN VARCHAR2 DEFAULT NULL) IS BEGIN
        htp.htmlOpen;
        htp.headOpen;
            htp.title( titolo );
            htp.print('<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">');
            Stile.stile;
        htp.headClose;

        htp.bodyOpen;
            htp.print('<header>');

            IF acceduto THEN
                htp.p( '<h1 onclick="toggleMenu()" style="cursor: pointer;">☰</h1>' );
                Componenti.MenuHamburger;
            END IF;

            htp.print('<h1>'|| titolo ||'</h1> <nav>');
            IF acceduto THEN
                htp.p( '<p>' || nome || '</p>');
            ELSE
                htp.p('
                    <button onclick="openLogin()">Accedi</button>
                    <img src="" alt="icona" onerror="this.src=''https://cdn-icons-png.flaticon.com/512/149/149071.png'';">
                    '); --aggiungere icona
                Componenti.LoginPopup;
            END IF;
                
            htp.print('</nav>
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

    PROCEDURE apriMenuTendina( id IN VARCHAR2 DEFAULT NULL, nome IN VARCHAR2, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.p('<div style="display: block;">');
        IF nome IS NOT NULL THEN
            htp.p( '<label for="' || id || '">' || id || '</label>' );
        END IF;

        htp.prn('<select');
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF nome IS NOT NULL THEN
            htp.prn( ' name="' || nome || '"' );
        END IF;
        IF stile IS NOT NULL THEN
            htp.prn( ' style="' || stile || '"' );
        END IF;
        htp.p('>');
    END apriMenuTendina;
    PROCEDURE chiudiMenuTendina IS BEGIN
        htp.p('</select>');
        htp.p('</div>');
    END chiudiMenuTendina;
    PROCEDURE tendinaOption(opzione IN VARCHAR2) IS BEGIN
        htp.p('<option value="' || opzione || '">' || opzione || '</option>');
    END tendinaOption;

    PROCEDURE bottone( testo IN VARCHAR2, onClick IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn( '<button ' );
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

    PROCEDURE apriModulo( id IN VARCHAR2 DEFAULT NULL, action IN VARCHAR2 DEFAULT NULL) IS BEGIN
        htp.prn( '<form' );
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF action IS NOT NULL THEN
            htp.prn( ' action="' || action || '"' );
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
        htp.p('<div style="display: block;">');
            IF tipo <> 'hidden' THEN
                htp.p( '<label for="' || id || '">' || id || '</label>' );
            END IF;
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
        htp.p('</div>');
    END inserisciInput;
    PROCEDURE inserisciTextArea( testo IN VARCHAR2, nome IN VARCHAR2 DEFAULT NULL, modificabile IN BOOLEAN DEFAULT true) IS BEGIN
        htp.prn( '<textarea' );
        IF nome IS NOT NULL THEN
            htp.prn( ' name="' || nome || '"' );
        END IF;
        IF NOT modificabile THEN
            htp.prn( ' readonly' );
        END IF;
        htp.p( '>' || testo || '</textarea>' );
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

    PROCEDURE apriTabella( id IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL ) IS BEGIN
        htp.prn( '<table' );
        IF id IS NOT NULL THEN
            htp.prn( ' id="' || id || '"' );
        END IF;
        IF stile IS NOT NULL THEN
            htp.prn( ' style="' || stile || '"' );
        END IF;
        htp.p( '>' );
    END apriTabella;
    PROCEDURE chiudiTabella IS BEGIN
        htp.p('</table>');
    END chiudiTabella;
    PROCEDURE inizioRiga IS BEGIN
        htp.p('<tr>');
    END inizioRiga;
    PROCEDURE fineRiga IS BEGIN
        htp.p('</tr>');
    END fineRiga;
    PROCEDURE inserisciIntestazione( testo IN VARCHAR2 ) IS BEGIN
        htp.p('<th>' || testo || '</th>');
    END inserisciIntestazione;
    PROCEDURE inserisciCella( testo IN VARCHAR2 ) IS BEGIN
        htp.p('<td>' || testo || '</td>');
    END inserisciCella;
    PROCEDURE apriCella IS BEGIN
        htp.p('<td>');
    END apriCella;
    PROCEDURE chiudiCella IS BEGIN
        htp.p('</td>');
    END chiudiCella;
END baseHTML;