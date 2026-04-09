create or replace PACKAGE BODY files_orcl2526_api AS

-- Ogni procedura differisce dall'altra per il parametro passato
-- a OWA_UTIL.mime_header, per altri tipi consultare il sito
-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types

PROCEDURE GetHtml (p_name  IN  files_orcl2526.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2526
  WHERE  name = p_name;
  OWA_UTIL.mime_header('text/html', FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.p('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END;

PROCEDURE GetCss (p_name  IN  files_orcl2526.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2526
  WHERE  name = p_name;
  OWA_UTIL.mime_header('text/css', FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.p('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END;

PROCEDURE GetJs (p_name  IN  files_orcl2526.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2526
  WHERE  name = p_name;
  OWA_UTIL.mime_header('application/javascript', FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.p('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END;

PROCEDURE GetImage (p_name  IN  files_orcl2526.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2526
  WHERE  name = p_name;
  OWA_UTIL.mime_header('image', FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.p('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END;

PROCEDURE GetText (p_name  IN  files_orcl2526.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2526
  WHERE  name = p_name;
  OWA_UTIL.mime_header('text/plain', FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.p('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END;

PROCEDURE GetBinary (p_name  IN  files_orcl2526.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2526
  WHERE  name = p_name;
  OWA_UTIL.mime_header('application/octet-stream', FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.p('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END;

END;

