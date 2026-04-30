create or replace procedure CorsoSingolo( p_idSessione IN NUMBER DEFAULT -1, p_id IN NUMBER DEFAULT 0 ) is
v_nome_corso Corso.titolo%TYPE;
BEGIN

  SELECT titolo INTO v_nome_corso FROM Corso WHERE p_id = idCorso;

  baseHTML.apriPagina( v_nome_corso, p_idSessione);

  Corsi.visualizzaCorso(p_id);
 
  baseHTML.chiudiPagina;
end CorsoSingolo;
/
GRANT EXECUTE ON CorsoSingolo TO anonymous;