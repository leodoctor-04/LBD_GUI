CREATE OR REPLACE package body Valutazioni as
    procedure creaValutazione(p_idSessione IN SESSIONI.IdSessione%TYPE, p_idCorso IN NUMBER DEFAULT 2, p_votoNumerico IN NUMBER DEFAULT NULL, p_commento IN VARCHAR2 DEFAULT NULL) Is 
        v_idValutazione NUMBER;
        v_idAtleta NUMBER;
        v_iscritto BOOLEAN := false;
        v_valutato BOOLEAN := false;
        v_titoloCorso VARCHAR2(100);
        v_messaggio VARCHAR2(200);
        v_tipoMsg VARCHAR2(20) := 'errore';
    begin
        if (NOT sessioneUtente.controllaSessione(p_idSessione)) then
            htp.print('<script>window.location.href="' || global.root || 'home?msg=sessioneScaduta";</script>');
            return;
        end if;

        select Titolo into v_titoloCorso 
        from CORSO 
        where IdCorso = p_idCorso;
        
        select IdUtente into v_idAtleta 
        from SESSIONI 
        where IdSessione = p_idSessione;

        if p_votoNumerico is not null then
            begin 
                select IdAtleta into v_idAtleta
                from ISCRIZIONE_CORSO
                where IdAtleta = v_idAtleta and IdCorso = p_idCorso;
                v_iscritto := true;
            exception when NO_DATA_FOUND then v_iscritto := false;
            end;

            begin
                select IdValutazione into v_idValutazione
                from VALUTAZIONE
                where IdAtleta = v_idAtleta and IdCorso = p_idCorso;
                v_valutato := true;
            exception when NO_DATA_FOUND then v_valutato := false;
            end;

            if not v_iscritto then
                v_messaggio := 'Non sei iscritto a questo corso.';
            elsif v_valutato then
                v_messaggio := 'Hai già valutato questo corso.';
            elsif p_votoNumerico between 1 and 5 then
                insert into VALUTAZIONE(IdValutazione, VotoNumerico, CommentoTestuale, Data, IdAtleta, IdCorso)
                values(seq_valutazione.nextval, p_votoNumerico, p_commento, SYSDATE, v_idAtleta, p_idCorso);
                COMMIT;
                v_messaggio := 'Valutazione inserita con successo!';
                v_tipoMsg := 'successo';
            end if;
        end if;

        baseHTML.apriPagina('FitZone', p_idSessione);
        
        baseHTML.apriModulo(id => 'modulo', action => global.url || 'Valutazioni.creaValutazione');
            if v_messaggio is not null then
                baseHTML.apriDiv(v_tipoMsg);
                    baseHTML.paragrafo(v_messaggio);
                baseHTML.chiudiDiv;
            end if;

            baseHTML.h1('Valuta il corso ' || v_titoloCorso);
                        
            baseHTML.apriMenuTendina(id => 'Voto', nome => 'p_votoNumerico');
                for i in 1 .. 5 loop
                    baseHTML.tendinaOption(opzione => i, valore => i);
                end loop;
            baseHTML.chiudiMenuTendina;
            
            baseHTML.apriDiv;
                baseHTML.paragrafo('Inserisci un commento:', 'font-weight:600; margin-bottom: 5px;');
                baseHTML.inserisciTextArea('', nome => 'p_commento');
            baseHTML.chiudiDiv;
            
            baseHTML.inserisciInput(id => 'Sessione', tipo => 'hidden', nome => 'p_idSessione', valore => p_idSessione);
            baseHTML.inserisciInput(id => 'Corso', tipo => 'hidden', nome => 'p_idCorso', valore => p_idCorso);
            
            baseHTML.bottone('Invia Valutazione');
        baseHTML.chiudiModulo;

        baseHTML.chiudiPagina;
    end creaValutazione;

    procedure singolaValutazione(
        p_idSessione IN SESSIONI.IdSessione%TYPE, 
        p_idCorso IN CORSO.IdCorso%TYPE, 
        p_idValutazione IN VALUTAZIONE.IdValutazione%TYPE
    ) as
        v_titoloCorso   varchar2(100);
        v_votoNumerico  number;
        v_commento      varchar2(500);
        v_data          date;
        v_nomeAtleta    varchar2(200);
        
        v_isAmmin NUMBER := case when sessioneUtente.controllaAmministrativo(p_idSessione) then 1 else 0 end;
        v_isAtleta NUMBER := case when sessioneUtente.controllaAtleta(p_idSessione) then 1 else 0 end;
    begin
        if (NOT sessioneUtente.controllaSessione(p_idSessione)) then
            baseHTML.redirect(global.root || 'home?msg=sessioneScaduta');
            return;
        end if;
    
        begin
            select c.Titolo, v.VotoNumerico, v.CommentoTestuale, v.Data, u.Nome || ' ' || u.Cognome
            into v_titoloCorso, v_votoNumerico, v_commento, v_data, v_nomeAtleta
            from VALUTAZIONE v
            join CORSO c on v.IdCorso = c.IdCorso
            join UTENTE u on v.IdAtleta = u.IdUtente
            where v.IdValutazione = p_idValutazione; 
        exception 
            when NO_DATA_FOUND then
                baseHTML.apriPagina('FitZone', p_idSessione);
                baseHTML.apriModulo(id => 'modulo');
                    baseHTML.apriDiv('errore');
                        baseHTML.h1('Valutazione non trovata');
                    baseHTML.chiudiDiv;
                baseHTML.chiudiModulo;
                baseHTML.chiudiPagina;
                return;
        end;
    
        baseHTML.apriPagina('FitZone', p_idSessione);
        
        baseHTML.apriModulo(id => 'modulo', action => global.url || 'valutazioni.eliminaValutazione');
            baseHTML.h1(v_titoloCorso);
            baseHTML.apriDiv;
                
                baseHTML.paragrafo('Autore: ' || v_nomeAtleta);
                baseHTML.paragrafo('Data: ' || TO_CHAR(v_data, 'DD/MM/YYYY'));
                baseHTML.paragrafo('Voto: ' || v_votoNumerico || ' / 5');
                
                baseHTML.paragrafo('Commento:');
                baseHTML.inserisciTextArea(testo => nvl(v_commento, 'Nessun commento inserito per questa valutazione'), modificabile => false);
                
                baseHTML.inserisciInput(id => 'del_val', tipo => 'hidden', nome => 'p_idValutazione', valore => p_idValutazione);
                baseHTML.inserisciInput(id => 'del_sess', tipo => 'hidden', nome => 'p_idSessione', valore => p_idSessione);
                
            baseHTML.chiudiDiv;
            
            if v_isAmmin = 1 or v_isAtleta = 1 then
                baseHTML.bottone('Elimina questa valutazione');
            end if;

        baseHTML.chiudiModulo;
    
        baseHTML.chiudiPagina;
    end singolaValutazione;
    
    procedure eliminaValutazione(p_idSessione IN SESSIONI.IdSessione%TYPE, p_idValutazione IN NUMBER) is
    begin
        if(sessioneUtente.controllaAmministrativo(p_idSessione))then
            delete from VALUTAZIONE where IdValutazione = p_idValutazione;
            baseHTML.redirect(global.url || 'home?p_idSessione=' || p_idSessione);

        elsif(sessioneUtente.controllaAtleta(p_idSessione)) then
            delete from VALUTAZIONE where IdValutazione = p_idValutazione;
            baseHTML.redirect(global.url || 'home?p_idSessione=' || p_idSessione);

        else
            -- errore
            NULL;
        end if;
    
    end eliminaValutazione;

   procedure visualizzaValutazioni(p_idSessione IN SESSIONI.IdSessione%TYPE) is
        v_idUtente   NUMBER;
        v_isAmmin NUMBER := case when sessioneUtente.controllaAmministrativo(p_idSessione) then 1 else 0 end;
        v_isIstr  NUMBER := case when sessioneUtente.controllaIstruttore(p_idSessione) then 1 else 0 end;
        v_isAtleta NUMBER := case when sessioneUtente.controllaAtleta(p_idSessione) then 1 else 0 end;
    begin
        if (NOT sessioneUtente.controllaSessione(p_idSessione)) then
            baseHTML.redirect(global.root || 'home?msg=sessioneScaduta');
            return;
        end if;
    
        select IdUtente into v_idUtente from SESSIONI where IdSessione = p_idSessione;
    
        baseHTML.apriPagina('FitZone - Valutazioni', p_idSessione);
        baseHTML.h1('Valutazioni', 'color:white; text-align:center;');
    
        baseHTML.apriTabella;
            baseHTML.inizioRiga;
                baseHTML.inserisciIntestazione('Corso');
                baseHTML.inserisciIntestazione('Voto');
                baseHTML.inserisciIntestazione('Commento');
                baseHTML.inserisciIntestazione('Data');
                if v_isAmmin = 1 or v_isIstr = 1 then
                    baseHTML.inserisciIntestazione('Autore');
                end if;
                if v_isIstr = 0 then
                    baseHTML.inserisciIntestazione('Azioni');
                end if;
            baseHTML.fineRiga;
    
            for r in (
                select v.IdValutazione, v.IdCorso, v.VotoNumerico, v.CommentoTestuale, v.Data, 
                       c.Titolo, u.Nome || ' ' || u.Cognome as Autore
                from VALUTAZIONE v
                join CORSO c on v.IdCorso = c.IdCorso
                join UTENTE u on v.IdAtleta = u.IdUtente
                where 
                    (v_isAmmin = 1)
                    OR 
                    (v_isIstr = 1 or c.IdIstruttore = v_idUtente)
                    OR 
                    (v_isAtleta = 1 or v.IdAtleta = v_idUtente)
                order by v.Data desc
            ) loop
                baseHTML.inizioRiga;
                    baseHTML.inserisciCella(r.Titolo);
                    baseHTML.inserisciCella(r.VotoNumerico || '/5');
                    baseHTML.inserisciCella(r.CommentoTestuale);
                    baseHTML.inserisciCella(TO_CHAR(r.Data, 'DD/MM/YYYY'));
                    
                    if v_isAmmin = 1 or v_isIstr = 1 then
                        baseHTML.inserisciCella(r.Autore);
                    end if;
    
                    if v_isIstr = 0 then
                        baseHTML.apriCella;
                            baseHTML.apriModulo(action => global.url || 'valutazioni.singolaValutazione');
                                baseHTML.inserisciInput(id => 'val_'||r.IdValutazione, tipo => 'hidden', nome => 'p_idValutazione', valore => r.IdValutazione);
                                baseHTML.inserisciInput(id => 'sess_'||r.IdValutazione, tipo => 'hidden', nome => 'p_idSessione', valore => p_idSessione);
                                baseHTML.inserisciInput(id => 'corso_'||r.IdValutazione, tipo => 'hidden', nome => 'p_idCorso', valore => r.IdCorso);
                                baseHTML.bottone('Visualizza');
                            baseHTML.chiudiModulo;
                        baseHTML.chiudiCella;
                    end if;
                baseHTML.fineRiga;
            end loop;
    
        baseHTML.chiudiTabella;
        baseHTML.chiudiPagina;
    end visualizzaValutazioni;
end Valutazioni;
/
GRANT EXECUTE ON Valutazioni TO anonymous;