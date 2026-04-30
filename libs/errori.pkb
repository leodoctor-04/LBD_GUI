CREATE OR REPLACE PACKAGE BODY errori AS

	-- sessione_scaduta
	PROCEDURE gestisciSessioneNonValida IS
	BEGIN
		owa_util.redirect_url(
			global.root ||
			'home?msg=sessione_scaduta'
		);
	END;

	-- no_permessi
	PROCEDURE gestisciNoPermessi(
		p_idSessione IN SESSIONI.IdSessione%TYPE
	) IS
	BEGIN
		owa_util.redirect_url(
			global.root ||
			'home?p_idSessione=' || p_idSessione ||
			'&msg=sessione_scaduta'
		);
	END;

	-- no_target
	PROCEDURE gestisciNoTarget(
		p_idSessione IN SESSIONI.IdSessione%TYPE
	) IS
	BEGIN
		owa_util.redirect_url(
			global.root ||
			'home?p_idSessione=' || p_idSessione ||
			'&msg=sessione_scaduta'
		);
	END;

	-- errore_generale
	PROCEDURE gestisci IS
	BEGIN
		owa_util.redirect_url(
			global.root ||
			'home?msg=sessione_scaduta'
		);
	END;

END errori;