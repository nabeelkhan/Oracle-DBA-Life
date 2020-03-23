Description: 

Gives lots of usefull easy to read info on how your RBS are performing. Needs 132 char display.

Code :

ol name for a7
col xacts for 9990 head "Actv|Trans"
col InitExt for 990.00 head "Init|Ext|(Mb)"
col NextExt for 990.00 head "Next|Ext|(Mb)"
col MinExt for 99 head "Min|Ext"
col MaxExt for 999 head "Max|Ext"
col optsize for 9990.00 head "Optimal|Size|(Mb)"
col rssize for 9990.00 head "Curr|Size|(Mb)"
col hwmsize for 9990.00 head "High|Water|Mark|(Mb)"
col wraps for 999 head "W|R|A|P|S"
col extends for 990 head "E|X|T|E|N|D|S"
col shrinks for 990 head "S|H|R|I|N|K|S"
col aveshrink for 990.00 head "AVG|Shrink|(Mb)"
col gets head "Header|Gets"
col waits for 99990 head "Header|Waits"
col writes for 999,999,990 head "Total|Writes|Since|Startup|(Kb)"
col wpg for 9990 head "AVG|Writes|Per|HedGet|(bytes)"
set lines 132 pages 40 feed off
break on report
compute sum of gets on report
compute sum of waits on report
compute avg of aveshrink on report
compute avg of wpg on report

select name,
XACTS,
initial_extent/1048576 InitExt,
next_extent/1048576 NextExt,
min_extents MinExt,
max_extents MaxExt,
optsize/1048576 optsize,
RSSIZE/1048576 rssize,
HWMSIZE/1048576 hwmsize,
wraps,
extends,
shrinks,
aveshrink/1048576 aveshrink,
gets,
waits,
writes/1024 writes,
writes/gets wpg
from v$rollstat,v$rollname,dba_rollback_segs
where v$rollstat.usn=v$rollname.usn
and dba_rollback_segs.segment_id=v$rollname.usn
order by name
/ 


