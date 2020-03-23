select segment_type || ' header block'
from   dba_segments 
where  header_file  = <cursor P1>
and    header_block = <cursor P2>
union all
select segment_type || ' freelist group block'
from   dba_segments
where  header_file     = <cursor P1>
and    <cursor P2> between header_block + 1 and 
                          (header_block + freelist_groups)
and    freelist_groups > 1
union all
select segment_type || ' data block'
from   dba_extents
where  <cursor P2> between block_id and (block_id + blocks - 1)
and    file_id    = <cursor P1>
and    not exists (select 1 
                   from   dba_segments 
                   where  header_file  = <cursor P1>
                   and    header_block = <cursor P2>);







