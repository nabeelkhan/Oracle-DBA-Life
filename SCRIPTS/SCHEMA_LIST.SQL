REM	Display all tables in current 
REM	schema, with tablespace name and 
REM	table size in gigabytes. 
REM	Useful when space becomes a problem. 

SPOOL rep_out\SCHEMA_LIST.LIST

SELECT a.table_name,
a.tablespace_name,
ROUND(SUM (b.bytes) / 1024 / 1024 / 1024, 3) gigabytes
FROM user_tables a,
user_extents b
WHERE a.table_name = b.segment_name
AND a.tablespace_name = b.tablespace_name
GROUP BY a.tablespace_name, a.table_name
ORDER BY gigabytes DESC, table_name ASC;

SPOOL OFF