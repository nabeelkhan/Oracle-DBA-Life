-- ***************************************************************************
-- File: 13_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_7.lis

COLUMN     object FORMAT a25
COLUMN     grantee FORMAT a15
SELECT     owner || '.' || table_name object,
           privilege what_granted, grantable, grantee
FROM       dba_tab_privs 
WHERE      NOT EXISTS
(SELECT    'x' 
FROM       dba_users
WHERE      username = grantee)
AND        privilege =  'EXECUTE'
ORDER BY   1,2,3;

SPOOL OFF
