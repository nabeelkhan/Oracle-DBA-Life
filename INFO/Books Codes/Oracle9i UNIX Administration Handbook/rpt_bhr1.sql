select 
   to_char(e_sn.snap_time,'yyyy-mm-dd HH24') "End Date Hour",
   to_char(e_sn.snap_time,'Day') "Day",
   to_char((e_sn.SNAP_TIME - b_sn.SNAP_TIME)*24,'90.9')||' H ' "Interval",
-- e_cg.value + e_bg.value "logical_reads",
-- e_pr.value "phys_reads",
-- e_bc.value "phys_writes",
   round(100 * (((e_cg.value-b_cg.value)+(e_bg.value-b_bg.value))-(e_pr.value-b_pr.value))
   / ((e_cg.value-b_cg.value)+(e_bg.value-b_bg.value))) "BUFFER HIT RATIO"
from
   perfstat.stats$sysstat e_cg,
   perfstat.stats$sysstat e_bg,
   perfstat.stats$sysstat e_pr,
   perfstat.stats$sysstat e_bc,
   perfstat.stats$sysstat b_cg,
   perfstat.stats$sysstat b_bg,
   perfstat.stats$sysstat b_pr,
   perfstat.stats$snapshot e_sn,
   perfstat.stats$snapshot b_sn
where
-- get the ending statistics
   e_cg.snap_id = e_sn.snap_id
and 
   e_bg.snap_id = e_sn.snap_id
and 
   e_pr.snap_id = e_sn.snap_id
and 
   e_bc.snap_id = e_sn.snap_id
-- get the ending statistics
and 
   b_cg.snap_id = e_cg.snap_id-1
and 
   b_bg.snap_id = e_bg.snap_id-1
and 
   b_pr.snap_id = e_pr.snap_id-1
-- get the previous snapshot
and 
  b_sn.snap_id = e_sn.snap_id - 1
-- get the right statistics
and 
  e_cg.statistic# = 39 
and 
  b_cg.statistic# = 39 -- consistent gets
and 
  e_bg.statistic# = 38 
and 
   _bg.statistic# = 38 -- db block gets
and 
   e_pr.statistic# = 40 
and 
   b_pr.statistic# = 40 -- physical reads
and 
  e_bc.statistic# = 41 -- db block changes
/






