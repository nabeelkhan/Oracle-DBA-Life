rem -----------------------------------------------------------------------
rem Filename:   object_stat.sql
rem Purpose:    Show object status with different options
rem Author:     Nabeel Khan [nabeel@nabeelkhan.com]
rem -----------------------------------------------------------------------


select count(object_name), OBJECT_TYPE, status from dba_objects
where OWNER = 'TABS'
--and OBJECT_TYPE = 'VIEW'
--and status <>'VALID'
group by OBJECT_TYPE, status
order by 3
/
