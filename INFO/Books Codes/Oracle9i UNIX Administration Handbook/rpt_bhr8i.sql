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
   new.name in ('DEFAULT','FAKE VIEW')
and
   (((new.consistent_gets-old.consistent_gets)+
   (new.db_block_gets-old.db_block_gets))-
   (new.physical_reads-old.physical_reads))
   /
   ((new.consistent_gets-old.consistent_gets)+
   (new.db_block_gets-old.db_block_gets)) < .90
and
   new.name = old.name
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.consistent_gets > 0
and
   old.consistent_gets > 0
;
