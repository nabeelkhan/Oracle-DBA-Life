-- ***************************************************************************
-- File: 13_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_15.lis

SET HEADING OFF
SET FEEDBACK OFF
SET PAGESIZE 0
SELECT   'ALTER TABLE ' || table_name || ' DISABLE ALL TRIGGERS;'
FROM     user_tables a
WHERE    EXISTS
(SELECT  'X'
FROM     user_triggers
WHERE    table_name = a.table_name)
ORDER BY table_name;

SPOOL OFF
