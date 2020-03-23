set pages 9999;

column buffer_busy_wait format 999,999,999
column mydate heading 'Yr.  Mo Dy  Hr.' format a16
column c0 heading "Name"    format 99 
column c1 heading "sz now"   format 9,999 
column c2 heading "extends" format 9,999
column c3 heading "# trans." format 9,999
column c4 heading "wraps" format 9,999
column c5 heading "High WM" format 999;
column c7 heading "Shrinks" format 999;
column c6 heading "status" 
column c8 heading "Waits" format 9,999;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')   mydate,
   new.usn                                c0,
   (new.rssize-old.rssize)/1048576        c1,
   (new.hwmsize-old.hwmsize)/1048576      c5,
   new.extends-old.extends                c2,
   new.waits-old.waits                    c8,
   new.xacts-old.xacts                    c3,
   new.wraps-old.wraps                    c4,
   new.shrinks-old.shrinks                c7
from
   perfstat.stats$rollstat old,
   perfstat.stats$rollstat new,
   perfstat.stats$snapshot   sn
where
   (new.rssize-old.rssize) > 0
and
   new.xacts-old.xacts > 0
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and 
   new.usn = old.usn
;
