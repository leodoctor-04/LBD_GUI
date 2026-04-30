create or replace procedure delete_partecipazione(p_idsessione in number, p_cdata in date,p_idutente in number ,p_idlezione in number) is
    res number;
begin
    -- esiste la partecipazione
    SELECT COUNT(*) into res
    from partecipa 
    where idatleta = p_idutente and idlezione = p_idlezione;

    if (res < 1) then
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la rimozione della presenza. partecipazione non trovata');
        return;
    end if;

    -- final insert
    delete from partecipa 
    where idatleta = p_idutente and idlezione = p_idlezione;

    COMMIT;
    basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) );
    return;
EXCEPTION when OTHERS then
        ROLLBACK;
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la rimozione della presenza.');
        return;
end;
/