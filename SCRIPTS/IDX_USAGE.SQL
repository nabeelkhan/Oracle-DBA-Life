column owner format a20 trunc     
column segment_name format a30 trunc    
PROMPT
PROMPT Script ran from D:\NABEEL\DBA\SCRIPTS\ES40
PROMPT Script IDX_USAGE.SQL
PROMPT
PROMPT
PROMPT This script will list the most recently used Indexes
select distinct b.owner, b.segment_name
from x$bh a, dba_extents b
where b.file_id=a.dbarfil 
and a.dbablk between b.block_id and b.block_id+blocks-1 
and  segment_type='INDEX'
and  b.owner not in ('SYS','SYSTEM'); 
