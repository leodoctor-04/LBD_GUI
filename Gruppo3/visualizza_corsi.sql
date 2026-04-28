create or replace procedure TuoiCorsi( p_idSessione IN NUMBER DEFAULT -1, p_filtro IN NUMBER DEFAULT 1 ) is
BEGIN
  baseHTML.apriPagina('Visualizza tuoi corsi', p_idSessione);

  baseHTML.H1( 'I tuoi Corsi', 'margin-bottom:0px; text-align:center; margin-top:2vw; color:white;' );
  baseHTML.apriDiv( 'lista' );
    Corsi.visualizzaCorsi(p_idSessione);
  baseHTML.chiudiDiv;

  baseHTML.apriModulo( 'filtroTipologia', global.url || 'TuoiCorsi' );
    baseHTML.inserisciInput('', 'hidden', 'p_idSessione', p_idSessione );
    baseHTML.H1( 'Tipologia:', 'color:white;' );
      baseHTML.apriMenuTendina('', 'p_filtro');
      FOR r IN (SELECT idTipologia, nomeTipologia FROM Tipologia_corso) LOOP
          -- Passiamo il nome come etichetta e l'ID come valore tecnico
          baseHTML.tendinaOption( r.nomeTipologia, r.idTipologia);
      END LOOP;
      baseHTML.chiudiMenuTendina;
    baseHTML.bottone('Cerca');
  baseHTML.chiudiModulo;

  baseHTML.apriDiv( 'lista' );
    Corsi.visualizzaCorsi( p_filtro, false);
  baseHTML.chiudiDiv;
 
  baseHTML.chiudiPagina;
end TuoiCorsi;
/
GRANT EXECUTE ON TuoiCorsi TO anonymous;