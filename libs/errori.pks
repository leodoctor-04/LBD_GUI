CREATE OR REPLACE PACKAGE errori AS
	ex_sessione_non_valida EXCEPTION;
	ex_no_permessi EXCEPTION;
	ex_no_target EXCEPTION;

	PROCEDURE gestisciSessioneNonValida;

	PROCEDURE gestisciNoPermessi(
		p_idSessione IN SESSIONI.IdSessione%TYPE
	);

	PROCEDURE gestisciNoTarget(
		p_idSessione IN SESSIONI.IdSessione%TYPE
	);

	PROCEDURE gestisci;
	
END errori;