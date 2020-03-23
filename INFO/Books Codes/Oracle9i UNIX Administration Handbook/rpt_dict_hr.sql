set lines 80;
set pages 999;

column mydate heading 'Yr.  Mo Dy  Hr.'              format a16
column c1     heading "Data|Dictionary|Gets"         format 999,999,999
column c2     heading "Data|Dictionary|Cache|Misses" format 999,999,999
column c3     heading "Data|Dictionary|Hit|Ratio"    format 999,999

select 
   to_char(snap_time,'HH24')  mydate,
--   sum(new.gets-old.gets)                c1,
--   sum(new.getmisses-old.getmisses)      c2,
   trunc((1-(sum(new.getmisses-old.getmisses)/sum(new.gets-old.gets)))*100) c3
from 
   stats$rowcache_summary new,
   stats$rowcache_summary old,
   stats$snapshot sn
where
   new.snap_id = sn.snap_id
and
   old.snap_id = new.snap_id-1
group by
   to_char(snap_time,'HH24')
;

