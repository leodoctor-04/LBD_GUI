create or replace PACKAGE BODY BASEHTML AS
    
    PROCEDURE apriPagina(
        titolo       IN VARCHAR2 DEFAULT NULL,
        p_idSessione IN NUMBER DEFAULT -1
    ) IS
        v_username VARCHAR2(100);
    BEGIN
        v_idSessione := p_idSessione;
        -- Link per la home
        IF p_idSessione != -1 THEN
            IF sessioneUtente.controllaSessione(p_idSessione) THEN
                v_idSessione := p_idSessione;
                -- Recupero il nome dell'utente per il menu
                SELECT username INTO v_username
                FROM sessioni, credenziali
                WHERE sessioni.idUtente = credenziali.idUtente
                AND sessioni.idSessione = p_idSessione;
            ELSE
                sessioneUtente.logout(p_idSessione);
            END IF;
        ELSIF UPPER(OWA_UTIL.GET_CGI_ENV('PATH_INFO')) NOT LIKE '%HOME%' THEN
            --GEMINI, mi fido di te
            -- Se p_idSessione è invalido E non siamo già sulla home: REDIRECT
            -- Usiamo owa_util per un redirect lato server (più pulito)
            -- Nota: owa_util.redirect_url deve essere chiamato PRIMA di htp.p
            owa_util.redirect_url(global.root || 'home');
            RETURN; -- Fondamentale per interrompere l'esecuzione
            -- mi fido sia di uwu e di questo return
        END IF;
    
        htp.htmlOpen;
        htp.headOpen;
            htp.title(titolo);
            htp.print('<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">');
            Stile.stile;
        htp.headClose;
    
        htp.bodyOpen;
            htp.print('<header>');
    
            IF v_idSessione > 0 THEN
                -- MENU HAMBURGER
                htp.p('<div style="display: flex; align-items: center; gap: 20px;">
                        <h1 onclick="toggleMenu()" style="cursor: pointer;">☰</h1>');
                        Componenti.MenuHamburger(v_idSessione);
                --TITOLO
                htp.p('<a href="'|| global.url || 'home?p_idSessione=' || v_idSessione || '" style="text-decoration: none; color: inherit;"> <h1>FitZone</h1> </a>
                    </div>');
                -- Utente cliccabile
                htp.p('<a href="' || global.url || 'gabrielli.infoUtente?p_idSessione=' || v_idSessione || '" 
                        style="text-decoration:none; color:inherit;">
                        <div style="display:flex; align-items:center; gap:10px; cursor:pointer;">
                            <p>' || INITCAP(v_username) || '</p>
                            <img src="" alt="icona" onerror="this.src=''https://cdn-icons-png.flaticon.com/512/149/149071.png'';">
                        </div>
                    </a>');
            ELSE
                htp.print('<h1>' || titolo || '</h1>');
            --LOGIN
                htp.p('
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <button onclick="openLogin()">Accedi</button>
                        <img src="" alt="icona" onerror="this.src=''https://cdn-icons-png.flaticon.com/512/149/149071.png'';">
                    </div>
                ');
                Componenti.LoginPopup;
            END IF;
        
            htp.print('</nav>
            </header>');
    END apriPagina;

    PROCEDURE chiudiPagina IS BEGIN
        htp.print('
            <footer>
             <a href="'|| global.url || 'home?p_idSessione=' || v_idSessione || '" style="text-decoration: none; color: inherit;"> <h1>FitZone</h1> </a>
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
    PROCEDURE tendinaOption(opzione IN VARCHAR2, valore IN VARCHAR2 DEFAULT NULL, selezionato IN BOOLEAN DEFAULT FALSE) IS BEGIN
        htp.prn('<option value="');
        IF valore IS NOT NULL THEN
            htp.prn( valore || '" ' );
        ELSE htp.prn( opzione || '" ' );
        END IF;
        IF selezionato THEN
        htp.prn( 'selected' );
        END IF;
        htp.p( '>' || opzione || '</option>');
    END tendinaOption;
    
    PROCEDURE bottone(
        testo   IN VARCHAR2,
        onClick IN VARCHAR2 DEFAULT NULL,
        stile   IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        htp.prn('<button ');
    
        IF stile IS NOT NULL THEN
            htp.prn('style="' || stile || '" ');
        END IF;
    
        IF onClick IS NOT NULL THEN
            htp.prn('type="button" onclick="' || onClick || '()"');
        ELSE
            htp.prn('type="submit"');
        END IF;
    
        htp.p('>' || testo || '</button>');
    END bottone;
    
    PROCEDURE bottoneLink(
        testo IN VARCHAR2,
        link  IN VARCHAR2,
        stile IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        IF stile IS NOT NULL THEN
            htp.p(
                '<a href="' || link || '" class="btn-link" style="' || stile || '">' ||
                    testo ||
                '</a>'
            );
        ELSE
            htp.p(
                '<a href="' || link || '" class="btn-link">' ||
                    testo ||
                '</a>'
            );
        END IF;
    END bottoneLink;

    PROCEDURE collegamento( testo IN VARCHAR2, pagina IN VARCHAR2 DEFAULT NULL, stile IN VARCHAR2 DEFAULT NULL) IS BEGIN
        htp.prn('<a ');
        IF pagina IS NOT NULL THEN
            htp.prn( 'href="' || pagina || '"' );
        END IF;
        IF stile IS NOT NULL THEN
            htp.prn( ' style="' || stile || '"' );
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
        id              IN VARCHAR2,
        tipo            IN VARCHAR2 DEFAULT 'text',
        nome            IN VARCHAR2,
        valore          IN VARCHAR2 DEFAULT NULL,
        placeholder     IN VARCHAR2 DEFAULT NULL,
        obbligatorio    IN BOOLEAN  DEFAULT false
    ) IS
    BEGIN
        htp.prn('<div style="display:block;"');
    
        htp.p('>');
    
            IF tipo <> 'hidden' THEN
                htp.prn('<label for="' || id || '">' || id ||'</label>');
            END IF;
    
            htp.prn('<input id="' || id || '" type="' || tipo || '" name="' || nome || '"');
    
            IF valore IS NOT NULL THEN
                htp.prn(' value="' || valore || '"');
            END IF;
    
            IF placeholder IS NOT NULL THEN
                IF tipo = 'radio' OR tipo = 'checkbox' THEN
                    htp.prn(' checked');
                ELSE
                    htp.prn(' placeholder="' || placeholder || '"');
                END IF;
            ELSIF tipo = 'date' THEN
                htp.prn(' placeholder="dd-mm-yyyy"');
            END IF;
    
            IF obbligatorio THEN
                htp.prn(' required');
            END IF;
    
            htp.p('>');
    
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
    
     PROCEDURE aggiungi_Stile(stile varchar) is
    begin
        htp.p(
            utl_lms.format_message( '<style>%s</style>',stile)
        );
    end;

    PROCEDURE aggiungi_script(script varchar) is
    begin
        htp.p(
            utl_lms.format_message( '<script>%s</script>',script)
        );
    end;

    procedure redirect(url varchar) IS
    begin
        htp.print('<script>window.location.href="' || url || '";</script>');
    end;
    
    PROCEDURE vaiACapo IS
    BEGIN
        htp.p('<br>');
    END vaiACapo;
    
END baseHTML;
/
GRANT EXECUTE ON baseHTML TO anonymous;