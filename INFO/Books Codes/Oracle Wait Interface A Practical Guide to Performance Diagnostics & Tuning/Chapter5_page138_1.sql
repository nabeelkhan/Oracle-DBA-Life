select round((a.value / b.value) + 0.5,0) as avg_redo_blks_per_write,
       round((a.value / b.value) + 0.5,0) * c.lebsz as avg_io_size
from   v$sysstat a, v$sysstat b, x$kccle c
where  c.lenum = 1
and    a.name  = 'redo blocks written'
and    b.name  = 'redo writes';
