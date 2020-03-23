set lines 80;
set pages 999;

column mydate heading 'Yr.  Mo Dy  Hr.'      format a16
column c1     heading "Tot SQL"              format 999,999,999
column c2     heading "Single Use SQL"       format 999,999
column c3     heading "Percent re-used SQL"  format 999,999
column c4     heading "Total SQL RAM"        format 999,999,999

break on mydate skip 2;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   total_sql                             c1,
   single_use_sql                        c2,
   (single_use_sql/total_sql)*100        c3,
   total_sql_mem                         c4
from 
   stats$sql_statistics sq,
   stats$snapshot       sn
where
   sn.snap_id = sq.snap_id
;

