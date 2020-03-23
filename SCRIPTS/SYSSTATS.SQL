col c1 heading 'Workarea|Profile' format a35
col c2 heading 'Count' format 999,999,999
col c3 heading 'Percentage' format 999
select name c1,cnt c2,decode(total, 0, 0, round(cnt*100/total)) c3
from
(
select name,value cnt,(sum(value) over ()) total
from
v$sysstat
where
name like 'workarea exec%'
);
