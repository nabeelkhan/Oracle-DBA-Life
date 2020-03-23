set pages 9999;
connect perfstat/perfstat;


drop table g1;
create table g1 as
select 
   to_char(snap_time,'yyyy-mm-dd') snap_date,
   sum(bytes)                      sum_tab_bytes
from 
   stats$tab_stats
group by
   to_char(snap_time,'yyyy-mm-dd')
;
 
drop table g2;
create table g2 as
select 
   to_char(snap_time,'yyyy-mm-dd') snap_date,
   sum(bytes)                      sum_idx_bytes
from 
   stats$idx_stats
group by
   to_char(snap_time,'yyyy-mm-dd')
;

select * from g1;

select * from g2;

column tot_bytes  format 999,999,999,999,999

select 
   tab.snap_date,
   sum_tab_bytes + sum_idx_bytes tot_bytes
from
   g1 tab,
   g2 idx
where
   tab.snap_date = idx.snap_date
;
