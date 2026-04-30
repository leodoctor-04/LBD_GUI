create or replace procedure eliminaCorso( p_idSessione IN NUMBER DEFAULT -1, p_idCorso IN NUMBER DEFAULT NULL, elimina IN VARCHAR2 DEFAULT 'FALSE' ) IS
  v_esito NUMBER := -1;
  v_stato_corso VARCHAR2(20);
BEGIN
  baseHTML.apriPagina('Elimina corsi', p_idSessione);

  IF p_idCorso IS NOT NULL AND elimina = 'TRUE' THEN
    v_esito := Corsi.degradaCorso(p_idCorso);
    IF v_esito = 1 THEN
      baseHTML.apriDiv( 'successo' );
        baseHTML.paragrafo( 'Corso eliminato' );
      baseHTML.chiudiDiv;
    ELSIF v_esito = 0 THEN
      baseHTML.apriDiv( 'successo' );
        baseHTML.paragrafo( 'Corso disattivato' );
      baseHTML.chiudiDiv;
    ELSIF v_esito < 0 THEN
      baseHTML.apriDiv( 'errore' );
        baseHTML.paragrafo( 'Corso non trovato' );
      baseHTML.chiudiDiv;
    END IF;
  END IF;

  IF p_idCorso IS NULL OR elimina = 'TRUE' THEN
    --prima visione
    baseHTML.apriModulo( 'modulo', global.url || 'eliminaCorso' );
      baseHTML.inserisciInput('', 'hidden', 'p_idSessione', p_idSessione );
      baseHTML.H1( 'Elimina Corso' );
        baseHTML.apriMenuTendina('Corso:', 'p_idCorso');
          Corsi.listaCorsiAll( useSessione => false );
        baseHTML.chiudiMenuTendina;
      baseHTML.bottone('Elimina');
    baseHTML.chiudiModulo;
  ELSE
    --seconda chance
    SELECT stato INTO v_stato_corso FROM CORSO WHERE p_idCorso = CORSO.idCorso;

    baseHTML.apriModulo( 'modulo', global.url || 'eliminaCorso' );
      Corsi.visualizzaCorso(p_idCorso);
      IF v_stato_corso = 'DISATTIVO' THEN
        baseHTML.bottone('Elimina');
      ELSE baseHTML.bottone('Disattiva');
      END IF;
      baseHTML.inserisciInput('', 'hidden', 'p_idSessione', p_idSessione );
      baseHTML.inserisciInput('', 'hidden', 'p_idCorso', p_idCorso );
      baseHTML.inserisciInput('', 'hidden', 'elimina', 'TRUE' );
    baseHTML.chiudiModulo;
  END IF;
 
  baseHTML.chiudiPagina;
end eliminaCorso;
/
GRANT EXECUTE ON eliminaCorso TO anonymous;