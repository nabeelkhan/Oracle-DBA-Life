-- ***************************************************************************
-- File: 10_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_11.lis

-- Oracle System Privilege Grants to Roles
SELECT privilege what_granted,
       admin_option, grantee   
FROM   sys.dba_sys_privs 
WHERE  NOT EXISTS
(SELECT 'x' 
FROM    sys.dba_users
WHERE   username = grantee)
ORDER BY 1,2;

SPOOL OFF
