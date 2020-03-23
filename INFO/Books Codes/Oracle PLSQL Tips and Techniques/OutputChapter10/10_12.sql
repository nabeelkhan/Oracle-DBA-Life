-- ***************************************************************************
-- File: 10_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_12.lis

-- Object Grants to Users
SELECT b.owner || '.' || b.table_name obj,
       b.privilege what_granted, b.grantable,
       a.username
FROM   sys.dba_users a, sys.dba_tab_privs b
WHERE  a.username = b.grantee
ORDER BY 1,2,3;

SPOOL OFF
