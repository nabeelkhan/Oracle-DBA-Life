-- ***************************************************************************
-- File: 13_24.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_24.lis

SET HEADING OFF
SET FEEDBACK OFF
SET PAGESIZE 0
SPOOL 13_24.log
SELECT    'DROP ' || object_type || ' ' || object_name || ';'
FROM      user_objects
WHERE     object_type IN ('PACKAGE','PACKAGE BODY','PROCEDURE',
                       'FUNCTION','TRIGGER')
ORDER BY  object_type;
SPOOL OFF

SPOOL OFF
