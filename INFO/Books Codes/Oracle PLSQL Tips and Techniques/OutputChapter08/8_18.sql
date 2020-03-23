-- ***************************************************************************
-- File: 8_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_18.lis

DECLARE
   TYPE type_temp_table IS TABLE OF VARCHAR(100)
      INDEX BY BINARY_INTEGER;
   lv_temp_table type_temp_table;
BEGIN
   FOR lv_count_num IN 1..200 LOOP
      lv_temp_table(lv_count_num) := 'A';
   END LOOP;
END;
/

SPOOL OFF
