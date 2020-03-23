-- ***************************************************************************
-- File: 9_19.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_19.lis

SELECT a.sid, a.username, s.sql_text
FROM   v$session a, v$sqltext s
WHERE  a.sql_address    = s.address
AND    a.sql_hash_value = s.hash_value
ORDER BY a.username, a.sid, s.piece;

SPOOL OFF
