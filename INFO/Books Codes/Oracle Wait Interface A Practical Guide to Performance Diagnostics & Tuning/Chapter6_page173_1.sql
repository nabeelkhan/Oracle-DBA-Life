select * 
from   x$ksqeq
where  bitand(kssobflg,1)!=0 
and   (ksqlkmod!=0 or ksqlkreq!=0);

-- or simply query from V$ENQUEUE_LOCK
select * from v$enqueue_lock;
