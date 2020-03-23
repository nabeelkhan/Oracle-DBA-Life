Description: 

Monitor the sorts in memory vs disk. Try to keep the disk/memory ratio to less than .10 by increasing the sort_area_size

Code :

SET HEADING OFF
SET FEEDBACK OFF
COLUMN name FORMAT a30
COLUMN value FORMAT 99999990

SELECT name, value FROM v$sysstat 
WHERE name IN ('sorts (memory)', 'sorts (disk)'); 


