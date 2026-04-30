create or replace procedure TuoiCorsi( p_idSessione IN NUMBER DEFAULT -1, p_filtro IN NUMBER DEFAULT NULL ) is
  v_idUtente NUMBER;
BEGIN
  baseHTML.apriPagina('Visualizza tuoi corsi', p_idSessione);

  SELECT idUtente INTO v_idUtente FROM SESSIONI WHERE p_idSessione = idSessione;

  baseHTML.H1( 'I tuoi Corsi', 'margin-bottom:0px; text-align:center; margin-top:2vw; color:white;' );
  baseHTML.apriDiv( 'lista' );
    Corsi.visualizzaCorsi;
    IF sessioneUtente.controllaIstruttore(p_idSessione) THEN
      Corsi.visualizzaCorsiIstruttore(v_idUtente, true);
    END IF;
  baseHTML.chiudiDiv;

  baseHTML.apriModulo( 'filtroTipologia', global.url || 'TuoiCorsi' );
    baseHTML.inserisciInput('', 'hidden', 'p_idSessione', p_idSessione );
    baseHTML.H1( 'Tipologia:', 'color:white;' );
      baseHTML.apriMenuTendina('', 'p_filtro');
      FOR r IN (SELECT idTipologia, nomeTipologia FROM Tipologia_corso) LOOP
          -- Passiamo il nome come etichetta e l'ID come valore tecnico
          IF r.idTipologia = p_filtro THEN
            baseHTML.tendinaOption( r.nomeTipologia, r.idTipologia, true);
          ELSE baseHTML.tendinaOption( r.nomeTipologia, r.idTipologia);
          END IF;
      END LOOP;
      baseHTML.chiudiMenuTendina;
    baseHTML.bottone('Cerca');
  baseHTML.chiudiModulo;

  baseHTML.apriDiv( 'lista' );
  IF p_filtro IS NOT NULL THEN
    Corsi.visualizzaCorsi( p_filtro, false);
  ELSE Corsi.visualizzaCorsi( null, false);
  END IF;
  baseHTML.chiudiDiv;
 
  baseHTML.chiudiPagina;
end TuoiCorsi;
/
GRANT EXECUTE ON TuoiCorsi TO anonymous;