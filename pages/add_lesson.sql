create or replace procedure add_lesson(p_idSessione in number,p_cdata in date,p_data in VARCHAR, p_inizio in VARCHAR, p_fine in VARCHAR, p_idcorso in NUMBER, p_idSala in NUMBER) is
    d date;
    sres number;
    d_inizio date; 
    d_fine date; 
begin
    -- controlla diritti
    if(sessioneUtente.controllaIstruttore(p_idSessione)) then
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la creazione della lezione. diritti invalidi' );
        RETURN;
    end if;

    d := to_date(p_data,'yyyy-mm-dd');

    d_inizio := TO_DATE(TO_CHAR(d, 'YYYY-MM-DD') || ' ' ||UTL_URL.UNESCAPE(p_inizio, 'UTF-8'), 
                    'YYYY-MM-DD HH24:MI');
    d_fine := TO_DATE(TO_CHAR(d, 'YYYY-MM-DD') || ' ' ||UTL_URL.UNESCAPE(p_fine, 'UTF-8'), 
                    'YYYY-MM-DD HH24:MI');

    -- check inizio < fine
    if(
        d_inizio
        > 
        d_fine
    ) then
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la creazione della lezione. orario invalido' );
        return;
    end if;


    -- check (che in realta dovrebbe essere un trigger)
    select count(*) into sres
    from lezione
    where 
        lezione.idSalaCorsi = p_idsala and 
        lezione.dataInizio between d_inizio and  d_fine and
        lezione.datafine between d_inizio and  d_fine;

    if (sres >= 1) THEN
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la creazione della lezione. la lezione collide con una lezione gia esistente' );
        return;
    end if;


    -- insert_val
    INSERT INTO LEZIONE (IdLezione, DataInizio, DataFine, IdCorso, IdSalaCorsi)
    VALUES (
        SEQ_LEZIONE.NEXTVAL, 
        d_inizio,
        d_fine,
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