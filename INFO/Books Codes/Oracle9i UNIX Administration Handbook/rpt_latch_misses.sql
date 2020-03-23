column parent_name   format a33
column where_in_code format a10
column avg_nwfail    format 9,999,999
column avg_sleep     format 9,999,999


break on snap_date skip 2;

select 
   to_char(snap_time,'mm-dd-yy') snap_date,
   parent_name,
   where_in_code, 
   avg(nwfail_count)             avg_nwfail,
   avg(sleep_count)              avg_sleep
from 
   stats$latch_misses_summary    lms,
   stats$snapshot                sn
where
   lms.snap_id = sn.snap_id
--and
--  to_char(snap_time,'mm-dd-yy') = to_char(sysdate-9,'mm-dd-yy')
group by
   to_char(snap_time,'mm-dd-yy'),
   parent_name,
   where_in_code
;
