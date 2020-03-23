select wh.kcbwhdes "module",
       sw.why0 "calls",
       sw.why2 "waits",
       sw.other_wait "caused waits"
from   x$kcbwh wh,
       x$kcbsw sw
where wh.indx = sw.indx
  and sw.other_wait > 0
order by sw.other_wait;


















