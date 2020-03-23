-- ***************************************************************************
-- File: 10_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_15.lis

-- Direct Role Grants to Roles
SELECT granted_role  ||  
       DECODE(admin_option, 'YES', 
       ' (With Admin Option)', NULL) what_granted, 
       grantee
FROM   sys.dba_role_privs
WHERE  NOT EXISTS
(SELECT 'x' 
FROM    sys.dba_users
WHERE   username = grantee)
ORDER BY 1;

SPOOL OFF
