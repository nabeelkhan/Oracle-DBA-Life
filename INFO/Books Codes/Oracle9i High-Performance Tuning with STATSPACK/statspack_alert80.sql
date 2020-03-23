--***********************************************************
--
--  STATSPACK alert report for the DBA
--
--  Created 8/4/2000 by Donald K. Burleson
--  www.dba-oracle.com
--
--  This script is provided free-of-charge by Don Burleson
--  and no portion of this script may be sold to anyone for any reason!
--
--  This script accepts the "number of days back" as an imput parameter
--
--  This script can be scheduled to run daily via cron or OEM
--  and e-mail the results to the on-call DBA
--
--***********************************************************


set pages 9999;
set feedback off;
set verify off;

column mydate heading 'Yr.  Mo Dy  Hr.' format a16
column file_name format a35
column reads  format 99,999,999
column writes format 99,999,999
column pct_of_tot  format 999

spool /tmp/statspack_alert.lst


prompt
prompt
prompt ***********************************************************
prompt  This will identify any single file who's read I/O
prompt  is more than 50% of the total read I/O of the database.
prompt
prompt  The "hot" file should be examined, and the hot table/index
prompt  should be identified using STATSPACK.
prompt
prompt  - The busy file should be placed on a disk device with
prompt    "less busy" files to minimize read delay and channel
prompt    contention.
prompt
prompt  - If small file has a hot small table, place the table
prompt    in the KEEP pool
prompt
prompt  - If the file has a large-table full-table scan, place
prompt    the table in the RECYCLE pool and turn on parallel query
prompt    for the table.
prompt ***********************************************************
prompt
prompt


select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phyrds-old.phyrds                 reads
--   ,
--   ((new.phyrds-old.phyrds)/
--   (
--   select
--      (newreads.value-oldreads.value) reads
--   from
--      perfstat.stats$sysstat oldreads,
--      perfstat.stats$sysstat newreads,
--      perfstat.stats$snapshot   sn1
--   where
--      sn.snap_id = sn1.snap_id
--   and
--      newreads.snap_id = sn.snap_id
--   and
--      oldreads.snap_id = sn.snap_id-1
--   and
--     oldreads.statistic# = 40
--   and
--     newreads.statistic# = 40
--   and
--     (newreads.value-oldreads.value) > 0
--   ))*100 pct_of_tot
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.filename = old.filename
and
   -- ********************************************************** 
   -- Low I/O values are misleading, so we filter for high I/O
   -- ********************************************************** 
   new.phyrds-old.phyrds > 100
and
-- ********************************************************** 
-- The following will allow you to choose a threshold
-- ********************************************************** 
-- (new.phyrds-old.phyrds)*4>  -- This is 25% of total
 (new.phyrds-old.phyrds)*2> -- This is 50% of total
-- (new.phyrds-old.phyrds)*1.25> -- This is 75% of total
-- ********************************************************** 
-- This subquery computes the sum of all I/O during the snapshot period
-- ********************************************************** 
(
select
   (newreads.value-oldreads.value) reads
from
   perfstat.stats$sysstat oldreads,
   perfstat.stats$sysstat newreads,
   perfstat.stats$snapshot   sn1
where
   sn.snap_id = sn1.snap_id
and
   newreads.snap_id = sn.snap_id
and
   oldreads.snap_id = sn.snap_id-1
and
  oldreads.statistic# = 40
and 
  newreads.statistic# = 40
and
  (newreads.value-oldreads.value) > 0
)
;


prompt
prompt
prompt ***********************************************************
prompt  This will identify any single file who's write I/O
prompt  is more than 50% of the total write I/O of the database.
prompt
prompt  The "hot" file should be examined, and the hot table/index
prompt  should be identified using STATSPACK.
prompt
prompt  - The busy file should be placed on a disk device with
prompt    "less busy" files to minimize write delay and channel
prompt    channel contention.
prompt
prompt  - If small file has a hot small table, place the table
prompt    in the KEEP pool
prompt
prompt ***********************************************************
prompt




