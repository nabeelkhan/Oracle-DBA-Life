-- ***************************************************************************
-- File: 9_22.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_22.lis

SELECT a.serial#, a.sid, a.username, b.id1, c.sql_text
FROM   v$session a, v$lock b, v$sqltext c
WHERE  b.id1 IN
(SELECT DISTINCT e.id1
FROM    v$session d, v$lock e
WHERE   d.lockwait   = e.kaddr)
AND     a.sid        = b.sid
AND     c.hash_value = a.sql_hash_value
AND     b.request    = 0;

SPOOL OFF
