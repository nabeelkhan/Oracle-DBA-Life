column name format a40
column value format 999,999,999
select name,value
from
v$pgastat
order by
value desc;
