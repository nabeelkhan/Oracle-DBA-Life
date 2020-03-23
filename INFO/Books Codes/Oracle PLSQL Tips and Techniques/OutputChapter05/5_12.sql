-- ***************************************************************************
-- File: 5_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_12.lis

SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   lv_dml_statement_txt   VARCHAR2(100);
   lv_package_version_txt VARCHAR2(100);
   lv_record_count_num    PLS_INTEGER;
   lv_version_cursor_num  PLS_INTEGER;
   CURSOR cur_source IS
      SELECT DISTINCT name
      FROM   user_source
      WHERE  type = 'PACKAGE BODY';
BEGIN
   FOR cur_source_rec IN cur_source LOOP
      lv_version_cursor_num := DBMS_SQL.OPEN_CURSOR;
      lv_dml_statement_txt := 'SELECT ' || cur_source_rec.name ||
         '.what_version FROM DUAL';
      BEGIN
         DBMS_SQL.PARSE(lv_version_cursor_num, lv_dml_statement_txt,
            DBMS_SQL.NATIVE);
         DBMS_SQL.DEFINE_COLUMN(lv_version_cursor_num, 1, 
            lv_package_version_txt, 100);
         lv_record_count_num := 
            DBMS_SQL.EXECUTE(lv_version_cursor_num);
         IF DBMS_SQL.FETCH_ROWS(lv_version_cursor_num) > 0 THEN
            DBMS_SQL.COLUMN_VALUE(lv_version_cursor_num, 1, 
               lv_package_version_txt);
         ELSE
            lv_package_version_txt := 'Version Reporting Failed';
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            lv_package_version_txt := 'Version Reporting Not ' ||
               'Supported';
      END;
      DBMS_OUTPUT.PUT_LINE(LOWER(cur_source_rec.name) || ': ' || 
         lv_package_version_txt);
      DBMS_SQL.CLOSE_CURSOR(lv_version_cursor_num);
   END LOOP;
END;
/

SPOOL OFF
