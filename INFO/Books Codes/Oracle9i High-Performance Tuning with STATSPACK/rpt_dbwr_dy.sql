Set pages 999;


column c1 heading "Write request length" format 9,999.99
column c2 heading "Write Requests"       format 999,999
column c3 heading "DBWR checkpoints"     format 999,999
Column c4 noprint

select distinct
   to_char(snap_time,'day') mydate,
   decode(to_char(snap_time,'day'),'sunday',1,'monday',2,'tuesday',3,
   'wednesday',4,'thursday',5,'friday',6,'saturday',7) c4,
   avg(a.value/b.value)                      c1
from
   stats$sysstat  a,
   stats$sysstat  b,
   stats$snapshot sn
where
   sn.snap_id = a.snap_id
and
   sn.snap_id = b.snap_id
and
   a.name = 'summed dirty queue length'
and
   b.name = 'write requests'
and
   a.value > 0
and
   b.value > 0
group by
   decode(to_char(snap_time,'day'),'sunday',1,'monday',2,'tuesday',3,
   'wednesday',4,'thursday',5,'friday',6,'saturday',7),
   to_char(snap_time,'day')
;

