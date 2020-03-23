-- ***************************************************************************
-- File: 16_17.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_17.lis

DECLARE
   lv_blocks_corrupt_num BINARY_INTEGER;
BEGIN
   DBMS_REPAIR.CHECK_OBJECT(schema_name => 'PLSQL_USER', 
      object_name => 'S_EMPLOYEE',
      repair_table_name => 'REPAIR_S_EMPLOYEE',
      corrupt_count => lv_blocks_corrupt_num);
   DBMS_OUTPUT.PUT_LINE('Corrupted_Blocks: ' ||
      lv_blocks_corrupt_num);
END;
/

SPOOL OFF
