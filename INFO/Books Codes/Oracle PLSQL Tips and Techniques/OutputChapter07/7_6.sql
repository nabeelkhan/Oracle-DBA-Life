-- ***************************************************************************
-- File: 7_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_6.lis

SELECT a.table_name, a.index_name, uniqueness, 
       column_position, column_name
FROM   user_indexes a, user_ind_columns b
WHERE  a.index_name = b.index_name
ORDER BY table_name, index_name, column_position;

SPOOL OFF
