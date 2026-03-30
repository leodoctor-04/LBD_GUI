create or replace package body Corsi as


-- Tabella Corsi
procedure visualizza
is
begin

  for corso in 
    (select titolo from Corso)
  loop
    htp.print('<p>' || corso.titolo || '</p>');
  end loop;
end visualizza;


end Corsi;
