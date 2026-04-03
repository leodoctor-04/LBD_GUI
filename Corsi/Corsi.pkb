create or replace package body Corsi as

-- Lista Corsi
procedure visualizza( numero IN number DEFAULT NULL ) is
begin
    if numero is null then
        SELECT titolo BULK COLLECT INTO array_corsi FROM Corso;
    else
        SELECT titolo BULK COLLECT INTO array_corsi FROM Corso fetch first numero rows only;
    end if;
end visualizza;

end Corsi;