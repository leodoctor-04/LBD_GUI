CREATE OR REPLACE PACKAGE gabrielli AS
	
	-- Commenti sulle procedure eventualmente obsoleti/sbagliati/mancanti.

	-----------------------------------------------------
	-- [Statistiche] - [UTILITY] - [UI]
	-----------------------------------------------------

	-- SOLO ISCRITTI (NO PARTECIPAZIONI A CORSI DISISCRITTI)
	PROCEDURE frequentazioneCorsi(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idAtleta   IN ATLETA.IdUtente%TYPE DEFAULT NULL
	);
	
	FUNCTION getAge(
		p_idUtente IN UTENTE.IdUtente%TYPE
	) return number;

	PROCEDURE infoUtente(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idUtente IN UTENTE.IdUtente%TYPE DEFAULT NULL
	);

	PROCEDURE init_popup;

	PROCEDURE popup(
		p_msg IN varchar2
	);

	-----------------------------------------------------
	-- Sale corsi
	-----------------------------------------------------

	/* restituisce true se:
	1. sala_corsi è disponibile in [inizio, fine] */
	FUNCTION salaDisponibile(
		p_idSala IN SALA_CORSI.IdSala%TYPE,
		p_start IN date,
		p_end IN date
	) return number;

	PROCEDURE visualizzaSale(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_dataInizio IN varchar2 DEFAULT NULL,
		p_dataFine IN varchar2 DEFAULT NULL,
		p_err IN number DEFAULT 0
	);

	-----------------------------------------------------
	-- Partecipazioni
	-----------------------------------------------------

	/* restituisce true se (lezione nel futuro):
	1. lezione.dataInizio > sysdate */
	FUNCTION mostraPartecipa(
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) return boolean;
	
	/* [->calendario?] aggiunge la partecipazione se:
	1. id_sessione è di atleta
	2. atleta iscritto corso
	3. partecipazione non già presente
	4. controllaPartecipazione() */
	PROCEDURE partecipa(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idLezione IN LEZIONE.IdLezione%TYPE
	);
	
	/* data una lezione controlla:
	1. sum partecipazioni < sala.capienza
	2. sala valida
	3. sum partecipazioni < corso.maxPartecipanti
	4. stato corso */
	FUNCTION controllaPartecipazione(
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) return boolean;

	/* restituisce 1 [true] se (lezione nel passato):
	1. lezione.dataFine <= sysdate */
	FUNCTION controllaLezione(
		p_idLezione IN LEZIONE.IdLezione%TYPE
	) return number;

	PROCEDURE visualizzaPartecipazioni(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_err number DEFAULT 0
	);

	PROCEDURE eliminaPartecipazione(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idLezione  IN LEZIONE.IdLezione%TYPE
	);

	-----------------------------------------------------
	-- Atleta
	-----------------------------------------------------

	/* per collegamento -> frequentazioneCorsi */
	PROCEDURE visualizzaAtleti(
		p_idSessione IN SESSIONI.IdSessione%TYPE
	);

	-----------------------------------------------------
	-- Iscrizione corso
	-----------------------------------------------------

	PROCEDURE visualizzaIscrizioni(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_err number DEFAULT 0
	);

	/* iscrive atleta se:
	1. idSessione -> atleta
	2. ha un abbonamento attivo all_inclusive o che comprende il corso */
	PROCEDURE creaIscrizione(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idCorso IN CORSO.IdCorso%TYPE
	);
	
	/* elimina iscrizione solo se:
	1. idSessione -> atleta
	2. iscrizione presente
	3. relativa a corso non finito: sysdate < fine */
	PROCEDURE eliminaIscrizione(
		p_idSessione IN SESSIONI.IdSessione%TYPE,
		p_idCorso IN CORSO.IdCorso%TYPE
	);

END gabrielli;