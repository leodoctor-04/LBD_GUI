create or replace procedure add_lesson(p_idSessione in number,p_cdata in date,p_data in VARCHAR, p_inizio in VARCHAR, p_fine in VARCHAR, p_idcorso in NUMBER, p_idSala in NUMBER) is
    d date;
begin
    d := to_date(p_data,'yyyy-mm-dd');

    -- check inizio < fine

    -- check (che in realta dovrebbe essere un trigger)

    -- insert_val
    INSERT INTO LEZIONE (IdLezione, DataInizio, DataFine, IdCorso, IdSalaCorsi)
    VALUES (
        SEQ_LEZIONE.NEXTVAL, 
        TO_DATE(TO_CHAR(d, 'YYYY-MM-DD') || ' ' ||UTL_URL.UNESCAPE(p_inizio, 'UTF-8'), 
                        'YYYY-MM-DD HH24:MI'),
        TO_DATE(TO_CHAR(d, 'YYYY-MM-DD') || ' ' ||UTL_URL.UNESCAPE(p_fine, 'UTF-8'), 
                        'YYYY-MM-DD HH24:MI'),
        p_idcorso, 
        p_idsala 
    );

    COMMIT;

    basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') );
    return;
EXCEPTION 
    when others then
        ROLLBACK;
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la creazione della lezione' );
        return;
end;