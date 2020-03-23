set pages 9999;

column bhr format 9.99
column mydate heading 'yr.  mo dy Hr.'

select 
   to_char(snap_time,'yyyy-mm-dd HH24')      mydate,
   new.name                                  buffer_pool_name,
   (((new.consistent_gets-old.consistent_gets)+
   (new.db_block_gets-old.db_block_gets))-
   (new.physical_reads-old.physical_reads))
   /
   ((new.consistent_gets-old.consistent_gets)+
   (new.db_block_gets-old.db_block_gets))    bhr
from
   perfstat.stats$buffer_pool_statistics old,
   perfstat.stats$buffer_pool_statistics new,
   perfstat.stats$snapshot               sn
where
   new.name = old.name
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
;