select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phywrts-old.phywrts               writes
--   ,
--  ((new.phywrts-old.phywrts)/
--   (
--   select
--      (newwrites.value-oldwrites.value) writes
--   from
--      perfstat.stats$sysstat   oldwrites,
--      perfstat.stats$sysstat   newwrites,
--      perfstat.stats$snapshot  sn1
--   where
--      sn.snap_id = sn1.snap_id
--   and
--      newwrites.snap_id = sn.snap_id
--   and
--      oldwrites.snap_id = sn.snap_id-1
--   and
--     oldwrites.statistic# = 44
--   and
--     newwrites.statistic# = 44
--   and
--     (newwrites.value-oldwrites.value) > 0
--   ))*100 pct_of_tot
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.filename = old.filename
and
   -- ********************************************************** 
   -- Low I/O values are misleading, so we only take high values
   -- ********************************************************** 
   new.phywrts-old.phywrts > 100
and
-- ********************************************************** 
-- Here you can choose a threshold value
-- ********************************************************** 
-- (new.phyrds-old.phywrts)*4>  -- This is 25% of total
 (new.phyrds-old.phywrts)*2> -- This is 50% of total
-- (new.phyrds-old.phywrts)*1.25> -- This is 75% of total
-- ********************************************************** 
-- This subquery computes the sum of all I/O during the snapshot period
-- ********************************************************** 
(
select
   (newwrites.value-oldwrites.value) writes
from
   perfstat.stats$sysstat   oldwrites,
   perfstat.stats$sysstat   newwrites,
   perfstat.stats$snapshot  sn1
where
   sn.snap_id = sn1.snap_id
and
   newwrites.snap_id = sn.snap_id
and
   oldwrites.snap_id = sn.snap_id-1
and
  oldwrites.statistic# = 44
and 
  newwrites.statistic# = 44
and
  (newwrites.value-oldwrites.value) > 0
)
;



--***********************************************************
-- Alert when data buffer hit ratio is below threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  When the data buffer hit ratio falls below 90%, you
prompt  should consider adding to the db_block_buffer init.ora parameter
prompt
prompt  See p. 171 "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt

column bhr format 9.99
column mydate heading 'yr.  mo dy Hr.'

column logical_reads  format 999,999,999
column phys_reads     format 999,999,999
column phys_writes    format 999,999,999
column "BUFFER HIT RATIO" format 999

select
   to_char(snap_time,'yyyy-mm-dd HH24'),
--   a.value + b.value  "logical_reads",
--   c.value            "phys_reads",
--   d.value            "phys_writes",
   round(100 * (((a.value-e.value)+(b.value-f.value))-(c.value-g.value)) / ((a.value-e.value)+(b.value-f.value)))  
         "BUFFER HIT RATIO"
from 
   perfstat.stats$sysstat a, 
   perfstat.stats$sysstat b, 
   perfstat.stats$sysstat c, 
   perfstat.stats$sysstat d,
   perfstat.stats$sysstat e,
   perfstat.stats$sysstat f,
   perfstat.stats$sysstat g,
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   snap_time > sysdate-&1
and
   b.snap_id = sn.snap_id
and
   c.snap_id = sn.snap_id
and
   d.snap_id = sn.snap_id
and
   e.snap_id = sn.snap_id-1
and
   f.snap_id = sn.snap_id-1
and
   g.snap_id = sn.snap_id-1
and
   a.statistic# = 39
and
   e.statistic# = 39
and
   b.statistic# = 38
and
   f.statistic# = 38
and
   c.statistic# = 40
and
   g.statistic# = 40
and
   d.statistic# = 41
and
   round(100 * (((a.value-e.value)+(b.value-f.value))-(c.value-g.value)) / ((a.value-e.value)+(b.value-f.value))) < 90
--group by
   --to_char(snap_time,'yyyy-mm-dd HH24')
;




