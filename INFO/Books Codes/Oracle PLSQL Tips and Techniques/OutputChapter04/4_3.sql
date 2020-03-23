-- ***************************************************************************
-- File: 4_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_3.lis

SELECT dic.table_name, dic.index_name, 
       DECODE(di.uniqueness, 'UNIQUE', 'YES', 'NO')uniqueness, 
       dic.column_position, dic.column_name
FROM   user_indexes di, user_ind_columns dic 
WHERE  dic.table_name  = di.table_name
AND    dic.index_name  = di.index_name
ORDER BY dic.table_name, dic.index_name,
         di.uniqueness desc, dic.column_position;

SPOOL OFF
