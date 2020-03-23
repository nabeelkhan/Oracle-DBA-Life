select disk_reads, buffer_gets,sql_text
from   v$sqlarea
--where  disk_reads > 10000
where  buffer_gets  > 200000
--order by disk_reads desc
order by buffer_gets desc
/
