-- ***************************************************************************
-- File: 10_13.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_13.lis

-- Object Grants to Roles
SELECT owner || '.' || table_name obj,
       privilege what_granted, grantable, grantee
FROM   sys.dba_tab_privs 
WHERE  NOT EXISTS
(SELECT  'x' 
FROM     sys.dba_users
WHERE    username = grantee)
ORDER BY 1,2,3;

SPOOL OFF
