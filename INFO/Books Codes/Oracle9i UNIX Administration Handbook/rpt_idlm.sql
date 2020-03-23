column mydate              heading 'Yr.  Mo Dy  Hr.' format a16
column idlm_lock_hit_ratio                           format 999,999,999

select
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   (a.value - b.value)/(a.value) idlm_lock_hit_ratio
from
   stats$sysstat    a, 
   stats$sysstat    b,
   stats$snapshot   sn
where
   a.name = 'consistent gets'
and
   b.name = 'global lock converts (async)'
and
   a.snap_id = sn.snap_id
and
   b.snap_id = sn.snap_id
order by
   to_char(snap_time,'yyyy-mm-dd HH24')
;
