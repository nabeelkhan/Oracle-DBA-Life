-- ***************************************************************************
-- File: 13_21.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_21.lis

SELECT    name, type
FROM      user_dependencies
WHERE     referenced_name = UPPER('&object_name')
AND       referenced_type = UPPER('&object_type')
ORDER BY  name;

SPOOL OFF
