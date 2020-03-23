-- ***************************************************************************
-- File: 4_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_2.lis

-- Query 1
SELECT dc.table_name, dcc.column_name, dcc.position, 
       dcc.constraint_name, dc.constraint_type, dc.search_condition
FROM   user_constraints dc, user_cons_columns dcc 
WHERE  dcc.table_name      = dc.table_name
AND    dcc.owner           = dc.owner
AND    dcc.constraint_name = dc.constraint_name
ORDER BY dcc.table_name, dcc.owner, dcc.position, dcc.column_name;

-- Query 2
SELECT dc.table_name, dc.constraint_type, dc.constraint_name,
       dcc.column_name, dc.status
FROM   user_constraints dc, user_cons_columns dcc 
WHERE  dc.status          = 'DISABLED'
AND    dc.table_name      = dcc.table_name
AND    dc.constraint_name = dcc.constraint_name
ORDER BY dc.table_name;

SPOOL OFF
