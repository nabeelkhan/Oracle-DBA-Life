col snap_id for 999999
col begin_interval_time for a26
col end_interval_time for a26
select snap_id, dbid, begin_interval_time, end_interval_time
from  dba_hist_snapshot
order by 1 desc;









