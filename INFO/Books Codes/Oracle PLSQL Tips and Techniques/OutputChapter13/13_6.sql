-- ***************************************************************************
-- File: 13_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_6.lis

COLUMN     object FORMAT a25
COLUMN     grantee FORMAT a15
SELECT     b.owner || '.' || b.table_name object, 
           b.privilege what_granted, b.grantable, a.username
FROM       dba_users a, dba_tab_privs b
WHERE      a.username = b.grantee
AND        privilege = 'EXECUTE'
ORDER BY   1,2,3;

SPOOL OFF
