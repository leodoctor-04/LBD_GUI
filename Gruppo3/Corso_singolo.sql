create or replace procedure CorsoSingolo( p_idSessione IN NUMBER DEFAULT -1, p_id IN NUMBER DEFAULT 0 ) is
v_nome_corso Corso.titolo%TYPE;
isIscritto NUMBER;
v_idUtente NUMBER;
BEGIN

  SELECT titolo INTO v_nome_corso FROM Corso WHERE p_id = idCorso;

  SELECT idUtente INTO v_idUtente FROM SESSIONI WHERE idSessione = p_idSessione;

  baseHTML.apriPagina( v_nome_corso, p_idSessione);

  Corsi.visualizzaCorso(p_id);

  SELECT COUNT(*) INTO isIscritto
  FROM SESSIONI, ISCRIZIONE_CORSO
  WHERE SESSIONI.idSessione = p_idSessione
  AND ISCRIZIONE_CORSO.idAtleta = SESSIONI.idUtente
  AND ISCRIZIONE_CORSO.idCorso = p_id;
  
  baseHTML.apriDiv('modulo', stile=>'display: flex; justify-content: space-evenly; margin-bottom: 2.5vw;');
  IF isIscritto <= 0 THEN
    baseHTML.bottone('Iscriviti', 'iscriviti');
  ELSE
    baseHTML.bottone('Scrivi Recensione', 'scriviRecensione');
  END IF;
    baseHTML.bottone('Vedi Recensioni', 'recensioni');

    htp.p('<script>
      function iscriviti(){
        //così è come si dovrebbe usare il collegamento front/backend
        fetch("' || global.url || 'corsi.iscriviCorso?p_idUtente=' || v_idUtente || chr(38) || 'p_idCorso=' || p_id || '")
          .then(response => response.text()) // Trasforma la risposta del server in testo
          .then(data => {
            console.log("Risultato iscrizione:", data);
            window.location.href = "' || global.url || 'CorsoSingolo?p_idSessione=' || p_idSessione || chr(38) || 'p_id=' || p_id || '";
          })
          .catch(error => {
            console.error("Errore nella chiamata fetch:", error);
          });
      }
      function recensioni(){
        window.location.href = "' || global.url || 'Valutazioni.visualizzaValutazioni?p_idSessione=' || p_idSessione || '";
      }
      function scriviRecensione(){
        window.location.href = "' || global.url || 'visualizzaFormValutazione?p_idSessione=' || p_idSessione || chr(38) || 'p_idCorso=' || p_id || '";
      }
   </script>');
    
  baseHTML.chiudiDiv;
 
  baseHTML.chiudiPagina;
end CorsoSingolo;
/
GRANT EXECUTE ON CorsoSingolo TO anonymous;