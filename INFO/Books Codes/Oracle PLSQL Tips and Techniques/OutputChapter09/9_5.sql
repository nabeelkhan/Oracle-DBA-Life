-- ***************************************************************************
-- File: 9_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_5.lis

SELECT owner, trigger_name, trigger_type,
       triggering_event, table_owner||'.'||table_name
FROM   dba_triggers
WHERE  status <> 'ENABLED'
AND    owner  = 'PLSQL_USER'
ORDER BY owner, trigger_name;

SPOOL OFF
