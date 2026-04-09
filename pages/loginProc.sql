create or replace procedure loginProc (
   p_username IN CREDENZIALI.Username%TYPE DEFAULT NULL, 
   p_password IN CREDENZIALI.Password%TYPE DEFAULT NULL
) as
    v_session_id SESSIONI.IdSessione%TYPE;
BEGIN
    sessioneUtente.login(
        p_username,
        p_password,
        v_session_id
    );
END;

/*
create or replace procedure loginProc (
   p_username IN CREDENZIALI.Username%TYPE DEFAULT NULL, 
   p_password IN CREDENZIALI.Password%TYPE DEFAULT NULL
) as
    session_id SESSIONI.IdSessione%TYPE;
BEGIN
    htp.print('hello world');
END;
*/