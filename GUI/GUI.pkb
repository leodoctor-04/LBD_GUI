create or replace package body GUI as

procedure home is BEGIN
  baseHTML.apriPagina('Fitzone');

  baseHTML.apriDiv('panoramica');
    baseHTML.apriDiv;
      baseHTML.H1('Benvenuti in FitZone', 'padding-top:3vw;');
      baseHTML.paragrafo( 'In FitZone, non siamo solo una palestra, ma una vera community dedicata al benessere e al superamento dei propri limiti. Nati con l''obiettivo di rendere il fitness accessibile, motivante e orientato ai risultati, offriamo uno spazio all''avanguardia dove tecnologia e passione si incontrano. Che tu sia un atleta esperto o stia muovendo i tuoi primi passi nel mondo dell''allenamento, il nostro team di professionisti è pronto a guidarti con programmi personalizzati e un supporto costante. In FitZone, ogni goccia di sudore è un passo verso la versione migliore di te stesso: entra a far parte del movimento e trasforma la tua routine in uno stile di vita.' );
    baseHTML.chiudiDiv;
    baseHTML.apriDiv;
      baseHTML.H1('Dove trovarci', 'padding-top:3vw;');
      htp.print('<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2883.5198577321453!2d10.404643375660863!3d43.72052634807441!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x12d591e2e9573113%3A0x1e8d4d52d7be933b!2sPolo%20Fibonacci!5e0!3m2!1sit!2sit!4v1774861849189!5m2!1sit!2sit" style="border:0; width: 100%; height: 70%;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe> ');
    baseHTML.chiudiDiv;
  baseHTML.chiudiDiv;

  baseHTML.apriDiv;
    baseHTML.H1('I nostri corsi', 'margin-bottom:0px; text-align: center; color:white;' );
    baseHTML.apriDiv('lista' );
      Corsi.visualizza(5);
    baseHTML.chiudiDiv;
  baseHTML.chiudiDiv;

  baseHTML.chiudiPagina;
end home;

procedure visualizzaCorsi is BEGIN
-- questa pagina è ancora in demo
 baseHTML.apriPagina('Visualizza tuoi corsi');

 baseHTML.H1( 'I tuoi Corsi', 'margin-bottom:0px; text-align:center; margin-top:2vw; color:white;' );
  baseHTML.apriDiv( 'lista' );
    Corsi.visualizza(3);
  baseHTML.chiudiDiv;

  baseHTML.apriDiv( '', 'display:flex; justify-content:center; align-items:center; gap:1vw;' );
    baseHTML.H1( 'Tipologia:', 'color:white;' );
    baseHTML.apriMenuTendina;
    -- queste opzioni sono di prova, vanno generate apposta con una procedura che dice i tipi
      baseHTML.opzione('a');
      baseHTML.opzione('b');
      baseHTML.opzione('c');
      baseHTML.opzione('d');
    baseHTML.chiudiMenuTendina;
    baseHTML.bottone('Cerca'); -- da aggiungere qualcosa di dinamico, tipo chiamata di funzione
  baseHTML.chiudiDiv;

  baseHTML.apriDiv( 'lista' );
    Corsi.visualizza(5);
  baseHTML.chiudiDiv;
 
  baseHTML.chiudiPagina;
end visualizzaCorsi;

end GUI;