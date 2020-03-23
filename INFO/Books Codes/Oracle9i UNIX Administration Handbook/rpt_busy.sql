select
   sysdate,
   substr(tablespace_name,1,14),
   p2
from v$session_wait a, dba_data_files b
where
a.p1 = b.file_id
and
event = 'db file sequential read'
;

select 
   sysdate,
   substr(tablespace_name,1,14),
   p2
from v$session_wait a, dba_data_files b
where
a.p1 = b.file_id
and
event = 'buffer busy waits'
;
