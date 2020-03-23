set lines 80;
set pages 999;
set heading off;

select
   to_char(snap_time,'yyyy-mm-dd hh24'),
   substr(sql_text,1,50)
from
   stats$sql_summary a,
   stats$snapshot    sn
where
   a.snap_id = sn.snap_id
and
   to_char(snap_time,'hh24') = 10
or
   to_char(snap_time,'hh24') = 15
order by
   rows_processed desc;
