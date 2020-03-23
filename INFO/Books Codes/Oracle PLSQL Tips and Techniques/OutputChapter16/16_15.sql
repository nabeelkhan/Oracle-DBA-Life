-- ***************************************************************************
-- File: 16_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_15.lis

SELECT object_name, object_type
FROM   all_objects
WHERE  owner = 'SYS'
AND    object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;

SPOOL OFF
