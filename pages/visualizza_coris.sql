create or replace procedure visualizzaCorsi is 
BEGIN
-- questa pagina è ancora in demo
 baseHTML.apriPagina('Visualizza tuoi corsi');

 baseHTML.H1( 'I tuoi Corsi', 'margin-bottom:0px; text-align:center; margin-top:2vw; color:white;' );
  baseHTML.apriDiv( 'lista' );
    componenti.listaCorsi(3);
  baseHTML.chiudiDiv;

  baseHTML.apriDiv( '', 'display:flex; justify-content:center; align-items:center; gap:1vw;' );
    baseHTML.H1( 'Tipologia:', 'color:white;' );
    componenti.apriMenuTendina;
    -- queste opzioni sono di prova, vanno generate apposta con una procedura che dice i tipi
      componenti.tendinaOption('a');
      componenti.tendinaOption('b');
      componenti.tendinaOption('c');
      componenti.tendinaOption('d');
    componenti.chiudiMenuTendina;
    baseHTML.bottone('Cerca'); -- da aggiungere qualcosa di dinamico, tipo chiamata di funzione
  baseHTML.chiudiDiv;

  baseHTML.apriDiv( 'lista' );
    componenti.listaCorsi(5);
  baseHTML.chiudiDiv;
 
  baseHTML.chiudiPagina;
end visualizzaCorsi;
