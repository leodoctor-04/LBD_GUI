create or replace procedure add_partecipazione(p_idsessione in number, p_cdata in date,p_idutente in number ,p_idlezione in number) is
    res number;
    idcorso_lezione NUMBER;
begin
    -- esiste la lezione
    SELECT COUNT(*) into res
    from lezione
    where lezione.idlezione = p_idlezione;

    if (res < 1) then
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la certificazione di presenza. lezione non trovata');
        return;
    end if;

    -- lezione valida
    if(gabrielli.controllaPartecipazione(p_idlezione))then 
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la certificazione di presenza. lezione non valida');
        return;
    end if;

    -- utente inscritto al corso
    SELECT count(*) into res
    from lezione,corso c
    where 
        lezione.idlezione = p_idlezione and 
        EXISTS(
            SELECT *
            from iscrizione_corso 
            where 
                iscrizione_corso.idcorso = c.idcorso and 
                iscrizione_corso.idatleta = p_idUtente
        )
    ;
    if (res < 1) then
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la certificazione di presenza. atleta non iscritto al corso');
        return;
    end if;


    -- final insert
    insert into partecipa(idatleta,idlezione)
    values (
        p_idutente,
        p_idlezione
    );

    COMMIT;
    basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) );
    return;
EXCEPTION when OTHERS then
        ROLLBACK;
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la certificazione di presenza.');
        return;
end;
/