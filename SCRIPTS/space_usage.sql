rem -----------------------------------------------------------------------
rem Filename:   space_usage.sql
rem Purpose:    Show Used/free space in Meg by tablespace name
rem Author:     Nabeel Khan [khan.nabeel@yahoo.com]
rem -----------------------------------------------------------------------

tti "Space Usage for Database in Meg"

SELECT Total.name "Tablespace Name",
       nvl(Free_space, 0) Free_space,
       nvl(total_space-Free_space, 0) Used_space, 
       total_space
FROM
  (select tablespace_name, sum(bytes/1024/1024) Free_Space
     from sys.dba_free_space
    group by tablespace_name
  ) Free,
  (select b.name,  sum(bytes/1024/1024) TOTAL_SPACE
     from sys.v_$datafile a, sys.v_$tablespace B
    where a.ts# = b.ts#
    group by b.name
  ) Total
WHERE Free.Tablespace_name(+) = Total.name
ORDER BY Total.name
/

tti off

