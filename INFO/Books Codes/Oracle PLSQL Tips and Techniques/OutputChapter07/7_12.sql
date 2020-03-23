-- ***************************************************************************
-- File: 7_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_12.lis

SET TIMING ON
SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   CURSOR cur_test_sql IS
      &select_statement;
   lv_test_sql_rec cur_test_sql%ROWTYPE;
BEGIN
   DBMS_OUTPUT.PUT_LINE('********************');
   OPEN cur_test_sql;
   FETCH cur_test_sql INTO lv_test_sql_rec;
   DBMS_OUTPUT.PUT_LINE('SELECT Succeeded.');
   IF cur_test_sql%FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Records Found.');
   ELSE
      DBMS_OUTPUT.PUT_LINE('NO Records Found.');
   END IF;
   CLOSE cur_test_sql;
END;
/

SPOOL OFF
