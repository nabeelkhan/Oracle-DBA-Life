-- ***************************************************************************
-- File: 13_22.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_22.lis

BREAK ON    r_name SKIP 1
COLUMN      r_name FORMAT a80
COLUMN      name FORMAT a80
COLUMN      r_link FORMAT a80
SET HEADING OFF
SELECT  DECODE(referenced_type, 'NON-EXISTENT', '.....', 
        referenced_type) || ' ' || referenced_owner || 
        '.' || referenced_name r_name, '    is referenced by: ' ||
        type || ' ' || owner || '.' || name name,
        '    Referenced Link: ' || DECODE(referenced_link_name, 
        NULL, 'none', referenced_link_name) r_link
FROM    dba_dependencies
WHERE   owner NOT IN ('SYS', 'SYSTEM')
ORDER BY 1,2;

SPOOL OFF
