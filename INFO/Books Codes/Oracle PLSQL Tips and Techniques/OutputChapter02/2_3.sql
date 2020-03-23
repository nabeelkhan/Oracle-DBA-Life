-- ***************************************************************************
-- File: 2_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_3.lis

column nullable format a10 heading 'NULL|ALLOWED?'
SELECT table_name, column_name, 
       DECODE(nullable, 'N', 'NO', 'YES') nullable
FROM   all_tab_columns
WHERE  table_name = UPPER('&table_name');

SPOOL OFF
