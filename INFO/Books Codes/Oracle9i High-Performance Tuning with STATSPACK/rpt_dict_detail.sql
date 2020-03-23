set lines 80;
set pages 999;

column mydate heading 'Yr.  Mo Dy  Hr.'              format a16
column parameter                                     format a20
column c1     heading "Data|Dictionary|Gets"         format 99,999,999
column c2     heading "Data|Dictionary|Cache|Misses" format 99,999,999
column c3     heading "Data|Dictionary|Usage"        format 999
column c4     heading "Object|Hit|Ratio"             format 999

break on mydate skip 2;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.parameter                         parameter,
   (new.gets-old.gets)                   c1,
   (new.getmisses-old.getmisses)         c2,
   (new.total_usage-old.total_usage)     c3,
  ROUND((1 - (new.getmisses-old.getmisses) / 
  (new.gets-old.gets))*100,1)            c4
from 
   stats$rowcache_summary new,
   stats$rowcache_summary old,
   stats$snapshot         sn
where
   new.snap_id = sn.snap_id
and
   old.snap_id = new.snap_id-1
and
   old.parameter = new.parameter
and
   new.gets-old.gets > 0
and
   (new.total_usage-old.total_usage) > 0 
   and rownum < 50
;

