set pages 999;
 
column c1 heading "Dirty Queue Length"   format 9,999.99
column c2 heading "Free Buffer Requests" format 999,999,999
column c3 heading "DBWR checkpoints"     format 999,999
column mydate heading 'Yr.  Mo Dy  Hr.'  format a16

select distinct
   to_char(snap_time,'yyyy-mm-dd HH24') mydate,
   a.value                              c1,
   b.free_buffer_wait                   c2,
   c.value                              c3 
from
   stats$sysstat                 a,
   stats$buffer_pool_statistics  b,
   stats$sysstat                 c,
   stats$snapshot                sn
where
   sn.snap_id = a.snap_id
and
   sn.snap_id = b.snap_id
and
   sn.snap_id = c.snap_id
and
   a.name = 'summed dirty queue length'
and
   c.name = 'DBWR checkpoints'
and
   a.value > 100
and
   b.free_buffer_wait > 0
;
