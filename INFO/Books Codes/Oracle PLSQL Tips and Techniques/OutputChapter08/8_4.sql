-- ***************************************************************************
-- File: 8_4.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_4.lis

SELECT username, sid, serial#, module, action
FROM   v$session
WHERE  username = 'PLSQL_USER';

SPOOL OFF
