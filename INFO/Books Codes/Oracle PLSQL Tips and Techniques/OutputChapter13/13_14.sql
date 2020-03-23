-- ***************************************************************************
-- File: 13_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_14.lis

SET HEADING OFF
SET FEEDBACK OFF
SET PAGESIZE 0
SELECT   'ALTER TRIGGER ' || trigger_name || ' DISABLE;'
FROM     user_triggers
ORDER BY table_name;

SPOOL OFF
