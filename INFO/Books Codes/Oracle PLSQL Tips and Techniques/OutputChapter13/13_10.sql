-- ***************************************************************************
-- File: 13_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_10.lis

COLUMN     object_name FORMAT a25
COLUMN     created FORMAT a20
COLUMN     updated FORMAT a20
SELECT     object_name, object_type, 
           TO_CHAR(created, 'MM/DD/YY HH24:MI:SS') created, 
           TO_CHAR(last_ddl_time, 'MM/DD/YY HH24:MI:SS') updated
FROM       dba_objects
WHERE      object_type IN ('PACKAGE','PACKAGE BODY', 'PROCEDURE', 
                           'FUNCTION', 'TRIGGER')
AND        OWNER        = 'PLSQL_USER'
ORDER BY   object_name;

SPOOL OFF
