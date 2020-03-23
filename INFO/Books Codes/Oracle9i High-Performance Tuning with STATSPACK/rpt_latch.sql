
column parent_name   format a33
column where_in_code format a10
column sum_nwfail    format 9,999,999
column sum_sleep     format 9,999,999

column name     format a31              heading 'Latch Name' trunc;
column gets     format 999,999,990      heading 'Get|Requests';
column missed   format 990.9            heading 'Pct|Get|Miss';
column sleeps   format 990.9            heading 'Avg|Sleeps|/Miss';
column nowai    format 99,999,990       heading 'Nowait|Requests';
column imiss    format 990.9            heading 'Pct|Nowait|Miss';

drop table temp1;
create table temp1 as
select
   to_char(snap_time,'mm-dd-yy') stats_day,
   min(snap_id)                  min_snap,
   max(snap_id)                  max_snap
from
   stats$snapshot
group by
  to_char(snap_time,'mm-dd-yy')
;

--  Note:  This query requires that the database be up for each entire day
--  If the database is shut-down, and accumulators will be re-set,
--  giving misleading results
select 
   stats_day,
   b.name
     , e.gets    - b.gets                                gets
     , to_number(decode(e.gets, b.gets, null,
       (e.misses - b.misses) * 100/(e.gets - b.gets)))   missed
     , to_number(decode(e.misses, b.misses, null,
       (e.sleeps - b.sleeps)/(e.misses - b.misses)))     sleeps
     , e.immediate_gets - b.immediate_gets               nowai
     , to_number(decode(e.immediate_gets,
                        b.immediate_gets, null,
                      (e.immediate_misses - b.immediate_misses) * 100 /
                        (e.immediate_gets   - b.immediate_gets)))     imiss
from 
   stats$latch         b,
   stats$latch         e,
   temp1
where
   b.snap_id = min_snap
and
   e.snap_id = max_snap
and
   b.name = e.name
and
(
     e.gets-b.gets > 0
or
     to_number(decode(e.gets, b.gets, null,
     (e.misses - b.misses) * 100/(e.gets - b.gets))) > 0
or
     to_number(decode(e.misses, b.misses, null,
       (e.sleeps - b.sleeps)/(e.misses - b.misses)))     > 0
or
     e.immediate_gets - b.immediate_gets               > 0
or
     to_number(decode(e.immediate_gets,
                        b.immediate_gets, null,
                      (e.immediate_misses - b.immediate_misses) * 100 /
                      (e.immediate_gets   - b.immediate_gets))) > 0 
)
;
