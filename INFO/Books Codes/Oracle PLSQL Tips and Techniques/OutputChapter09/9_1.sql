-- ***************************************************************************
-- File: 9_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_1.lis

SELECT name, type, source_size, parsed_size, code_size
FROM   user_object_size
WHERE  type IN ('PACKAGE', 'PACKAGE BODY',
       'PROCEDURE', 'FUNCTION', 'TRIGGER')
ORDER BY type, name;

SPOOL OFF
