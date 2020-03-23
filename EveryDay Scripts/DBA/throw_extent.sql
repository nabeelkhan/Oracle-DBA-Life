set echo off
set feedback off
set linesize 512

prompt
prompt Segments that cannot extend
prompt

column segment_name format a32

select a.owner,
  decode(partition_name, null, segment_name, segment_name || ':' || partition_name) name,
       a.SEGMENT_TYPE, a.tablespace_name, a.bytes, a.initial_extent, 
       a.next_extent, a.PCT_INCREASE, a.extents, a.max_extents,
       b.free, b.remain
       ,decode(c.autoextensible, 0, 'NO', 'YES') autoextensible
       ,decode(c.autoextensible, 0, 0, c.morebytes) max_can_grow_by
       ,decode(c.autoextensible, 0, 0, c.totalmorebytes) sum_can_grow_by
from   dba_segments a,
       (select   df.tablespace_name, nvl(max(fs.bytes), 0) free, nvl(sum(fs.bytes), 0) remain
        from     dba_data_files df,
                 dba_free_space fs
        where    df.file_id = fs.file_id (+)
        group by df.tablespace_name) b
        ,(select  tablespace_name, max(maxbytes - bytes) morebytes,
                  sum(decode(AUTOEXTENSIBLE, 'YES', maxbytes - bytes, 0)) totalmorebytes,
                  sum(decode(AUTOEXTENSIBLE, 'YES', 1, 0)) autoextensible
         from     dba_data_files
         group by tablespace_name) c
where a.tablespace_name = b.tablespace_name
and   a.tablespace_name = c.tablespace_name
and   ((c.autoextensible = 0) or ((c.autoextensible > 0) and (a.next_extent > c.morebytes)))
and   a.next_extent > b.free
order by 5 desc, 3;