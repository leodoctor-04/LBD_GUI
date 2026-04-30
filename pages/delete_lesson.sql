create or replace procedure delete_lesson(p_idSessione in number,p_cdata in date, p_idLezione in number) is
begin

    -- controlla diritti
    if(not sessioneUtente.controllaIstruttore(p_idSessione)) then
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la rimozione della lezione. diritti invalidi' );
        RETURN;
    end if;


    DELETE from lezione
    where idlezione = p_idLezione;

    COMMIT;
    basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy'));
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        basehtml.redirect(global.root || 'calendario?p_idsessione=' || p_idSessione || chr(38) || 'p_startDate=' || to_char(p_cdata,'dd-mon-yyyy') || chr(38) || 'p_msg=errore durante la rimozione della lezione.' );
        RETURN;
end;