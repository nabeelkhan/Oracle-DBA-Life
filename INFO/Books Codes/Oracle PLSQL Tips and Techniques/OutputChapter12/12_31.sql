-- ***************************************************************************
-- File: 12_31.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_31.lis

SELECT owner, name, type, sharable_mem, kept
FROM   v$db_object_cache
WHERE  type like 'P%'
ORDER BY owner, name;

SPOOL OFF
