-- ***************************************************************************
-- File: 9_17.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_17.lis

SELECT a.username, c.name, b.value
FROM   v$session a, v$sesstat b, v$statname c
WHERE  a.sid        = b.sid
AND    b.statistic# = c.statistic#
AND    b.value      != 0;

SPOOL OFF
