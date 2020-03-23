SELECT  owner, table_name, COUNT(*)
   FROM  all_indexes
  WHERE  owner NOT IN ('SYS', 'SYSTEM')
  GROUP  BY owner, table_name
 HAVING  COUNT(*) > 6
 
/
