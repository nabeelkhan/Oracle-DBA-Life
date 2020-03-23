select segment_name, partition_name
from   dba_extents
where  <cursor P2> between block_id and (block_id + blocks - 1)
and    file_id    = <cursor P1>;






