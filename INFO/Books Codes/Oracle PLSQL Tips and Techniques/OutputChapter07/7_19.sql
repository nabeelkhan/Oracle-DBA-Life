-- ***************************************************************************
-- File: 7_19.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_19.lis

SELECT LPAD(' ', 2*(level - 1)) || level || '.' ||
       NVL(position, 0) || ' ' || operation || ' ' ||
       options || ' ' || object_name || ' ' || object_type ||
       ' ' || DECODE(id, 0, statement_id || ' Cost = ' ||
       position) || ' ' || object_node "Query Plan"
FROM   plan_table
START WITH id = 0
AND    statement_id = '&&statement_id'
CONNECT BY PRIOR id = parent_id
AND    statement_id = '&&statement_id';
UNDEFINE statement_id

SPOOL OFF
