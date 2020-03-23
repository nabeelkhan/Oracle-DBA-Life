-- ***************************************************************************
-- File: 12_23.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_23.lis

SELECT username, granted_role, default_role
FROM   user_role_privs
ORDER BY granted_role;

SPOOL OFF
