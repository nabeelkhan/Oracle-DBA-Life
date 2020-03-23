-- ***************************************************************************
-- File: 13_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_11.lis

SELECT    object_type, object_name, status, created, last_ddl_time
FROM      user_objects
WHERE     object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 
                          'PACKAGE BODY', 'TRIGGER')
AND       status = 'INVALID';

SPOOL OFF
