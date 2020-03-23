-- ***************************************************************************
-- File: 12_34.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_34.lis

DECLARE
   CURSOR cur_tables IS
      SELECT table_name
      FROM   user_tables
      ORDER BY table_name;
   lv_total_blocks_num           PLS_INTEGER;
   lv_total_bytes_num            PLS_INTEGER;
   lv_unused_blocks_num          PLS_INTEGER;
   lv_unused_bytes_num           PLS_INTEGER;
   lv_last_used_extent_file_num  PLS_INTEGER;
   lv_last_used_extent_block_num PLS_INTEGER;
   lv_last_used_block_num        PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.PUT_LINE(
   'Current                              Blocks               Bytes');
   DBMS_OUTPUT.PUT_LINE(
   'Schema         Table Name         Total Unused       Total' ||
   '      Unused');
   DBMS_OUTPUT.PUT_LINE('------------------' ||
   '--------------------------------------------------------');
   FOR cur_tables_rec IN cur_tables LOOP
      DBMS_SPACE.UNUSED_SPACE(USER, cur_tables_rec.table_name,
         'TABLE', lv_total_blocks_num, lv_total_bytes_num,
         lv_unused_blocks_num, lv_unused_bytes_num,
         lv_last_used_extent_file_num,
         lv_last_used_extent_block_num,
         lv_last_used_block_num);
        DBMS_OUTPUT.PUT_LINE(RPAD(USER,15) ||
         RPAD(cur_tables_rec.table_name,15) ||
         TO_CHAR(lv_total_blocks_num, '999,999') ||
         TO_CHAR(lv_unused_blocks_num, '999,999') ||
         TO_CHAR(lv_total_bytes_num, '999,999,999') ||
         TO_CHAR(lv_unused_bytes_num, '999,999,999'));   
   END LOOP;
END;
/

SPOOL OFF
