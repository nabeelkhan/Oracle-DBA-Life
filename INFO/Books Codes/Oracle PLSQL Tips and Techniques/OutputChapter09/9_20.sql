-- ***************************************************************************
-- File: 9_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_20.lis

SELECT a.sid, a.username, b.owner, b.object, b.type
FROM   v$session a, v$access b
WHERE  a.sid = b.sid;

SPOOL OFF