--***********************************************************
-- Alert when total disk sorts are below threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  When there are high disk sorts, you should investigate
prompt  increasing sort_area_size, or adding indexes to force index_full scans
prompt
prompt  See p. 167 "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt


column sorts_memory  format 999,999,999
column sorts_disk    format 999,999,999
column ratio format .9999999999999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   newmem.value-oldmem.value sorts_memory,
   newdsk.value-olddsk.value sorts_disk,
   (newdsk.value-olddsk.value)/(newmem.value-oldmem.value) ratio
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$sysstat newdsk,
   perfstat.stats$sysstat olddsk,
   perfstat.stats$snapshot   sn
where
   -- Where there are more than 100 disk sorts per hour
   newdsk.value-olddsk.value > 100
and
   snap_time > sysdate-&1
and
   newdsk.snap_id = sn.snap_id
and
   olddsk.snap_id = sn.snap_id-1
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'sorts (memory)'
and
   newmem.name = 'sorts (memory)'
and
   olddsk.name = 'sorts (disk)'
and
   newdsk.name = 'sorts (disk)'
and
   newmem.value-oldmem.value > 0
;



--***********************************************************
-- Alert when total I/O wait count is above threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  When there is high I/O waits, disk bottlenecks may exist
prompt  Run iostats to find the hot disk and shuffle files to
prompt  remove the contention 
prompt
prompt  See p. 191 "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt

break on snapdate skip 2

column snapdate format a16
column filename format a40

select 
   to_char(snap_time,'yyyy-mm-dd HH24') snapdate,
   old.filename,
   new.wait_count-old.wait_count waits
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   new.wait_count-old.wait_count > 800
and
   new.snap_id = sn.snap_id
and
   old.filename = new.filename
and
   old.snap_id = sn.snap_id-1
and 
   new.wait_count-old.wait_count > 0
;


--***********************************************************
-- Alert when average buffer busy waits exceed threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  Buffer Busy Waits may signal a high update table with too
prompt  few freelists.  Find the offending table and add more freelists. 
prompt
prompt  See p. 134 "Oracle SAP Administration" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt


column buffer_busy_wait format 999,999,999
column mydate heading 'yr.  mo dy Hr.'

select 
   to_char(snap_time,'yyyy-mm-dd HH24')      mydate,
   new.name,
   new.buffer_busy_wait-old.buffer_busy_wait buffer_busy_wait
from
   perfstat.stats$buffer_pool_statistics old,
   perfstat.stats$buffer_pool_statistics new,
   perfstat.stats$snapshot               sn
where
   snap_time > sysdate-&1
and
   new.name <> 'FAKE VIEW'
and
   new.name = old.name
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.buffer_busy_wait-old.buffer_busy_wait > 1
group by
   to_char(snap_time,'yyyy-mm-dd HH24'),
   new.name,
   new.buffer_busy_wait-old.buffer_busy_wait
;


--***********************************************************
-- Alert when total redo log space requests exceed threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  High redo log space requests indicate a need to increase
prompt  the log_buffer parameter
prompt
prompt
prompt ***********************************************************
prompt
prompt



column redo_log_space_requests  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   newmem.value-oldmem.value redo_log_space_requests
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   newmem.value-oldmem.value > 30
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'redo log space requests'
and
   newmem.name = 'redo log space requests'
and
   newmem.value-oldmem.value > 0
;


--***********************************************************
-- Alert when table_fetch_continued_row exceeds threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  Table fetch continued row indicates chained rows, or fetches of
prompt  long datatypes (long raw, blob)
prompt 
prompt  Investigate increasing db_block_size or reorganizing tables
prompt  with chained rows.
prompt
prompt  See p. 381 "High Performance Oracle8 Tuning" by Don Burleson
prompt  See p. 102 "Oracle SAP Administration" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt




column table_fetch_continued_row  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   avg(newmem.value-oldmem.value) table_fetch_continued_row
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'table fetch continued row'
and
   newmem.name = 'table fetch continued row'
