-- ***************************************************************************
-- File: 3_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 3_6.lis

-- Program: 3_6.sql (logsrc.prc)
-- Created: 05/12/98
-- Created By: Joe Trezzo (TUSC)

-- Description:  This procedure is used to create backup versions
--               of the stored PL/SQL source code. It can be 
--               executed on demand by executing the log_source
--               procedure in SQL*Plus or at a regular interval by
--               setting up the execution of this procedure in 
--               DBMS_JOB. In order for this to work, the SQL 
--               script 3_5.sql must be executed under the schema
--               that the source_log table should reside. This
--               procedure can be executed under the owner of 
--               the source_log table by granting SELECT privilege
--               to the dba_objects and dba_source views from SYS.
--               This script also creates a public synonym and 
--               grants access to all users. The procedure only 
--               selects new or updated source code and does not 
--               pull SYS or SYSTEM.

-- Syntax:     log_source
-- Parameters: None

-- Table(s) Selected: dba_objects, dba_source, source_log
-- Table(s) Updated:  source_log

-- Modified: 07/01/98
-- Modified By: Joe Trezzo (TUSC)
   
-- Modification: Added the display of the count of records 
--               inserted.

CREATE OR REPLACE PROCEDURE log_source IS

   -- Selects all new source code records
   CURSOR cur_source_code IS
      SELECT TRUNC(SYSDATE) log_date, 
             TO_CHAR(SYSDATE, 'HH24MISS') log_time,
             obj.last_ddl_time last_ddl_time, obj.owner owner, 
             src.name name, src.type type,
             src.line line, src.text text
      FROM   dba_source src, dba_objects obj
      WHERE  src.owner = obj.owner
      AND    src.name  = obj.object_name
      AND    src.type  = obj.object_type
      AND    obj.owner NOT IN ('SYS', 'SYSTEM')
      AND    NOT EXISTS
      (SELECT 'X'
      FROM    SOURCE_LOG
      WHERE   last_ddl_time = obj.last_ddl_time
      AND     owner         = obj.owner
      AND     name          = obj.object_name
      AND     type          = obj.object_type);

   lv_records_updated_num PLS_INTEGER :=0; -- # of records inserted

BEGIN
   -- Every new line of source code found is inserted
   FOR lv_source_rec IN cur_source_code LOOP
      INSERT INTO source_log
         (backup_date, backup_time, last_ddl_time,
          owner, name, type, line, text)
      VALUES
         (lv_source_rec.log_date, lv_source_rec.log_time,
          lv_source_rec.last_ddl_time, lv_source_rec.owner,
          lv_source_rec.name, lv_source_rec.type,
          lv_source_rec.line, lv_source_rec.text);

      lv_records_updated_num := lv_records_updated_num + 1;
   END LOOP;

   DBMS_OUTPUT.PUT_LINE('Number of New Source Records: ' || 
                        TO_CHAR(lv_records_updated_num));
   COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK; -- Any problems encountered, 
                   -- rolls the entire transaction back
         DBMS_OUTPUT.PUT_LINE('Source Log Process Aborted. ' ||
            'No Records Inserted. ');
         DBMS_OUTPUT.PUT_LINE('Oracle Error Code: ' || 
            TO_CHAR(SQLCODE) || '   Oracle Error Message: ' ||
            SUBSTR(SQLERRM,1,150));
END log_source;
-----------------------------------------------------------------
/
CREATE PUBLIC SYNONYM log_source FOR log_source
/
GRANT EXECUTE ON log_source TO PUBLIC
/

SPOOL OFF
