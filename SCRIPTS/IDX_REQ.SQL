COL table_name format A20 head 'TABLE_NAME'
COL constraint_name format A20 head 'CONSTRAINT_NAME'
COL table2 format A20 head 'TABLE_TO_BE_INDEXED'
COL column_name format A20 head 'COLUMN_TO_BE_INDEXED'

SET linesize 100

SELECT t.table_name,c.constraint_name,c.table_name table2
,acc.column_name
FROM all_constraints t, all_constraints c
, all_cons_columns acc
WHERE c.r_constraint_name = t.constraint_name
AND c.table_name =acc.table_name
AND c.constraint_name = acc.constraint_name
AND NOT EXISTS ( SELECT '1' FROM all_ind_columns aid
WHERE aid.table_name = acc.table_name
AND aid.column_name = acc.column_name)
ORDER BY c.table_name;

