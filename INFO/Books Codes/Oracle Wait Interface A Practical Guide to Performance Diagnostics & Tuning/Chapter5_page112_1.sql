select a.file#,
       b.file_name,
       a.singleblkrds,
       a.singleblkrdtim,
       a.singleblkrdtim/a.singleblkrds average_wait
from   v$filestat a, dba_data_files b
where  a.file# = b.file_id
and    a.singleblkrds > 0
order by average_wait;

