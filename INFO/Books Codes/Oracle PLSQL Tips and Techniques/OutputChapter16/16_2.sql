-- ***************************************************************************
-- File: 16_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_2.lis

DECLARE
   lv_count_num      PLS_INTEGER:=0;
   CURSOR cur_counts IS
      SELECT table_name
      FROM   user_tables
      ORDER BY table_name;
BEGIN
   FOR cur_counts_rec IN cur_counts LOOP
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' ||
         cur_counts_rec.table_name INTO lv_count_num;
      DBMS_OUTPUT.PUT_LINE('Table Name: ' ||
         RPAD(cur_counts_rec.table_name, 15) ||
         ' Rows: ' || lv_count_num);
   END LOOP;
END;
/

SPOOL OFF
