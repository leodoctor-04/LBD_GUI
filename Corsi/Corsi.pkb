create or replace package body Corsi as

-- Lista Corsi
procedure visualizza( numero IN number DEFAULT NULL )
is 
begin
    if numero is null then
        for corso in (select titolo from Corso)
        loop
            htp.print('<p>' || corso.titolo || '</p>');
        end loop;
    else
        for corso in (select titolo from Corso fetch first numero rows only)
        loop
            htp.print('<p>' || corso.titolo || '</p>');
        end loop;
    end if; -- <--- Mancava questo
end visualizza;

end Corsi;