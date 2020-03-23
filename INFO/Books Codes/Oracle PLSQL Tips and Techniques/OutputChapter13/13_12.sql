-- ***************************************************************************
-- File: 13_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_12.lis

SET TERMOUT ON
PROMPT Generating script to create:
PROMPT packages, procedures and functions...
PROMPT
DEFINE tablespace = &&tablespace
DEFINE owner = &&owner
PROMPT
SET TERMOUT OFF
SPOOL 13_12.log
CREATE TABLE migrate_procedures
(statement_sequence NUMBER NOT NULL, 
 statement_text     VARCHAR2(2000))
TABLESPACE &&tablespace
STORAGE (INITIAL 1M NEXT 1M PCTINCREASE 0);
DECLARE
   lv_sequence_num PLS_INTEGER := 0;
   CURSOR cur_source IS
      SELECT  name, type, line, text
      FROM    dba_source
      WHERE   owner = UPPER('&&owner')
      AND     type IN ('PACKAGE', 'PACKAGE BODY', 
                       'PROCEDURE', 'FUNCTION')
      ORDER BY DECODE(type, 'FUNCTION', '2', 'PROCEDURE', '3',
                      'PACKAGE', '1' || name || 'PA', 
                      '1' || name || 'PB'), name, line;
BEGIN
   FOR cur_source_rec IN cur_source LOOP
      IF cur_source_rec.line = 1 THEN 
         IF lv_sequence_num != 0 THEN
            lv_sequence_num := lv_sequence_num + 1;
            INSERT INTO migrate_procedures 
            (statement_sequence, statement_text)
             VALUES   
            (lv_sequence_num, '/');
         END IF;
         lv_sequence_num := lv_sequence_num + 1;
         INSERT INTO migrate_procedures 
         (statement_sequence, statement_text)
         VALUES 
         (lv_sequence_num, 'CREATE OR REPLACE ' || 
          cur_source_rec.text);
      ELSE
         lv_sequence_num := lv_sequence_num + 1;
         INSERT INTO migrate_procedures 
         (statement_sequence, statement_text)
          VALUES 
         (lv_sequence_num, cur_source_rec.text);
      END IF;
   END LOOP;
   lv_sequence_num := lv_sequence_num + 1;
   INSERT INTO migrate_procedures 
   (statement_sequence, statement_text)
   VALUES   
   (lv_sequence_num, '/');
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
SPOOL 13_12.lis
SELECT   statement_text
FROM     migrate_procedures
ORDER BY statement_sequence;
SPOOL OFF
DROP TABLE migrate_procedures;
UNDEFINE tablespace
UNDEFINE owner

SPOOL OFF
