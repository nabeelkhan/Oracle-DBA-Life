-- ***************************************************************************
-- File: 9_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_11.lis

CREATE OR REPLACE PROCEDURE example_proc1(p_table_txt IN VARCHAR2) AS
   CURSOR cur_tables IS
      SELECT * 
      FROM   dba_tables
      WHERE  table_name = p_table_txt;
   lv_cur_tables_rec   cur_tables%rowtype;
BEGIN
   OPEN cur_tables;
   FETCH cur_tables INTO lv_cur_tables_rec;
   DBMS_OUTPUT.PUT_LINE('The indicator is: '|| 
      lv_cur_tables_rec.table_name);
   CLOSE cur_tables;
EXCEPTION
 WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(p_table_txt||' was not found');
END example_proc1;
/

SPOOL OFF
