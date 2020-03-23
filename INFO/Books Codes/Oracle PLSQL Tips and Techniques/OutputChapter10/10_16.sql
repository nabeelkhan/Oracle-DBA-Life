-- ***************************************************************************
-- File: 10_16.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_16.lis

SELECT a.username,
       b.granted_role || DECODE(admin_option,'YES',
       ' (With Admin Option)',NULL) what_granted
FROM   sys.dba_users a, sys.dba_role_privs b
WHERE  a.username = b.grantee
UNION
SELECT a.username,
       b.privilege || DECODE(admin_option,'YES',
       ' (With Admin Option)', NULL) what_granted
FROM   sys.dba_users a, sys.dba_sys_privs b
WHERE  a.username = b.grantee
UNION
SELECT a.username,
       b.table_name || ' - ' || b.privilege 
       || DECODE(grantable,'YES',
       ' (With Grant Option)',NULL) what_granted
FROM   sys.dba_users a, sys.dba_tab_privs b
WHERE  a.username = b.grantee 
ORDER BY 1;

SPOOL OFF
