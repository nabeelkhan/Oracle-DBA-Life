set pages 9999;

column table_fetch_continued_row  format 999,999,999

select 
   to_char(snap_time,'HH24'),
   avg(newmem.value-oldmem.value) table_fetch_continued_row
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'table fetch continued row'
and
   newmem.name = 'table fetch continued row'
and
   newmem.value-oldmem.value > 0
group by
   to_char(snap_time,'HH24')
;
