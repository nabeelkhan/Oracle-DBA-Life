-- ***************************************************************************
-- File: 9_21.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_21.lis

SELECT b.username, b.serial#, d.id1, a.sql_text
FROM   v$session b, v$lock d, v$sqltext a
WHERE  b.lockwait   = d.kaddr
AND    a.address    = b.sql_address
AND    a.hash_value = b.sql_hash_value;

SPOOL OFF
