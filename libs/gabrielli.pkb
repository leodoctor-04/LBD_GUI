CREATE OR REPLACE PACKAGE BODY gabrielli AS

	-- Variabili globali visibili al package
	g_package_corsi CONSTANT varchar2(100) := 'Corsi' || '.';
	g_corsi_firma CONSTANT varchar2(100) := 'visualizzaCorso?p_id=';

	PROCEDURE init_popup IS
	BEGIN
		htp.p(q'[
			<dialog id="globalDialog">
				<h3 id="dlgTitle"></h3>
				<p id="dlgMessage"></p>
				<button onclick="closeDialog()">Chiudi</button>
			</dialog>

			<script>
			function showDialog(title, message){
				document.getElementById('dlgTitle').textContent = title;
				document.getElementById('dlgMessage').textContent = message;
				document.getElementById('globalDialog').showModal();
			}

			function closeDialog(){
				document.getElementById('globalDialog').close();
			}
			</script>
		]');
	END;

	PROCEDURE popup(
		p_msg IN varchar2
	) IS
	BEGIN
		htp.p(
			'<script>' ||
			'showDialog("Errore",' ||
			'"' || REPLACE(p_msg,'"','\"') || '"' ||
			');</script>'
		);
	END;

	PROCEDURE infoUtente(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idUtente IN UTENTE.IdUtente%TYPE DEFAULT NULL
	) IS
		v_idUtente SESSIONI.IdUtente%TYPE;
		v_isAmministratore number(1);
		v_idTarget UTENTE.IdUtente%TYPE;
		v_username CREDENZIALI.Username%TYPE;
		v_attendanceRate number;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IdUtente, IsAmministratore
			INTO v_idUtente, v_isAmministratore
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;

		if p_idUtente IS NULL then
			v_idTarget := v_idUtente;
		else
			if v_isAmministratore = 0 then	-- [NO AMMINISTRATORE]
				RAISE errori.ex_no_permessi;
			end if;

			v_idTarget := p_idUtente;
		end if;

		DECLARE
			v_dummy number(1);
		BEGIN
			SELECT 1
			INTO v_dummy
			FROM UTENTE
			WHERE IdUtente = v_idTarget;
		EXCEPTION
			when NO_DATA_FOUND then
				RAISE errori.ex_no_target;	-- [NO UTENTE]
		END;

		BEGIN
			SELECT Username
			INTO v_username
			FROM CREDENZIALI
			WHERE IdUtente = v_idTarget;
		END;

		baseHTML.apriPagina(
			titolo => 'Frequentazione corsi',
			p_idSessione => p_idSessione
		);

		DECLARE
			v_nome UTENTE.NOME%TYPE;
			v_cognome UTENTE.COGNOME%TYPE;
			v_email UTENTE.EMAIL%TYPE;
			v_stato UTENTE.STATO%TYPE;
		BEGIN
			SELECT Nome, Cognome, Email, Stato
			INTO v_nome, v_cognome, v_email, v_stato
			FROM UTENTE
			WHERE IdUtente = v_idTarget;

			baseHTML.apriDiv('panoramica');
				baseHTML.apriDiv;
					baseHTML.h1(
						'Informazioni utente: ' || v_username,
						'padding-top:3vw;');
					baseHTML.paragrafo('Nome: ' || v_nome);
					baseHTML.paragrafo('Cognome: ' || v_cognome);
					baseHTML.paragrafo('Email: ' || v_email);
					baseHTML.paragrafo('Età: ' || getAge(v_idTarget));
					baseHTML.paragrafo('Stato: ' || v_stato);
				baseHTML.chiudiDiv;
			baseHTML.chiudiDiv;
		END;

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	PROCEDURE visualizzaAtleti(
		p_idSessione IN SESSIONI.IdSessione%TYPE
	) IS
		v_isAmministratore number(1);
		v_idAmministratore SESSIONI.IdUtente%TYPE;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IsAmministratore, IdUtente
			INTO v_isAmministratore, v_idAmministratore
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAmministratore = 0 then
			RAISE errori.ex_no_permessi;
		end if;

		baseHTML.apriPagina(
			'Fitzone',
			p_idSessione
		);

		baseHTML.h1(
			'Visualizza atleti',
			'margin-top:15px; margin-bottom:0px; text-align: center; color:white;'
		);

		baseHTML.apriTabella;
		baseHTML.inizioRiga;
		baseHTML.inserisciIntestazione('IdAtleta');
		baseHTML.inserisciIntestazione('Nome e cognome');
		baseHTML.inserisciIntestazione('Dettagli');
		baseHTML.fineRiga;

		for v_rec in (
			SELECT u.IdUtente,
				u.Nome,
				u.Cognome
			FROM ATLETA a
				JOIN UTENTE u ON a.IdUtente = u.IdUtente
			ORDER BY u.IdUtente ASC
		) loop
			baseHTML.inizioRiga;
				baseHTML.inserisciCella(v_rec.IdUtente);
				baseHTML.apriCella;
					baseHTML.collegamento(
						v_rec.Nome||' '||v_rec.Cognome,
						global.url||'gabrielli.infoUtente?p_idSessione='||p_idSessione
						||'&p_idUtente='||v_rec.IdUtente);
				baseHTML.chiudiCella;
				baseHTML.apriCella;
					baseHTML.collegamento(
						'Frequentazione corsi',
						global.url||'gabrielli.frequentazioneCorsi?p_idSessione='
						||p_idSessione||'&p_idAtleta='||v_rec.IdUtente);
				baseHTML.chiudiCella;
			baseHTML.fineRiga;
		end loop;

		baseHTML.chiudiTabella;
		baseHTML.chiudiPagina;

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	PROCEDURE frequentazioneCorsi(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idAtleta IN ATLETA.IdUtente%TYPE DEFAULT NULL
	) AS
		v_idUtente SESSIONI.IdUtente%TYPE;
		v_isAtleta number(1);
		v_isAmministratore number(1);
		v_idTarget ATLETA.IdUtente%TYPE;
		v_username CREDENZIALI.Username%TYPE;
		v_attendanceRate number;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IdUtente, IsAtleta, IsAmministratore
			INTO v_idUtente, v_isAtleta, v_isAmministratore
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;

		if p_idAtleta IS NULL then
			if v_isAtleta = 0 then
				RAISE errori.ex_no_target; -- [NO ATLETA]
			end if;

			v_idTarget := v_idUtente;
		else
			if v_isAmministratore = 0 then
				RAISE errori.ex_no_target; -- [NO AMMINISTRATORE]
			end if;

			v_idTarget := p_idAtleta;
		end if;

		DECLARE
			v_dummy number(1);
		BEGIN
			SELECT 1
			INTO v_dummy
			FROM ATLETA
			WHERE IdUtente = v_idTarget;
		EXCEPTION
			when NO_DATA_FOUND then
				RAISE errori.ex_no_target; -- [NO ATLETA]
		END;

		BEGIN
			SELECT Username
			INTO v_username
			FROM CREDENZIALI
			WHERE IdUtente = v_idTarget;
		END;

		baseHTML.apriPagina(
			titolo => 'Frequentazione corsi',
			p_idSessione => p_idSessione
		);

		baseHTML.h1(
			'Atleta: '||v_username,
			'margin-top:15px; margin-bottom:0px; text-align: center; color:white;'
		);

		baseHTML.apriTabella;
		baseHTML.inizioRiga;
		baseHTML.inserisciIntestazione('Corso-ID');
		baseHTML.inserisciIntestazione('Frequentazione');
		baseHTML.fineRiga;

		for v_rec IN (
			SELECT
				c.IdCorso,
				c.Titolo,
				COUNT(DISTINCT l.IdLezione) AS TotLezioni,
				COUNT(DISTINCT p.IdLezione) AS TotPresenze
			FROM CORSO c
				JOIN ISCRIZIONE_CORSO ic
					ON c.IdCorso = ic.IdCorso
				LEFT JOIN LEZIONE l
					ON c.IdCorso = l.IdCorso
					AND controllaLezione(l.IdLezione) = 1
				LEFT JOIN PARTECIPA p
					ON p.IdLezione = l.IdLezione
					AND p.IdAtleta = v_idTarget
			WHERE ic.IdAtleta = v_idTarget
			GROUP BY c.IdCorso, c.Titolo
			ORDER BY c.Titolo
		) loop
			v_attendanceRate := 0;

			if v_rec.TotLezioni > 0 then
				v_attendanceRate :=
					(v_rec.TotPresenze / v_rec.TotLezioni) * 100;
			end if;

			baseHTML.inizioRiga;
			baseHTML.apriCella;
			baseHTML.collegamento(
				v_rec.Titolo || '-' || v_rec.IdCorso,
				global.url || g_package_corsi ||
				g_corsi_firma || v_rec.IdCorso
			);
			baseHTML.chiudiCella;
			baseHTML.inserisciCella(ROUND(v_attendanceRate, 2) || '%');
			baseHTML.fineRiga;
		end loop;

		baseHTML.chiudiTabella;
		baseHTML.chiudiPagina;

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	FUNCTION salaDisponibile(
		p_idSala IN SALA_CORSI.IdSala%TYPE,
		p_start IN date,
		p_end IN date
	) return number AS
	BEGIN
		for v_rec in (
			SELECT l.DataInizio, l.DataFine
			FROM LEZIONE l
				JOIN SALA_CORSI s ON l.IdSalaCorsi = s.IdSala
			WHERE s.IdSala = p_idSala
		) loop
			if (v_rec.DataInizio < p_end)
				AND (v_rec.DataFine > p_start) then
				return 0;
			end if;
		end loop;

		return 1;

	EXCEPTION
		when OTHERS then
			errori.gestisci;
	END;

	PROCEDURE visualizzaSale(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_dataInizio IN varchar2 DEFAULT NULL,
		p_dataFine IN varchar2 DEFAULT NULL,
		p_err IN number DEFAULT 0
	) AS
		v_isAmministratore number(1);
		v_dataInizio date;
		v_dataFine date;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IsAmministratore
			INTO v_isAmministratore
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAmministratore = 0 then
			RAISE errori.ex_no_permessi;
		end if;

		if p_dataInizio IS NOT NULL then
			v_dataInizio := TO_DATE(p_dataInizio, 'YYYY-MM-DD');
		end if;
		if p_dataFine IS NOT NULL then
			v_dataFine := TO_DATE(p_dataFine, 'YYYY-MM-DD');
		end if;

		if v_dataInizio IS NOT NULL AND v_dataFine IS NOT NULL then
			if v_dataInizio >= v_dataFine then
				owa_util.redirect_url(
					global.root || 'gabrielli.visualizzaSale?p_idSessione=' 
					|| p_idSessione || '&p_err=1'
				);
				return;
			end if;
		end if;

		init_popup;
		if p_err = 1 then
			popup('Intervallo date non valido.');
		end if;

		baseHTML.apriPagina(
			titolo => 'Sale corsi',
			p_idSessione => p_idSessione
		);

		baseHTML.h1(
			'Sale corsi',
			'margin-top:15px; margin-bottom:0px; text-align: center; color:white;'
		);

		baseHTML.apriDiv('modulo');
		baseHTML.apriModulo(
			action => global.root || 'gabrielli.visualizzaSale'
		);
			baseHTML.inserisciInput(
				id => '',
				tipo => 'hidden',
				nome => 'p_idSessione',
				valore => p_idSessione
			);
			baseHTML.inserisciInput(
				id => 'Inizio intervallo',
				tipo => 'date',
				nome => 'p_dataInizio',
				valore => CASE
							when v_dataInizio IS NOT NULL
							then TO_CHAR(v_dataInizio,'YYYY-MM-DD')
						END
			);
			baseHTML.inserisciInput(
				id => 'Fine intervallo',
				tipo => 'date',
				nome => 'p_dataFine',
				valore => CASE
							when v_dataFine IS NOT NULL
							then TO_CHAR(v_dataFine,'YYYY-MM-DD')
						END
			);
			baseHTML.inserisciInput(
				id => '',
				tipo => 'submit',
				nome => '',
				valore => 'Filtra'
			);
			baseHTML.collegamento(
				'Mostra tutte',
				global.root || 'gabrielli.visualizzaSale?p_idSessione=' || p_idSessione
			);
		baseHTML.chiudiModulo;
		baseHTML.chiudiDiv;

		baseHTML.apriTabella;
		baseHTML.inizioRiga;
		baseHTML.inserisciIntestazione('Sala-ID');
		baseHTML.inserisciIntestazione('Capienza');
		baseHTML.inserisciIntestazione('Stato');
		baseHTML.fineRiga;

		for v_rec IN (
			SELECT
				s.IdSala,
				s.CapienzaMassima,
				s.Stato
			FROM SALA_CORSI s
			WHERE (
				v_dataInizio IS NULL
				OR v_dataFine IS NULL
				OR salaDisponibile(
					s.IdSala,
					v_dataInizio,
					v_dataFine
				) = 1
			)
			ORDER BY s.CapienzaMassima
		) loop
			baseHTML.inizioRiga;
			baseHTML.inserisciCella(v_rec.IdSala);
			baseHTML.inserisciCella(v_rec.CapienzaMassima);
			baseHTML.inserisciCella(v_rec.Stato);
			baseHTML.fineRiga;
		end loop;

		baseHTML.chiudiTabella;
		baseHTML.chiudiPagina;

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	FUNCTION controllaLezione(
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) return number AS
	BEGIN
		DECLARE
			v_dummy number(1);
		BEGIN
			SELECT 1
			INTO v_dummy
			FROM LEZIONE
			WHERE IdLezione = p_idLezione
				AND DataFine <= SYSDATE;
		EXCEPTION
			when NO_DATA_FOUND then
				return 0;
		END;
		
		return 1;

	EXCEPTION
		when OTHERS then
			errori.gestisci;
	END;

	FUNCTION getAge(
		p_idUtente IN UTENTE.IdUtente%TYPE
	) return number AS
		v_nascita date;
	BEGIN
		BEGIN
			SELECT DataNascita
			INTO v_nascita
			FROM UTENTE
			WHERE IdUtente = p_idUtente;
		EXCEPTION
			when NO_DATA_FOUND then
				return -1;
		END;
		
		return TRUNC(MONTHS_BETWEEN(sysdate, v_nascita) / 12);
	
	EXCEPTION
		when OTHERS then
			errori.gestisci;
	END;

	FUNCTION mostraPartecipa(
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) return boolean AS
		v_lezione date;
	BEGIN
		BEGIN
			SELECT DataInizio
			INTO v_lezione
			FROM LEZIONE
			WHERE IdLezione = p_idLezione;
		EXCEPTION
			when NO_DATA_FOUND then
				return FALSE;
		END;

		return v_lezione > sysdate;

	EXCEPTION
		when OTHERS then
			errori.gestisci;
	END;

	-- <PACKAGE> -> partecipa

	PROCEDURE partecipa(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) AS
		v_isAtleta number(1);
		v_idAtleta SESSIONI.IdUtente%TYPE;
		v_iscritto number(1);
		v_count number;
	BEGIN
		DBMS_OUTPUT.PUT_LINE('debug0');
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			DBMS_OUTPUT.PUT_LINE('debug1');
			RAISE errori.ex_sessione_non_valida;
			return;
		end if;

		BEGIN
			SELECT IsAtleta, IdUtente
			INTO v_isAtleta, v_idAtleta
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAtleta = 0 then
			DBMS_OUTPUT.PUT_LINE('debug2');
			RAISE errori.ex_no_permessi;
			return;
		end if;

		BEGIN
			SELECT 1
			INTO v_iscritto
			FROM DUAL
			WHERE EXISTS (
				SELECT 1
				FROM LEZIONE l
					JOIN CORSO c ON l.IdCorso = c.IdCorso
					JOIN ISCRIZIONE_CORSO ic ON ic.IdCorso = c.IdCorso
				WHERE l.IdLezione = p_idLezione
					AND ic.IdAtleta = v_idAtleta
			);
		EXCEPTION
			when NO_DATA_FOUND then
				v_iscritto := 0;
		END;
		if v_iscritto = 0 then
			DBMS_OUTPUT.PUT_LINE('debug3');
			owa_util.redirect_url(
				global.root ||
				'gabrielli.visualizzaIscrizioni?p_idSessione=' ||
				p_idSessione || '&p_err=3'
			);	-- [NO ISCRITTO]
			return;
		end if;

		if controllaLezione(p_idLezione) = 1 then
			DBMS_OUTPUT.PUT_LINE('debug4'); -- oppure calendario?
			owa_util.redirect_url(
				global.root ||
				'gabrielli.visualizzaPartecipazioni?p_idSessione=' ||
				p_idSessione || '&p_err=4'
			); -- [LEZIONE PASSATA]
			return;
		end if;

		if NOT controllaPartecipazione(p_idLezione) then
			DBMS_OUTPUT.PUT_LINE('debug5'); -- oppure calendario?
			owa_util.redirect_url(
				global.root ||
				'gabrielli.visualizzaPartecipazioni?p_idSessione=' ||
				p_idSessione || '&p_err=2'
			); -- [CAPIENZA MASSIMA RAGGIUNTA, STATO SALA O CORSO]
			return;
		end if;

		BEGIN
			INSERT INTO PARTECIPA (IdAtleta, IdLezione)
			VALUES (v_idAtleta, p_idLezione);
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('debug6');
		EXCEPTION
			when DUP_VAL_ON_INDEX then
				DBMS_OUTPUT.PUT_LINE('debug7');  -- oppure calendario?
				owa_util.redirect_url(
					global.root ||
					'gabrielli.visualizzaPartecipazioni?p_idSessione=' ||
					p_idSessione || '&p_err=3'
				); -- [PARTECIPAZIONE DUPLICATA]
				return;
		END;

		DBMS_OUTPUT.PUT_LINE('debug8');
		owa_util.redirect_url(
			global.root ||
			'gabrielli.visualizzaPartecipazioni?p_idSessione=' ||
			p_idSessione
		);

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	FUNCTION controllaPartecipazione(
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) return boolean AS
		v_partecipanti number;
		v_capienzaSala number;	
		v_statoSala SALA_CORSI.stato%TYPE;
		v_capienzaCorso number;
		v_statoCorso CORSO.stato%TYPE;
	BEGIN
		BEGIN			
			SELECT COUNT(*)
			INTO v_partecipanti
			FROM LEZIONE l
				JOIN PARTECIPA p ON l.Idlezione = p.Idlezione
			WHERE l.IdLezione = p_idLezione;
		
			SELECT s.CapienzaMassima, s.Stato
			INTO v_capienzaSala, v_statoSala
			FROM LEZIONE l
				JOIN SALA_CORSI s ON l.IdSalaCorsi = s.IdSala
			WHERE l.IdLezione = p_idLezione;

			SELECT c.maxPartecipanti, c.Stato
			INTO v_capienzaCorso, v_statoCorso
			FROM LEZIONE l
				JOIN CORSO c ON l.IdCorso = c.IdCorso
			WHERE l.IdLezione = p_idLezione;
		EXCEPTION
			when NO_DATA_FOUND then
				return FALSE;
		END;
		
		return (v_partecipanti < v_capienzaSala AND v_statoSala = 'AGIBILE')
			AND (v_partecipanti < v_capienzaCorso AND v_statoCorso = 'ATTIVO');
	
	EXCEPTION
		when OTHERS then
			errori.gestisci;
	END;

	PROCEDURE visualizzaPartecipazioni(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_err number DEFAULT 0
	) AS
		v_idAtleta SESSIONI.IdUtente%TYPE;
		v_isAtleta number(1);
		v_username CREDENZIALI.Username%TYPE;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) THEN
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IdUtente, IsAtleta
			INTO v_idAtleta, v_isAtleta
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAtleta = 0 then
			RAISE errori.ex_no_permessi;
			return;
		end if;

		init_popup;
		if p_err = 1 then
			popup('Partecipazione già avvenuta nel passato.');
		elsif p_err = 2 then
			popup('Capienza massima raggiunta oppure corso/sala inattivo/i.');
		elsif p_err = 3 then
			popup('Partecipazione già segnalata');
		elsif p_err = 4 then
			popup('Partecipazione relativa a lezione passata');
		end if;

		baseHTML.apriPagina(
			titolo => 'Partecipazioni',
			p_idSessione => p_idSessione
		);

		baseHTML.h1(
			'Partecipazioni',
			'margin-top:15px; margin-bottom:0px; text-align: center; color:white;'
		);

		baseHTML.apriTabella;
		baseHTML.inizioRiga;
		baseHTML.inserisciIntestazione('Corso-ID');
		baseHTML.inserisciIntestazione('Lezione');
		baseHTML.inserisciIntestazione('Inizio');
		baseHTML.inserisciIntestazione('Fine');
		baseHTML.inserisciIntestazione('Azioni');
		baseHTML.fineRiga;

		for v_rec IN (
			SELECT
				c.IdCorso,
				c.Titolo,
				l.IdLezione,
				l.DataInizio,
				l.DataFine
			FROM PARTECIPA p
				JOIN LEZIONE l
					ON p.IdLezione = l.IdLezione
				JOIN CORSO c
					ON l.IdCorso = c.IdCorso
			WHERE p.IdAtleta = v_idAtleta
			ORDER BY l.DataInizio DESC
		) loop
			baseHTML.inizioRiga;

			baseHTML.apriCella;
			baseHTML.collegamento(
				v_rec.Titolo || '-' || v_rec.IdCorso,
				global.url || g_package_corsi ||
				g_corsi_firma || v_rec.IdCorso
			);
			baseHTML.chiudiCella;

			baseHTML.inserisciCella(v_rec.IdLezione);
			baseHTML.inserisciCella(
				TO_CHAR(v_rec.DataInizio, 'DD/MM/YYYY HH24:MI')
			);
			baseHTML.inserisciCella(
				TO_CHAR(v_rec.DataFine, 'DD/MM/YYYY HH24:MI')
			);

			baseHTML.apriCella;
			baseHTML.collegamento(
				'Elimina',
				global.url ||
				'gabrielli.eliminaPartecipazione?p_idSessione=' ||
				p_idSessione ||
				'&p_idLezione=' ||
				v_rec.IdLezione
			);
			baseHTML.chiudiCella;

			baseHTML.fineRiga;
			end loop;

			baseHTML.chiudiTabella;
			baseHTML.chiudiPagina;

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	PROCEDURE eliminaPartecipazione(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) AS
		v_idAtleta SESSIONI.IdUtente%TYPE;
		v_isAtleta number(1);
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IdUtente, IsAtleta
			INTO v_idAtleta, v_isAtleta
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAtleta = 0 then
			RAISE errori.ex_no_permessi;
			return;
		end if;

		if NOT mostraPartecipa(p_idLezione) then
			owa_util.redirect_url(
				global.root || 
				'gabrielli.visualizzaPartecipazioni?p_idSessione=' 
				|| p_idSessione || '&p_err=1'
			);
			return;
		end if;

		BEGIN
			DELETE FROM PARTECIPA
			WHERE IdAtleta = v_idAtleta
			AND IdLezione = p_idLezione;
		END;
		if SQL%ROWCOUNT = 0 then
			-- [ATLETA NON ISCRITTO]
			return;
		end if;
	
		COMMIT;

		owa_util.redirect_url(
			global.root || 
			'gabrielli.visualizzaPartecipazioni?p_idSessione=' 
			|| p_idSessione
		);

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		WHEN OTHERS then
			errori.gestisci;
	END;

	PROCEDURE visualizzaIscrizioni(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_err number DEFAULT 0
	) AS
		v_idAtleta SESSIONI.IdUtente%TYPE;
		v_isAtleta number(1);
		v_username CREDENZIALI.Username%TYPE;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) THEN
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IdUtente, IsAtleta
			INTO v_idAtleta, v_isAtleta
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAtleta = 0 then
			RAISE errori.ex_no_permessi;
		end if;

		init_popup;
		if p_err = 1 then
			popup('Non esiste il corso a cui ci si riferisce.');
		elsif p_err = 2 then
			popup('Iscrizione relativa a corso già sostenuto.');
		elsif p_err = 3 then
			popup('Non sei iscritto al corso.');
		elsif p_err = 4 then
			popup('Impossibile rimuovere iscrizione non esistente.');
		elsif p_err = 5 then
			popup('Il tuo abbonamento non include questo corso.');
		elsif p_err = 6 then
			popup('Sei già iscritto al corso.');
		end if;

		baseHTML.apriPagina(
			titolo => 'Iscrizioni',
			p_idSessione => p_idSessione
		);

		baseHTML.h1(
			'Iscrizioni',
			'margin-top:15px; margin-bottom:0px; text-align: center; color:white;'
		);

		baseHTML.apriTabella;
		baseHTML.inizioRiga;
		baseHTML.inserisciIntestazione('Corso-ID');
		baseHTML.inserisciIntestazione('Inzio');
		baseHTML.inserisciIntestazione('Fine');
		baseHTML.inserisciIntestazione('Azioni');
		baseHTML.fineRiga;

		for v_rec in (
			SELECT
				c.IdCorso,
				c.Titolo,
				c.DataCreazione,
				c.Durata
			FROM ISCRIZIONE_CORSO ic
			JOIN CORSO c
				ON ic.IdCorso = c.IdCorso
			WHERE ic.IdAtleta = v_idAtleta
			ORDER BY c.DataCreazione DESC
		) loop
			baseHTML.inizioRiga;

			baseHTML.apriCella;
			baseHTML.collegamento(
				v_rec.Titolo || '-' || v_rec.IdCorso,
				global.url || g_package_corsi ||
				g_corsi_firma || v_rec.IdCorso
			);
			baseHTML.chiudiCella;

			baseHTML.inserisciCella(
				TO_CHAR(v_rec.DataCreazione, 'DD/MM/YYYY')
			);

			baseHTML.inserisciCella(
				TO_CHAR(add_months(v_rec.DataCreazione, v_rec.Durata), 'DD/MM/YYYY')
			);

			baseHTML.apriCella;
			baseHTML.collegamento(
				'Elimina',
				global.url || 'gabrielli.eliminaIscrizione?p_idSessione=' ||
				p_idSessione || '&p_idCorso=' || v_rec.IdCorso
			);
			baseHTML.chiudiCella;
			baseHTML.fineRiga;
		end loop;

		baseHTML.chiudiTabella;
		baseHTML.chiudiPagina;

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	-- <PACKAGE> -> creaIscrizione

	PROCEDURE creaIscrizione(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idCorso IN CORSO.IdCorso%TYPE
	) AS
		v_isAtleta number(1);
		v_idAtleta SESSIONI.IdUtente%TYPE;
		v_dataFine date;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IsAtleta, IdUtente
			INTO v_isAtleta, v_idAtleta
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAtleta = 0 then
			RAISE errori.ex_no_permessi;
		end if;

		BEGIN
			SELECT add_months(DataCreazione, Durata)
			INTO v_dataFine
			FROM CORSO
			WHERE IdCorso = p_idCorso;
		EXCEPTION
			when NO_DATA_FOUND then
				owa_util.redirect_url(
					global.root || 
					'gabrielli.visualizzaIscrizioni?p_idSessione=' 
					|| p_idSessione || '&p_err=1'
				);
				return;
		END;

		if sysdate > v_dataFine then
			owa_util.redirect_url(
				global.root || 
				'gabrielli.visualizzaIscrizioni?p_idSessione=' 
				|| p_idSessione || '&p_err=2'
			);
			return;
		end if;

		DECLARE
			v_abilitato number(1);
		BEGIN
			SELECT 1
			INTO v_abilitato
			FROM DUAL
			WHERE EXISTS (
				SELECT 1
				FROM ABBONAMENTO ab
				WHERE ab.IdAtleta = v_idAtleta
					AND sysdate BETWEEN ab.DataInizio AND ab.DataFine
					AND (
						EXISTS (
							SELECT 1
							FROM ABB_ALL_INCLUSIVE aai
							WHERE aai.IdAbbonamento = ab.IdAbbonamento
						)
						OR
						EXISTS (
							SELECT 1
							FROM ABBONAMENTO_COMPRENDE_CORSO acc
							WHERE acc.IdAbbonamento = ab.IdAbbonamento
							AND acc.IdCorso = p_idCorso
						)
					)
			);
		EXCEPTION
			when NO_DATA_FOUND then
				DBMS_OUTPUT.PUT_LINE('debug: NO ABBONAMENTO');
				owa_util.redirect_url(
					global.root || 'gabrielli.visualizzaIscrizioni?p_idSessione=' ||
					p_idSessione || '&p_err=5'
				); -- [NO ABBONAMENTO]
				return;
		END;

		BEGIN
			INSERT INTO ISCRIZIONE_CORSO (IdAtleta, IdCorso)
			VALUES (v_idAtleta, p_idCorso);

			COMMIT;
		EXCEPTION
			when DUP_VAL_ON_INDEX then
				DBMS_OUTPUT.PUT_LINE('debug: ISCRIZIONE DUPLICATA');
				owa_util.redirect_url(
					global.root || 'gabrielli.visualizzaIscrizioni?p_idSessione=' ||
					p_idSessione || '&p_err=6'
				); -- [ISCRIZIONE DUPLICATA]
				return;
		END;

		owa_util.redirect_url(
			global.root || 'gabrielli.visualizzaIscrizioni?p_idSessione=' ||
			p_idSessione
		);
	
	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

	PROCEDURE eliminaIscrizione(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idCorso IN CORSO.IdCorso%TYPE
	) AS
		v_isAtleta number(1);
		v_idAtleta SESSIONI.IdUtente%TYPE;
		v_dataFine date;
	BEGIN
		if NOT sessioneUtente.controllaSessione(p_idSessione) then
			RAISE errori.ex_sessione_non_valida;
		end if;

		BEGIN
			SELECT IsAtleta, IdUtente
			INTO v_isAtleta, v_idAtleta
			FROM SESSIONI
			WHERE IdSessione = p_idSessione;
		END;
		if v_isAtleta = 0 then
			RAISE errori.ex_no_permessi;
		end if;

		BEGIN
			SELECT add_months(DataCreazione, Durata)
			INTO v_dataFine
			FROM CORSO
			WHERE IdCorso = p_idCorso;
		EXCEPTION
			when NO_DATA_FOUND then
				owa_util.redirect_url(
					global.root || 
					'gabrielli.visualizzaIscrizioni?p_idSessione=' 
					|| p_idSessione || '&p_err=1'
				);
				return;
		END;

		if sysdate > v_dataFine then
			owa_util.redirect_url(
				global.root || 
				'gabrielli.visualizzaIscrizioni?p_idSessione=' 
				|| p_idSessione || '&p_err=2'
			);
			return;
		end if;

		BEGIN
			DELETE FROM ISCRIZIONE_CORSO
			WHERE IdCorso = p_idCorso
			AND IdAtleta = v_idAtleta;
		END;
		if SQL%ROWCOUNT = 0 then
			owa_util.redirect_url(
				global.root || 
				'gabrielli.visualizzaIscrizioni?p_idSessione=' 
				|| p_idSessione || '&p_err=3'
			); -- [ATLETA NON ISCRITTo]
			return;
		end if;
		
		COMMIT;	-- trg_eliminaPARTECIPA -> `DELETE FROM PARTECIPA`

		owa_util.redirect_url(
			global.root || 
			'gabrielli.visualizzaIscrizioni?p_idSessione=' 
			|| p_idSessione
		);

	EXCEPTION
		when errori.ex_sessione_non_valida then
			errori.gestisciSessioneNonValida;
		when errori.ex_no_permessi then
			errori.gestisciNoPermessi(p_idSessione);
		when errori.ex_no_target then
			errori.gestisciNoTarget(p_idSessione);
		when OTHERS then
			errori.gestisci;
	END;

END gabrielli;
