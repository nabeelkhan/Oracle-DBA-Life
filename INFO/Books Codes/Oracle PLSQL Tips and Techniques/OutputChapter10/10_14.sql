-- ***************************************************************************
-- File: 10_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_14.lis

-- Direct Role Grants to Users
SELECT b.granted_role ||
       DECODE(admin_option, 'YES', 
       ' (With Admin Option)', 
       NULL) what_granted, a.username
FROM   sys.dba_users a, sys.dba_role_privs b
WHERE  a.username = b.grantee
ORDER BY 1;

SPOOL OFF
