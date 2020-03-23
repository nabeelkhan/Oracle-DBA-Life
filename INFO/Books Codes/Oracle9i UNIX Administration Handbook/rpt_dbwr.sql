-- Written by Donald K. Burleson   1/25/01
column c1 heading "Write queue length" format 999,999
column c2 heading "DBWR checkpoints" format 999,999
column c3 heading "DBWR Buffers scanned" format 999,999
select
   to_char(snap_time,'yyyy-mm-dd HH24'),
   decode(name, 'summed dirty queue length', value)
   /
   decode(name, 'write requests', value) c1,
   decode(name,'dbwr checkpoints', value) c2
   decode(name,'dbwr buffers scanned', value) c3
from
   stats$sysstat,
   stats$snapshot
where
   sn.snap_id = s.snap_id
and
   name in ('summed dirty queue length',
                  'write requests',
                  'dbwr checkpoints',
                  'dbwr buffers scanned')
and
   value > 0
;

