-- Written by Donald K. Burleson   1/25/01

set pages 999;
 
column c1 heading "Write request length" format 9,999.99
column c2 heading "Write Requests"       format 999,999
column c3 heading "DBWR checkpoints"     format 999,999
column mydate heading 'Yr.  Mo Dy  Hr.'  format a16

select distinct
   to_char(snap_time,'yyyy-mm-dd HH24') mydate,
   a.value/b.value                      c1,
   b.value                              c2,
   c.value                              c3 
from
   stats$sysstat  a,
   stats$sysstat  b,
   stats$sysstat  c,
   stats$snapshot sn
where
   sn.snap_id = a.snap_id
and
   sn.snap_id = b.snap_id
and
   sn.snap_id = c.snap_id
and
   a.name = 'summed dirty queue length'
and
   b.name = 'write requests'
and
   c.name = 'DBWR checkpoints'
and
   a.value > 0
and
   b.value > 0
and
   a.value/b.value > 3
;

