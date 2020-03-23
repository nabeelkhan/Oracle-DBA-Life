REM FILE NAME:  flushit.sql
REM LOCATION:  	System Monitoring\Utilities
REM FUNCTION:   Flush Shared Pool Memory
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   must be connected as SYS
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CREATE OR REPLACE PROCEDURE flush_it
AS
   CURSOR get_share
   IS
      SELECT SUM (sharable_mem)
        FROM sql_summary;

   CURSOR get_var
   IS
      SELECT VALUE
        FROM v$sga
       WHERE NAME LIKE 'Var%';

   CURSOR get_time
   IS
      SELECT SYSDATE
        FROM DUAL;

   todays_date    DATE;
   mem_ratio      NUMBER;
   share_mem      NUMBER;
   variable_mem   NUMBER;
   cur            INTEGER;
   sql_com        VARCHAR2 (60);
   row_proc       NUMBER;
BEGIN
   OPEN get_share;
   OPEN get_var;
   FETCH get_share INTO share_mem;
   DBMS_OUTPUT.put_line (   'share_mem: '
                         || TO_CHAR (share_mem));
   FETCH get_var INTO variable_mem;
   DBMS_OUTPUT.put_line (   'variable_mem: '
                         || TO_CHAR (variable_mem));
   mem_ratio := share_mem / variable_mem;
   DBMS_OUTPUT.put_line (TO_CHAR (mem_ratio));

   IF mem_ratio > 0.5
   THEN
      cur := DBMS_SQL.open_cursor;
      sql_com := 'alter system flush shared_pool';
      DBMS_SQL.parse (cur, sql_com, DBMS_SQL.v7);
      row_proc := DBMS_SQL.EXECUTE (cur);
      DBMS_SQL.close_cursor (cur);
      OPEN get_time;
      FETCH get_time INTO todays_date;

      INSERT INTO dba_running_stats
           VALUES ('Flush of Shared
  Pool', 1, 35, todays_date, 0);

      COMMIT;
   END IF;
END;
/
