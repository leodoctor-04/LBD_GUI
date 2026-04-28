BEGIN
   -- 1. Elimina i Package (Sia specifica che body)
   FOR cur_rec IN (SELECT object_name, object_type FROM user_objects WHERE object_type = 'PACKAGE') LOOP
      EXECUTE IMMEDIATE 'DROP PACKAGE "' || cur_rec.object_name || '"';
   END LOOP;

   -- 2. Elimina le Procedure e Funzioni singole
   FOR cur_rec IN (SELECT object_name, object_type FROM user_objects WHERE object_type IN ('PROCEDURE', 'FUNCTION')) LOOP
      EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
   END LOOP;

   -- 3. Elimina le Sequenze
   FOR cur_rec IN (SELECT sequence_name FROM user_sequences) LOOP
      EXECUTE IMMEDIATE 'DROP SEQUENCE "' || cur_rec.sequence_name || '"';
   END LOOP;

   -- 4. Elimina le Tabelle (con vincoli)
   FOR cur_rec IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE "' || cur_rec.table_name || '" CASCADE CONSTRAINTS';
   END LOOP;
END;
/
PURGE RECYCLEBIN;