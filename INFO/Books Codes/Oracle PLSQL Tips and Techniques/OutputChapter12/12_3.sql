-- ***************************************************************************
-- File: 12_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_3.lis

SELECT sid, serial#, username, module, action
FROM   v$session
WHERE  USERNAME = 'PLSQL_USER';

SPOOL OFF
