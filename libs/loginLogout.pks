create or replace PACKAGE loginLogout AS

function creaSessione(p_nomeUtente IN CREDENZIALI.Username%TYPE, p_password IN CREDENZIALI.Password%TYPE, p_idSessione OUT SESSIONI.IdSessione%TYPE, p_sessioneDuplicata OUT boolean) return boolean;

function aggiornaSessione(p_idSessione IN SESSIONI.IdSessione%TYPE) return boolean;

procedure login(p_username IN CREDENZIALI.Username%TYPE DEFAULT NULL, p_password IN CREDENZIALI.Password%TYPE DEFAULT NULL, , p_idSessione OUT SESSIONI.IdSessione%TYPE);

procedure logout(p_idSessione IN SESSIONI.IdSessione%TYPE);

function controllaSessione(p_idSessione IN SESSIONI.IdSessione%TYPE) return boolean;

END loginLogout;