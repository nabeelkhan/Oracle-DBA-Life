select b.file_id, b.file_name, a.count
from   x$kcbfwait a, dba_data_files b
where  a.indx   = b.file_id - 1
and    a.count  > 0
order by a.count;
