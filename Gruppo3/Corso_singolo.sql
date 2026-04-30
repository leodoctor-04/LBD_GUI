create or replace procedure CorsoSingolo( p_idSessione IN NUMBER DEFAULT -1, p_id IN NUMBER DEFAULT 0 ) is
v_nome_corso Corso.titolo%TYPE;
BEGIN

  SELECT titolo INTO v_nome_corso FROM Corso WHERE p_id = idCorso;

  baseHTML.apriPagina( v_nome_corso, p_idSessione);

  Corsi.visualizzaCorso(p_id);
  
  -- baseHTML.apriDiv('modulo', stile=>'display: flex; justify-content: space-evenly; margin-bottom: 2.5vw;');
  -- -- IF IS NOT iscritto
  --   baseHTML.bottone('iscriviti');
  --   baseHTML.bottone('vedi Recensioni');
  --   -- ELSE
  --   baseHTML.bottone('recensisci');
  -- baseHTML.chiudiDiv;
 
  baseHTML.chiudiPagina;
end CorsoSingolo;
/
GRANT EXECUTE ON CorsoSingolo TO anonymous;