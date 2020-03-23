select 'Segment Header' class, 
       a.segment_type, a.segment_name, a.partition_name
from   dba_segments a, v$session_wait b
where  a.header_file  = b.p1
and    a.header_block = b.p2
and    b.event        = 'buffer busy waits'
union
select 'Freelist Groups' class, 
       a.segment_type, a.segment_name, a.partition_name
from   dba_segments a, v$session_wait b
where  b.p2 between a.header_block + 1 and (a.header_block + a.freelist_groups)
and    a.header_file     = b.p1
and    a.freelist_groups > 1
and    b.event           = 'buffer busy waits'
union
select a.segment_type || ' block' class, 
       a.segment_type, a.segment_name, a.partition_name
from   dba_extents a, v$session_wait b
where  b.p2 between a.block_id and a.block_id + a.blocks - 1
and    a.file_id  = b.p1
and    b.event    = 'buffer busy waits'
and    not exists (select 1 
                   from   dba_segments 
                   where  header_file  = b.p1
                   and    header_block = b.p2);
