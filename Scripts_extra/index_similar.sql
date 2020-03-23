set echo off
set feedback off
set linesize 512

prompt
prompt Highly Similar Indexes
prompt

column column_name format a32
break on TABLE_OWNER on TABLE NAME skip 1

SELECT	 TABLE_OWNER, TABLE_NAME, INDEX_NAME, COLUMN_NAME
	FROM ALL_IND_COLUMNS
   WHERE COLUMN_POSITION = 1
	 AND TABLE_OWNER NOT IN ('SYS','SYSTEM','OUTLN','DBSNMP')
	 AND (TABLE_OWNER, TABLE_NAME, COLUMN_NAME) IN
			   (SELECT TABLE_OWNER, TABLE_NAME, COLUMN_NAME
				  FROM (SELECT	 TABLE_OWNER, TABLE_NAME, COLUMN_NAME,
								 COUNT (*) TCOUNT
							FROM ALL_IND_COLUMNS
						   WHERE COLUMN_POSITION = 1
							 AND TABLE_OWNER NOT IN ('SYS','SYSTEM','OUTLN','DBSNMP')
						  HAVING COUNT (*) > 1
						GROUP BY TABLE_OWNER, TABLE_NAME, COLUMN_NAME))
ORDER BY TABLE_OWNER, TABLE_NAME, COLUMN_NAME, INDEX_NAME;