-- ***************************************************************************
-- File: 13_8.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_8.lis

COLUMN     comments FORMAT a45
SELECT     table_name, comments
FROM       all_tab_comments
WHERE      table_name = UPPER('&&table_name');
SELECT     column_name, comments
FROM       all_col_comments
WHERE      table_name = UPPER('&&table_name');
UNDEFINE table_name

SPOOL OFF
