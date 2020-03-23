-- ***************************************************************************
-- File: 9_4 .sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_4.lis

SELECT      owner, object_type, object_name, status, 
         TO_CHAR(created, 'MM/DD/YY HH24:MI:SS') created,
         TO_CHAR(last_ddl_time, 'MM/DD/YY HH24:MI:SS') modified
FROM 	dba_objects
WHERE	object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE',
                         'PACKAGE BODY', 'TRIGGER')
AND         status = 'INVALID'
AND         owner  = 'PLSQL_USER'
ORDER BY owner, object_type, object_name;

SPOOL OFF
