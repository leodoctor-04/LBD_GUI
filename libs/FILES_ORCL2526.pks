create or replace PACKAGE files_orcl2526_api AS

-- Pagine HTML
PROCEDURE GetHtml  (p_name  IN  files_orcl2526.name%TYPE);

-- Files CSS
PROCEDURE GetCss  (p_name  IN  files_orcl2526.name%TYPE);

-- Files Javascript
PROCEDURE GetJs  (p_name  IN  files_orcl2526.name%TYPE);

-- Files Immagine
PROCEDURE GetImage  (p_name  IN  files_orcl2526.name%TYPE);

-- Files di testo
PROCEDURE GetText  (p_name  IN  files_orcl2526.name%TYPE);

-- Files binari
PROCEDURE GetBinary  (p_name  IN  files_orcl2526.name%TYPE);

END;