and
   newmem.value-oldmem.value > 0
having 
   avg(newmem.value-oldmem.value) > 10000
group by
   to_char(snap_time,'yyyy-mm-dd HH24')
;


prompt
prompt
prompt ***********************************************************
prompt  Enqueue Deadlocks indicate contention within the Oracle
prompt  shared pool.
prompt 
prompt  Investigate increasing shared_pool_size 
prompt
prompt  See p. xxx "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt

column enqueue_deadlocks     format 999,999,999

select
   to_char(snap_time,'yyyy-mm-dd HH24'),
   a.value enqueue_deadlocks
from 
   perfstat.stats$sysstat     a, 
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   a.snap_id = sn.snap_id
and
   a.statistic# = 24
and
   a.value > 10
;



prompt
prompt
prompt ***********************************************************
prompt  Long-table full table scans can indicate a need to:
prompt
prompt        - Make the offending tables parallel query
prompt          (alter table xxx parallel degree yyy;)
prompt        - Place the table in the RECYCLE pool
prompt        - Build an index on the table to remove the FTS
prompt
prompt To locate the table, run access.sql
prompt 
prompt  See Oracle Magazine September 200 issue for details
prompt
prompt ***********************************************************
prompt


column fts  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   newmem.value-oldmem.value fts
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   newmem.value-oldmem.value > 1000
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.statistic# = 140
and
   newmem.statistic# = 140
and
   newmem.value-oldmem.value > 0
;

prompt
prompt
prompt ***********************************************************
prompt  Excessive waits on background events
prompt ***********************************************************
prompt


column mydate heading 'Yr.  Mo Dy Hr'     format a13;
column event                              format a30;
column total_waits    heading 'tot waits' format 999,999;
column time_waited    heading 'time wait' format 999,999;
column total_timeouts heading 'timeouts'  format 9,999;

break on to_char(snap_time,'yyyy-mm-dd') skip 1;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')           mydate,
   e.event,
   e.total_waits - nvl(b.total_waits,0)           total_waits,
   e.time_waited - nvl(b.time_waited,0)           time_waited,
   e.total_timeouts - nvl(b.total_timeouts,0)     total_timeouts
from 
   stats$bg_event_summary     b,
   stats$bg_event_summary     e,
   stats$snapshot     sn
where
   snap_time > sysdate-&1
and
   e.event not like '%timer' 
and 
   e.event not like '%message%'
and
   e.snap_id = sn.snap_id
and
   b.snap_id = e.snap_id-1
and
   b.event = e.event
and
   e.total_timeouts > 100
and
(
   e.total_waits - b.total_waits  > 100
   or
   e.time_waited - b.time_waited > 100
)
;

prompt
prompt
prompt ***********************************************************
prompt  Excessive event waits indicate shared pool contention
prompt ***********************************************************
prompt
prompt

set pages 999;
set lines 80;

column mydate heading 'Yr.  Mo Dy Hr'     format a13;
column event                              format a30;
column waits                              format 999,999;
column secs_waited                        format 999,999,999;
column avg_wait_secs                      format 99,999;

break on to_char(snap_time,'yyyy-mm-dd') skip 1;

select
   to_char(snap_time,'yyyy-mm-dd HH24')           mydate,
   e.event,
   e.total_waits - nvl(b.total_waits,0)           waits,
   ((e.time_waited - nvl(b.time_waited,0))/100) /
   nvl((e.total_waits - nvl(b.total_waits,0)),0)  avg_wait_secs
from
   stats$system_event b,
   stats$system_event e,
   stats$snapshot     sn
where
   snap_time > sysdate-&1
and
   e.snap_id = sn.snap_id
and
   b.snap_id = e.snap_id-1
and
   b.event = e.event
and
  (
   e.event like 'SQL*Net%'
   or
   e.event in (
      'latch free',
      'enqueue',
      'LGWR wait for redo copy',
      'buffer busy waits'
     )
   )
