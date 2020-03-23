-- ***************************************************************************
-- File: 12_35.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_35.lis

CREATE OR REPLACE PROCEDURE exec_ddl(p_statement_txt VARCHAR2) IS
-- This procedure provides a way to dynamically perform any DDL 
-- statements from within your normal PL/SQL processing.
   lv_exec_cursor_num    PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   lv_rows_processed_num PLS_INTEGER := 0;
BEGIN
   DBMS_SQL.PARSE(lv_exec_cursor_num, p_statement_txt, 
      DBMS_SQL.NATIVE);
   lv_rows_processed_num := DBMS_SQL.EXECUTE(lv_exec_cursor_num);
   DBMS_SQL.CLOSE_CURSOR(lv_exec_cursor_num);
EXCEPTION
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(lv_exec_cursor_num) THEN
         DBMS_SQL.CLOSE_CURSOR(lv_exec_cursor_num);
      END IF;
      RAISE;
END exec_ddl;
/

SPOOL OFF
