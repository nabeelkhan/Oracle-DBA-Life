-- ***************************************************************************
-- File: 13_13.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_13.lis

SET TERMOUT ON
SET LONG 2000
PROMPT Generating script to create database triggers...
PROMPT
DEFINE tablespace = &&tablespace
DEFINE owner = &&owner
PROMPT
SET TERMOUT OFF
SPOOL 13_13.log
CREATE TABLE migrate_triggers
(statement_sequence NUMBER NOT NULL,
 statement_text     LONG)
TABLESPACE &&tablespace
STORAGE (INITIAL 1M NEXT 1M PCTINCREASE 0);
DECLARE
   lv_sequence_num  PLS_INTEGER := 0;
   CURSOR cur_triggers IS
      SELECT trigger_name, trigger_type, triggering_event,
             table_name, referencing_names, when_clause, 
             trigger_body
      FROM   dba_triggers
      WHERE  table_owner = UPPER('&&owner')
      ORDER BY trigger_name;
BEGIN
   FOR cur_triggers_rec IN cur_triggers LOOP
      lv_sequence_num := lv_sequence_num + 1;
      INSERT INTO migrate_triggers 
      (statement_sequence, statement_text)
      VALUES 
      (lv_sequence_num, 'CREATE OR REPLACE TRIGGER ' ||
      cur_triggers_rec.trigger_name);
      lv_sequence_num := lv_sequence_num + 1;
      IF cur_triggers_rec.trigger_type LIKE 'BEFORE%' THEN
         INSERT INTO migrate_triggers 
         (statement_sequence, statement_text)
         VALUES 
         (lv_sequence_num, 'BEFORE ' ||
         cur_triggers_rec.triggering_event);
      ELSE
         INSERT INTO migrate_triggers 
         (statement_sequence, statement_text)
         VALUES 
         (lv_sequence_num, 'AFTER ' ||
         cur_triggers_rec.triggering_event);
      END IF;
      lv_sequence_num := lv_sequence_num + 1;
      INSERT INTO migrate_triggers 
      (statement_sequence, statement_text)
      VALUES 
      (lv_sequence_num, 'ON ' ||
      cur_triggers_rec.table_name);
      lv_sequence_num := lv_sequence_num + 1;
      INSERT INTO migrate_triggers 
      (statement_sequence, statement_text)
      VALUES 
      (lv_sequence_num, cur_triggers_rec.referencing_names);
      IF cur_triggers_rec.trigger_type LIKE '%EACH ROW' THEN
         lv_sequence_num := lv_sequence_num + 1;
         INSERT INTO migrate_triggers 
         (statement_sequence, statement_text)
         VALUES 
         (lv_sequence_num, 'FOR EACH ROW');
      END IF;
      IF cur_triggers_rec.when_clause IS NOT NULL THEN
         lv_sequence_num := lv_sequence_num + 1;
         INSERT INTO migrate_triggers 
         (statement_sequence, statement_text)
         VALUES 
         (lv_sequence_num, 'WHEN (' ||
         cur_triggers_rec.when_clause || ')');
      END IF;
      lv_sequence_num := lv_sequence_num + 1;
      INSERT INTO migrate_triggers 
      (statement_sequence, statement_text)
      VALUES 
      (lv_sequence_num, cur_triggers_rec.trigger_body);
      lv_sequence_num := lv_sequence_num + 1;
      INSERT INTO migrate_triggers 
      (statement_sequence, statement_text)
      VALUES 
      (lv_sequence_num, '/');
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Program Error-Begin Error Message.');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RAISE_APPLICATION_ERROR(-20000, 'End of error message');
END;
/
SPOOL OFF
SET HEADING OFF
SET PAGESIZE 0
SET FEEDBACK OFF
SPOOL 13_13.lis
SELECT   Statement_Text
FROM     migrate_triggers
ORDER BY Statement_Sequence;
SPOOL OFF
DROP TABLE migrate_triggers;
UNDEFINE tablespace
UNDEFINE owner

SPOOL OFF
