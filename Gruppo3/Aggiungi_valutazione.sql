create or replace procedure visualizzaFormValutazione( p_idSessione IN NUMBER, p_idCorso IN NUMBER DEFAULT 0 ) IS
BEGIN
    baseHTML.apriPagina('Valuta il Corso', p_idSessione);

    -- L'action punta alla procedura che processerà i dati
    baseHTML.apriModulo(id => 'modulo', action => global.url || 'Valutazioni.creaValutazione');

        baseHTML.h1('Lascia una valutazione');
        baseHTML.paragrafo('Raccontaci la tua esperienza per aiutarci a migliorare.');

        -- Input Nascosti (Sessione e Corso)
        baseHTML.inserisciInput('', tipo => 'hidden', nome => 'p_idSessione', valore => p_idSessione);
        baseHTML.inserisciInput('', tipo => 'hidden', nome => 'p_idCorso', valore => p_idCorso);

        baseHTML.apriMenuTendina(id => 'Voto', nome => 'p_votoNumerico');
            baseHTML.tendinaOption('Seleziona un voto', '');
            baseHTML.tendinaOption('1 - Scarso', '1');
            baseHTML.tendinaOption('2 - Sufficiente', '2');
            baseHTML.tendinaOption('3 - Buono', '3', true);
            baseHTML.tendinaOption('4 - Ottimo', '4');
            baseHTML.tendinaOption('5 - Eccellente', '5');
        baseHTML.chiudiMenuTendina;

        -- Commento (TextArea)
        baseHTML.apriDiv(stile => 'margin-bottom: 15px;');
            baseHTML.paragrafo('Il tuo commento:');
            baseHTML.inserisciTextArea(testo => '', nome => 'p_commento');
        baseHTML.chiudiDiv;

        baseHTML.apriDiv(stile => 'text-align: right;');
            baseHTML.bottone('Invia Valutazione');
        baseHTML.chiudiDiv;

    baseHTML.chiudiModulo;

    baseHTML.chiudiPagina;
END visualizzaFormValutazione;
/
GRANT EXECUTE ON visualizzaFormValutazione TO anonymous;