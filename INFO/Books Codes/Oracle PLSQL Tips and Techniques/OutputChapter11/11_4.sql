-- ***************************************************************************
-- File: 11_4.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 11_4.lis

SET PAGESIZE 58
BREAK ON object SKIP 1 ON overload SKIP 1
COLUMN object        FORMAT A32 HEADING 'Package.Procedure(Function)'
COLUMN argument_name FORMAT A20 HEADING 'Parameter'
COLUMN data_type     FORMAT A15 HEADING 'Data Type'
COLUMN in_out        FORMAT A6  HEADING 'In/Out'
COLUMN overload      NOPRINT
SPOOL arg11.lis
SELECT package_name || '.' || object_name object, argument_name,
       DECODE(data_type, 'FLOAT', 'INTEGER', data_type) data_type,
       in_out, overload
FROM   all_arguments
WHERE  owner = 'SYS'
AND    package_name = UPPER('&package')
AND    (package_name LIKE 'DBMS%'
OR     package_name  LIKE 'UTL%')
AND    package_name  <> 'DBMS_STANDARD'
ORDER BY package_name || '.' || object_name, overload, position;
SPOOL OFF

SPOOL OFF