and
   e.total_waits - b.total_waits  > 100
and
   e.time_waited - b.time_waited > 100
;


prompt
prompt
prompt ***********************************************************
prompt  Excessive library cache miss ratio
prompt ***********************************************************
prompt
prompt

column c1 heading "execs"    format 9,999,999
column c2 heading "Cache Misses|While Executing"    format 9,999,999
column c3 heading "Library Cache|Miss Ratio"     format 999.99999


select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   sum(new.pins-old.pins)                c1,
   sum(new.reloads-old.reloads)          c2,
   sum(new.reloads-old.reloads)/
   sum(new.pins-old.pins)                library_cache_miss_ratio
from 
   stats$librarycache old,
   stats$librarycache new,
   stats$snapshot     sn
where
   snap_time > sysdate-&1
and
   new.snap_id = sn.snap_id
and
   old.snap_id = new.snap_id-1
and
   old.namespace = new.namespace
having
   sum(new.reloads-old.reloads)/
   sum(new.pins-old.pins) > .05
group by
   to_char(snap_time,'yyyy-mm-dd HH24')
;


prompt
prompt
prompt ***********************************************************
prompt  Excessive length of DBWR processes
prompt ***********************************************************
prompt
prompt



column c1 heading "Write request length" format 9,999.99
column c2 heading "Write Requests"       format 999,999
column c3 heading "DBWR checkpoints"     format 999,999

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
   snap_time > sysdate-&1
and
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

prompt
prompt
prompt ***********************************************************
prompt  Data Dictionary Miss Ratio below 90% indicates the need
prompt  to increase the shared_pool_size
prompt ***********************************************************
prompt
prompt

column c1     heading "Data|Dictionary|Gets"         format 999,999,999
column c2     heading "Data|Dictionary|Cache|Misses" format 999,999,999
column c3     heading "Data|Dictionary|Hit|Ratio"    format 999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   sum(new.gets-old.gets)                c1,
   sum(new.getmisses-old.getmisses)      c2,
   trunc((1-(sum(new.getmisses-old.getmisses)/sum(new.gets-old.gets)))*100) c3
from 
   stats$rowcache_summary new,
   stats$rowcache_summary old,
   stats$snapshot sn
where
   snap_time > sysdate-&1
and 
   new.snap_id = sn.snap_id
and
   old.snap_id = new.snap_id-1
having 
   trunc((1-(sum(new.getmisses-old.getmisses)/sum(new.gets-old.gets)))*100) < 90
group by
   to_char(snap_time,'yyyy-mm-dd HH24')
;

prompt
prompt
prompt ***********************************************************
prompt  Report when Data Dictionary Hit Ratio for an object
prompt    falls below 70%
prompt ***********************************************************
prompt
prompt

set lines 80;
set pages 999;

column mydate heading 'Yr.  Mo Dy  Hr.'              format a16
column parameter                                     format a20
column c1     heading "Data|Dictionary|Gets"         format 99,999,999
column c2     heading "Data|Dictionary|Cache|Misses" format 99,999,999
column c3     heading "Data|Dictionary|Usage"        format 999
column c4     heading "Object|Hit|Ratio"             format 999

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.parameter                         parameter,
   (new.gets-old.gets)                   c1,
   (new.getmisses-old.getmisses)         c2,
   (new.total_usage-old.total_usage)     c3,
  round((1 - (new.getmisses-old.getmisses) / 
  (new.gets-old.gets))*100,1)            c4
from 
   stats$rowcache_summary new,
   stats$rowcache_summary old,
   stats$snapshot         sn
where
   snap_time > sysdate-&1
and
  round((1 - (new.getmisses-old.getmisses) / 
  (new.gets-old.gets))*100,1) < 70
and
   (new.total_usage-old.total_usage) > 300 
and
   new.snap_id = sn.snap_id
and
   old.snap_id = new.snap_id-1
and
   old.parameter = new.parameter
and
   new.gets-old.gets > 0
;

spool off;
