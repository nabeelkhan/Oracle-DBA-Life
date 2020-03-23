-- ***************************************************************************
-- File: 10_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_10.lis

-- Oracle System Privilege Grants to Users
SELECT b.privilege what_granted,
       b.admin_option, a.username
FROM   sys.dba_users a, sys.dba_sys_privs b
WHERE  a.username = b.grantee
ORDER BY 1,2;

SPOOL OFF
