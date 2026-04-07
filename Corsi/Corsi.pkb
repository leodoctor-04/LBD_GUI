create or replace package body Corsi as

-- Lista Corsi
procedure visualizza( numero IN number DEFAULT NULL ) is
begin
    if numero is null then
        FOR corso IN ( SELECT titolo FROM Corso )
        LOOP
            baseHTML.paragrafo( corso.titolo );
        END LOOP;
    else
        FOR corso IN ( SELECT titolo FROM Corso fetch first numero rows only)
        LOOP
            baseHTML.paragrafo( corso.titolo );
        END LOOP;
    end if;
end visualizza;

end Corsi;